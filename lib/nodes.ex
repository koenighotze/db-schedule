defmodule Dbparser.Nodes do
  def node_one, do: :"one@127.0.0.1"

  def connect_to_node(node_name) do
    Node.connect(node_name)
  end
end
