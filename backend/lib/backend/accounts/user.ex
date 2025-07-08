defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :role, :string, default: "user"
    field :is_admin, :boolean, default: false

    timestamps()
  end

  # changeset per la creazione di un utente, hashando la password
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8, max: 24)
    |> validate_password_complexity()
    |> put_password_hash()
  end

  # hash la password se presente
  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end

  # changeset per l'aggiornamento di un utente
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :is_admin])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8, max: 12)
    |> validate_password_complexity()
    |> put_password_hash()
  end

  # changeset per la modifica della password
  def change_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 12)
    |> validate_password_complexity()
    |> put_password_hash()
  end

  defp validate_password_complexity(changeset) do
    password = get_change(changeset, :password, "")

    regex = ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).+$/

    if password != "" and not Regex.match?(regex, password) do
      add_error(changeset, :password, "La password deve contenere almeno una maiuscola, una minuscola, un numero e un carattere speciale")
    else
      changeset
    end
  end
end
