defmodule Main do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Dbparser.DepartureBoardServer, []),
      worker(Dbparser.PrinterServer, [])
    ]

    opts = [strategy: :one_for_one, name: Sequence.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
