defmodule Workbench.SelectedNodeTest do
  use ExUnit.Case, async: false

  @test_id __MODULE__

  test "get returns the name of the current node" do
    start_supervised!({Workbench.SelectedNode, [id: @test_id]})

    assert Workbench.SelectedNode.get(@test_id) == "nonode@nohost"
    assert Workbench.SelectedNode.get() == "nonode@nohost"
  end

  test "put sets the name of the current node" do
    start_supervised!({Workbench.SelectedNode, [id: @test_id]})

    assert Workbench.SelectedNode.put("node_name@node_host", @test_id) == :ok
    assert Workbench.SelectedNode.get(@test_id) == "node_name@node_host"
    assert Workbench.SelectedNode.get() == "nonode@nohost"
  end
end
