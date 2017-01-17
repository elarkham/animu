defmodule Owl.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Redix, [[], [name: :redix]]),
      worker(Owl.Reader, [[], [name: :owl_reader]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
