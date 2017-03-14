defmodule Animu.Media.Franchise do
  use Ecto.Schema

  alias Animu.Media.Series

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "franchises" do
    field :canon_title,   :string
    field :titles,        :map
    field :creator,       :string
    field :synopsis,      :string
    field :slug,          :string

    field :cover_image,   :map
    field :poster_image,  :map
    field :gallery,       :map

    field :trailers,      {:array, :string}
    field :tags,          {:array, :string}

    has_many :series, Series

    field :date_released, :date

    timestamps()
  end

end
