# questo file esegue i seed del database
# per eseguirlo: mix run priv/repo/run_seeds.exs

alias Backend.Repo.Seeds

# creo l'admin di default
Seeds.create_admin_user()

IO.puts("Seeds completed successfully!")
