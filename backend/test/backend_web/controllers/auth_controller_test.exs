defmodule BackendWeb.AuthControllerTest do
  use BackendWeb.ConnCase, async: true

  @valid_user %{"email" => "test@example.com", "password" => "Test1234!"}
  @invalid_user %{"email" => "test@example.com", "password" => "short"}

  test "POST /api/auth/register - success", %{conn: conn} do
    conn = post(conn, "/api/auth/register", @valid_user)
    assert %{"token" => _, "user" => %{"email" => "test@example.com"}} = json_response(conn, 200)
  end

  test "POST /api/auth/register - error", %{conn: conn} do
    conn = post(conn, "/api/auth/register", @invalid_user)
    assert %{"error" => _} = json_response(conn, 400)
  end

  test "POST /api/auth/login - success", %{conn: conn} do
    # registro l'utente
    post(conn, "/api/auth/register", @valid_user)
    # login
    conn = post(conn, "/api/auth/login", @valid_user)
    assert %{"token" => _, "user" => %{"email" => "test@example.com"}} = json_response(conn, 200)
  end

  test "POST /api/auth/login - error", %{conn: conn} do
    conn = post(conn, "/api/auth/login", @invalid_user)
    assert %{"error" => _} = json_response(conn, 401)
  end
end
