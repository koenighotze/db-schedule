defmodule Dbparser.LocalFileHttpFetcher do
  import Logger

  @behaviour Dbparser.Http
  @location_service_url Application.get_env(:dbparser, :location_service_url)
  @departure_service_url Application.get_env(:dbparser, :departure_service_url)
  @data_location_dir Application.get_env(:dbparser, :http_fetcher_data_location_dir) || "test/data/"

  def get(url, _params) do
    debug("Loading #{url} in mock mode")

    content = case url do
      @location_service_url -> location_data
      @departure_service_url -> departure_data
      _ -> journey_details_data
    end

    {:ok, content}
  end

  def location_data do
    File.read! "#{@data_location_dir}/location.json" |> String.replace("\n", " ")
  end

  def departure_data do
    File.read! "#{@data_location_dir}/departure.json" |> String.replace("\n", " ")
  end

  def journey_details_data do
    File.read! "#{@data_location_dir}/journey_details.json" |> String.replace("\n", " ")
  end
end
