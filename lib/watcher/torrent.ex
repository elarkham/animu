defmodule Animu.Torrent do
  defstruct ep_id: nil,
            ep_num: nil,
            url: nil,
            dir: nil,
            name: nil,
            feed_url: nil,
            id: nil,
            progress: 0.0,
            finished: false
end
