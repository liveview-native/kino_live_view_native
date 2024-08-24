defmodule Server.CodeReloader do
  require Logger

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def reload!(endpoint, opts) do
    GenServer.call(__MODULE__, {:reload!, endpoint, opts}, :infinity)
  end


  def handle_call({:reload!, _endpoint, _opts},_from, state) do
    # This transaction ensures that this function is only called once during the code reload.
    # This change was due to an error where the web app.js would not load properly and web event handlers were broken
    Mix.in_install_project(fn ->
      # Fixed in future Hex, but needed for now
      # This reloads the stylesheet and any other files that need to recompile.
      _ = Application.ensure_all_started(:hex)
      Mix.Task.rerun("deps.compile", ["kino_live_view_native"])
      Mix.Task.clear()
      :ok
    end)

    {:reply, :ok, state}
  end
end
