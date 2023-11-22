defmodule KinoLiveViewNative.PortChecker do
  def port_available?(port) do
    {os_pids, _} = System.cmd("lsof", ["-t", "-i", "tcp:#{port}"])
    os_pids == ""
  end

  def port_in_use?(port), do: not port_available?(port)

  # 5 attempts maximum to avoid infinite recursion
  def kill_processes(port, attempts \\ 0)
  def kill_processes(port, 5), do: raise("Failed to shutdown server running on port #{port}")

  def kill_processes(port, attempts) do
    :os.cmd(:"lsof -t -i tcp:#{port} | xargs kill")
    # allow time between shutdown attempts
    Process.sleep(100)

    if port_in_use?(port) do
      kill_processes(port, attempts + 1)
    end
  end
end
