defmodule Server.CodeReloader do
  @moduledoc false
  use GenServer

  require Logger
  alias Phoenix.CodeReloader.Proxy

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def check_symlinks do
    GenServer.call(__MODULE__, :check_symlinks, :infinity)
  end

  def reload!(endpoint, opts) do
    GenServer.call(__MODULE__, {:reload!, endpoint, opts}, :infinity)
  end

  def sync do
    pid = Process.whereis(__MODULE__)
    ref = Process.monitor(pid)
    GenServer.cast(pid, {:sync, self(), ref})

    receive do
      ^ref -> :ok
      {:DOWN, ^ref, _, _, _} -> :ok
    end
  end

  ## Callbacks

  def init(:ok) do
    {:ok, %{check_symlinks: true, timestamp: timestamp()}}
  end

  def handle_call(:check_symlinks, _from, state) do
    if state.check_symlinks and Code.ensure_loaded?(Mix.Project) and not Mix.Project.umbrella?() do
      priv_path = "#{Mix.Project.app_path()}/priv"

      case :file.read_link(priv_path) do
        {:ok, _} ->
          :ok

        {:error, _} ->
          if can_symlink?() do
            File.rm_rf(priv_path)
            Mix.Project.build_structure()
          else
            Logger.warning(
              "Phoenix is unable to create symlinks. Phoenix's code reloader will run " <>
                "considerably faster if symlinks are allowed." <> os_symlink(:os.type())
            )
          end
      end
    end

    {:reply, :ok, %{state | check_symlinks: false}}
  end

  def handle_call({:reload!, endpoint, _opts}, from, state) do
    # We do a backup of the endpoint in case compilation fails.
    # If so we can bring it back to finish the request handling.
    backup = load_backup(endpoint)
    froms = all_waiting([from], endpoint)

    {res, out} =
      proxy_io(fn ->
        try do
          # Must compile from the install project in order to avoid the following error:
          # Cannot access build without an application name,
          # please ensure you are in a directory with a mix.exs file and it defines an :app name under the project configuration
          # Occasionally we still experience issues where the LiveView modules won't be loaded such as:
          # a function ServerWeb.ExampleLive.__live__/0 is undefined or private
          # However, these errors do not cause major issues as the app simply reloads
          Mix.in_install_project(fn ->
            _ = Application.ensure_all_started(:hex)
            Mix.Task.rerun("deps.compile", ["kino_live_view_native"])
            Mix.Task.clear()
          end)
        catch
          :exit, {:shutdown, 1} ->
            :error

          kind, reason ->
            IO.puts(Exception.format(kind, reason, __STACKTRACE__))
            :error
        end
      end)

    reply =
      case res do
        :ok ->
          :ok

        :error ->
          write_backup(backup)
          {:error, IO.iodata_to_binary(out)}
      end

    Enum.each(froms, &GenServer.reply(&1, reply))
    {:noreply, %{state | timestamp: timestamp()}}
  end

  def handle_cast({:sync, pid, ref}, state) do
    send(pid, ref)
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp os_symlink({:win32, _}),
    do:
      " On Windows, the lack of symlinks may even cause empty assets to be served. " <>
        "Luckily, you can address this issue by starting your Windows terminal at least " <>
        "once with \"Run as Administrator\" and then running your Phoenix application."

  defp os_symlink(_),
    do: ""

  defp can_symlink?() do
    build_path = Mix.Project.build_path()
    symlink = Path.join(Path.dirname(build_path), "__phoenix__")

    case File.ln_s(build_path, symlink) do
      :ok ->
        File.rm_rf(symlink)
        true

      {:error, :eexist} ->
        File.rm_rf(symlink)
        true

      {:error, _} ->
        false
    end
  end

  defp load_backup(mod) do
    mod
    |> :code.which()
    |> read_backup()
  end

  defp read_backup(path) when is_list(path) do
    case File.read(path) do
      {:ok, binary} -> {:ok, path, binary}
      _ -> :error
    end
  end

  defp read_backup(_path), do: :error

  defp write_backup({:ok, path, file}), do: File.write!(path, file)
  defp write_backup(:error), do: :ok

  defp all_waiting(acc, endpoint) do
    receive do
      {:"$gen_call", from, {:reload!, ^endpoint, _}} -> all_waiting([from | acc], endpoint)
    after
      0 -> acc
    end
  end

  defp timestamp, do: System.system_time(:second)

  defp proxy_io(fun) do
    original_gl = Process.group_leader()
    {:ok, proxy_gl} = Proxy.start()
    Process.group_leader(self(), proxy_gl)

    try do
      {fun.(), Proxy.stop(proxy_gl)}
    after
      Process.group_leader(self(), original_gl)
      Process.exit(proxy_gl, :kill)
    end
  end
end
