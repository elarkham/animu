defmodule Animu.Media.Anime.Episode do
  @moduledoc """
  Data format for Anime episodes
  """
  use Animu.Ecto.Schema

  alias Animu.Media.Anime
  alias Animu.Media.Anime.Video
  alias __MODULE__

  schema "episodes" do
    field :name,          :string
    field :titles,        {:map, :string}
    field :synopsis,      :string

    field :number,        :float
    field :rel_number,    :float

    field :airdate,       :date
    field :augured_at,    :date

    field :kitsu_id,      :string

    belongs_to :anime, Anime
    embeds_one :video, Video, on_replace: :delete

    field :video_path, :string, virtual: true

    timestamps()
  end

  def new(number) do
    name_num = format_number(number)
    %Episode{
      name: "Episode #{name_num}",
      number: (number / 1)
    }
  end
  def new(number, video_path, anime_dir) do
    ep = new(number)
    case Video.new(video_path, anime_dir) do
       {:ok, video} -> {:ok, %Episode{ep | video: video}}
      {:error, msg} -> {:error, msg}
    end
  end

  ## Video Conjuring
  # From Changeset
  def conjure_video(%Changeset{valid?: false} = ch), do: ch
  def conjure_video(%Changeset{changes: %{video_path: _}} = ch) do
    anime =
      ch
      |> get_field(:anime_id)
      |> Animu.Media.get_anime!()

    conjure_video(ch, anime.directory)
  end
  def conjure_video(%Changeset{} = ch), do: ch
  def conjure_video(%Changeset{changes: %{video_path: path}} = ch, anime_dir) do
    case Video.Invoke.new(path, anime_dir) do
          {:ok, video} -> put_embed(ch, :video, video)
      {:error, reason} -> add_error(ch, :video_path, reason)

      error ->
        {:error, "unexpected error while conjuring video: #{error}"}
    end
  end
  def conjure_video(%Changeset{} = ch, _), do: ch

  ## Lazy Functions
  def new_lazy(number, video_path) do
    golem = {Golem.Video, path: video_path, num: number}
    ep = new(number)
    {ep, golem}
  end
  def conjure_video_lazy(%Episode{video: video} = ep) do
    golem = {Golem.Video, path: video.original, num: ep.number}
    {ep.number, golem}
  end

  ## Utility
  defp format_number(int) when is_integer(int), do: int
  defp format_number(float) when is_float(float) do
    case Float.ratio(float) do
      {int, 1} -> int
      _        -> float
    end
  end
end
