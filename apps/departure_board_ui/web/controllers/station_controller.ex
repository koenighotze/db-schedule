defmodule DepartureBoardUi.StationController do
  use DepartureBoardUi.Web, :controller

  alias DepartureBoardUi.Station

  plug :scrub_params, "station" when action in [:create, :update]

  def index(conn, _params) do
    stations = Repo.all(Station)

    render(conn, "index.json", stations: stations)
  end

  def create(conn, %{"station" => station_params}) do
    changeset = Station.changeset(%Station{}, station_params)

    case Repo.insert(changeset) do
      {:ok, station} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", station_path(conn, :show, station))
        |> render("show.json", station: station)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DepartureBoardUi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    station = Repo.get!(Station, id)
    render(conn, "show.json", station: station)
  end

  def update(conn, %{"id" => id, "station" => station_params}) do
    station = Repo.get!(Station, id)
    changeset = Station.changeset(station, station_params)

    case Repo.update(changeset) do
      {:ok, station} ->
        render(conn, "show.json", station: station)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DepartureBoardUi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    station = Repo.get!(Station, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(station)

    send_resp(conn, :no_content, "")
  end
end
