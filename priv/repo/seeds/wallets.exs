require Ecto.Query

alias Workbench.{Repo, Wallet}

{:ok, _} = %Wallet{}
           |> Wallet.changeset(%{name: "coinbase", asset: "usdc", amount: Decimal.new("1500.0"), address: "0xe7A0848C097A7Cd686d51eE00C360F386eF3Df7E"})
           |> Repo.insert()

{:ok, _} = %Wallet{}
           |> Wallet.changeset(%{name: "wasabi", asset: "btc", amount: Decimal.new("2.1"), address: "1BaPP5KYctBpdGq6yaLs77q5hM8To7zE4B"})
           |> Repo.insert()
