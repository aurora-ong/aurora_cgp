defmodule AuroraCGP.Projector.OU do
  @moduledoc """
  The Persons context.
  """

  import Ecto.Query, warn: false

  alias AuroraCGP.Projector.Repo
  alias AuroraCGP.Projector.Model.OU

  ## Database getters

  def get_all_active_ou() do
    Repo.all(OU, where: ou_status = :active)
  end

  def get_all_ou() do
    Repo.all(OU)
  end

  def get_ou_by_id(id) do
    Repo.get(OU, id)
  end

end
