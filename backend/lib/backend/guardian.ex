defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  # restituisco l'id dell'utente come subject del token
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  # aggiungo tutti i dati dell'utente (tranne la password) nei claims del token
  def build_claims(claims, user, _opts) do
    user_map =
      user
      |> Map.from_struct()
      |> Map.drop([:__meta__, :__struct__, :password, :password_hash, :inserted_at, :updated_at])

    claims = Map.merge(claims, %{"user" => user_map})
    {:ok, claims}
  end

  #TODO: recuperare l'utente dal token e non dall'id, visto che a questo punto il token contiene più informazioni
        # e mi sembra più pulito che non dover fare una query al database per recuperare l'utente

  # recupero l'utente a partire dal subject del token
  def resource_from_claims(%{"sub" => id}) do
    # cerco l'utente tramite l'id
    case Backend.Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
