defmodule Test.Factory do
  use ExMachina

  def store_manager_factory do
    %{
      "name" => Faker.Person.name(),
      "email" => Faker.Internet.email(),
      "password" => Faker.String.base64(12),
      "role" => :manager
    }
  end

  def store_employee_factory do
    %{
      "name" => Faker.Person.name(),
      "email" => Faker.Internet.email(),
      "password" => Faker.String.base64(12),
      "role" => :employee
    }
  end

  def product_factory do
    %{
      "name" => Faker.Commerce.product_name(),
      "description" => Faker.Lorem.sentence(),
      "department" => Faker.Commerce.department(),
      "labels" => [Faker.Lorem.word(), Faker.Lorem.word()],
      "photo" => Faker.Internet.url(),
      "price" => Decimal.new("88.90"),
      "amount" => :rand.uniform(99),
      "unit_label" => "KG"
    }
  end

  def customer_factory do
    %{
      "email" => Faker.Internet.email(),
      "password" => Faker.String.base64(12),
      "name" => Faker.Person.first_name(),
      "cpf" => "111.222.333-45",
      "cep" => "12345-678",
      "address_number" => :rand.uniform(99)
    }
  end

  def order_factory do
    %{
      "total_price" => Decimal.new("99.8"),
      "delivery_fee" => Decimal.new("7.5"),
      "delivery_date" => Faker.Date.forward(2)
    }
  end

  def wallet_factory do
    %{
      "card_number" => "4005519200000004",
      "payment_method" => :credit,
      "verification_code" => 123,
      "expiration_date" => Faker.Date.forward(100)
    }
  end
end
