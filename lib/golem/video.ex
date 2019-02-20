defmodule Golem.Video do
  @moduledoc """
  Handles video transcoding jobs
  """
  use Que.Worker, concurrency: 4
  require Logger

  alias Animu.Media
  alias Animu.Media.Anime.Video
  alias Animu.Repo

  def perform(path: path, num: num, anime: anime) do
    with {:ok, video} <- Video.new(path, anime.directory),
                   ep <- find_ep(anime.episodes, num),
            {:ok, ep} <- Media.update_episode(ep, video) do
      #TODO notify success
      {:ok, ep}
    else
      # {:error, msg} when is_binary(msg) -> raise msg
      error ->
        Logger.error "Video Conjure Error: #{inspect error}"
        raise "Video Conjure Failed"
    end
  end

  defp find_ep(episodes, number) do
    Enum.find(episodes, fn ep -> ep.number == number end)
  end

  def on_failure([path: path, num: num, anime: anime], error) do
    Logger.error("Video Conjuring Error: #{inspect(error)}")
  end
end
