defmodule DepartureBoardUi.DepartureBoard do
  use DepartureBoardUi.Web, :model

  schema "departure_boards" do
    field :token, :string
    field :station_name, :string
    field :time, :string
    field :date, :string
    field :direction, :string

    timestamps
  end

  @required_fields ~w(token station_name time date direction)
  @optional_fields ~w()


  def by_token(token) do
    from b in DepartureBoardUi.DepartureBoard, where: b.token == ^"#{token}"
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
