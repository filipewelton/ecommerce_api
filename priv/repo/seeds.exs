alias EcommerceApi.{Repo, Store}

store_id = Application.fetch_env!(:ecommerce_api, :store_id)

values = %{
  id: store_id,
  cnpj: "15.504.701/0003-05",
  name: "Eataly",
  cep: "04543-011",
  address_number: 1489
}

Store.changeset(values)
|> Repo.insert()
