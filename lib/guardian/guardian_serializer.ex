defmodule Animu.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Animu.Repo
  alias Animu.Account.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(User, String.to_integer(id)) }
  def from_token(_), do: { :error, "Unkown resource type" }

end
