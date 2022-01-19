defmodule AppWeb.CuboidController do
  use AppWeb, :controller

  alias App.Store
  alias App.Store.Cuboid

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    cuboids = Store.list_cuboids()
    render(conn, "index.json", cuboids: cuboids)
  end

  def create(conn, %{"bag_id" => bag_id} = cuboid_params) do
    with :ok <- Store.validate_bag(bag_id),
         {:ok, %Cuboid{} = cuboid} <- Store.create_cuboid(cuboid_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.cuboid_path(conn, :show, cuboid))
      |> render("show.json", cuboid: cuboid)
    end
  end

  def show(conn, %{"id" => id}) do
    case Store.get_cuboid(id) do
      nil -> conn |> send_resp(404, "")
      cuboid -> render(conn, "show.json", cuboid: cuboid)
    end
  end

  def update(conn, %{"id" => id} = cuboid_params) do
    with {:ok, %Cuboid{} = cuboid} <- Store.update_cuboid(id, cuboid_params) do
      conn
      |> put_resp_header("location", Routes.cuboid_path(conn, :show, cuboid))
      |> render("show.json", cuboid: cuboid)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Cuboid{} = cuboid} <- Store.delete_cuboid(id) do
      conn
      |> put_resp_header("location", Routes.cuboid_path(conn, :show, cuboid))
      |> render("show.json", cuboid: cuboid)
    end
  end
end
