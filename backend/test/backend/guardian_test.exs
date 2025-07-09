defmodule Backend.GuardianTest do
  use ExUnit.Case, async: true

  alias Backend.Guardian
  alias Backend.Accounts.User

  test "subject_for_token returns user id as string" do
    user = %User{id: 123}
    assert {:ok, "123"} = Guardian.subject_for_token(user, %{})
  end

  test "build_claims adds user map to claims" do
    user = %User{id: 1, email: "test@example.com", is_admin: false, role: "user"}
    {:ok, claims} = Guardian.build_claims(%{}, user, %{})
    assert is_map(claims["user"])
    assert claims["user"]["email"] == "test@example.com"
    refute Map.has_key?(claims["user"], :password_hash)
  end

  test "resource_from_claims reconstructs user from claims" do
    user_map = %{"id" => "1", "email" => "test@example.com", "is_admin" => false, "role" => "user"}
    assert {:ok, %User{id: "1", email: "test@example.com"}} = Guardian.resource_from_claims(%{"user" => user_map})
  end
end
