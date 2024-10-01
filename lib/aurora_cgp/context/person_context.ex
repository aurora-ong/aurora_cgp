defmodule AuroraCGP.Context.PersonContext do
  @moduledoc """
  The Persons context.
  """

  import Ecto.Query, warn: false
  alias AuroraCGP.Auth
  alias AuroraCGP.Projector.Repo
  alias AuroraCGP.Projector.Model.Person

  alias AuroraCGP.Auth.AuthToken

  def register_person(person_params) do
    {:ok, person} =
      person_params
      |> AuroraCGP.Command.RegisterPerson.new()
      |> Ecto.Changeset.apply_changes()
      |> AuroraCGP.dispatch(consistency: :eventual, returning: :aggregate_state)

      person.person_id
  end

  def register_person!(person_params) do
    {:ok, person} =
      person_params
      |> AuroraCGP.Command.RegisterPerson.new()
      |> Ecto.Changeset.apply_changes()
      |> AuroraCGP.dispatch(consistency: :strong, returning: :aggregate_state)

    get_person!(person.person_id)
  end

  ## Database getters

  @doc """
  Gets a person by email.

  ## Examples

      iex> get_person_by_email("foo@example.com")
      %Person{}

      iex> get_person_by_email("unknown@example.com")
      nil

  """
  def get_person_by_email(email) when is_binary(email) do
    Repo.get_by(Person, email: email)
  end

  @doc """
  Gets a person by email and password.

  ## Examples

      iex> get_person_by_email_and_password("foo@example.com", "correct_password")
      %Person{}

      iex> get_person_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_person_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    person = Repo.get_by(Person, person_mail: email)
    if Auth.valid_password?(person, password), do: person
  end

  @doc """
  Gets a person by id and password.

  ## Examples

      iex> get_person_by_email_and_password("foo@example.com", "correct_password")
      %Person{}

      iex> get_person_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_person_by_id_and_password(id, password)
      when is_binary(id) and is_binary(password) do
    person = Repo.get_by(Person, person_id: id)
    if Auth.valid_password?(person, password), do: person
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)


  ## Session

  @doc """
  Generates a session token.
  """
  def generate_person_session_token(person) do
    {token, person_token} = AuthToken.build_session_token(person)
    Repo.insert!(person_token)
    token
  end

  @doc """
  Gets the person with the given signed token.
  """
  def get_person_by_session_token(token) do
    {:ok, query} = AuthToken.verify_session_token_query(token)
    IO.inspect("OK");
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_person_session_token(token) do
    Repo.delete_all(AuthToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given person.

  ## Examples

      iex> deliver_person_confirmation_instructions(person, &url(~p"/persons/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_person_confirmation_instructions(confirmed_person, &url(~p"/persons/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_person_confirmation_instructions(
        %Person{} = _person,
        confirmation_url_fun
      )
      when is_function(confirmation_url_fun, 1) do
    # if person.confirmed_at do
    #   {:error, :already_confirmed}
    # else
    #   {encoded_token, person_token} = AuthToken.build_email_token(person, "confirm")
    #   Repo.insert!(person_token)

    #   PersonNotifier.deliver_confirmation_instructions(
    #     person,
    #     confirmation_url_fun.(encoded_token)
    #   )
    # end
  end

end
