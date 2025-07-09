defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}

  # aggiungo tutti i dati dell'utente (tranne i campi sensibili) nei claims
  def build_claims(claims, user, _opts) do
    user_map =
      user
      |> Map.from_struct()
      |> Map.drop([:__meta__, :__struct__, :password, :password_hash, :inserted_at, :updated_at])

    claims = Map.merge(claims, %{"user" => user_map})
    {:ok, claims}
  end

  # recupero l'utente direttamente dai claims
  def resource_from_claims(%{"user" => user_map}) when is_map(user_map) do
    {:ok, struct(Backend.Accounts.User, user_map)}
  end

  # se non trovo l'utente nei claims,
  # fallback: recupero l'utente dal database tramite id
  def resource_from_claims(%{"sub" => id}) do
    # se l'id è un intero, lo converto in stringa
    id = if is_integer(id), do: Integer.to_string(id), else: id
    # recupero l'utente dal database
    case Backend.Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
