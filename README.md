# E-commerce API

![Elixir](https://img.shields.io/badge/Elixir-4B275F?style=for-the-badge&logo=elixir&logoColor=white)
![Phoenix](https://img.shields.io/badge/Phoenix%20Framework-FD4F00?style=for-the-badge&logo=phoenixframework&logoColor=fff)
![Postgres](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-626CD9?style=for-the-badge&logo=Stripe&logoColor=white)

## Descrição

Uma API de um E-commerce desenvolvido com o framework Phoenix, Postgres como banco de
dados, e integração com o Stripe como meio de pagamento. Esta aplicação possuí algumas das
principais funcionalidades de um E-commerce real. As funcionalidades são as seguintes:

### Customers (E-commerce clients)

```bash
/api/customers/sign-in/
/api/customer/sign-up/
/api/customer/:id
```

### Wallets

```bash
/api/customers/wallets/
/api/customers/wallets/:id
```

### Products

```bash
/api/stores/products/
/api/stores/products/:id
```

### Orders

```bash
/api/stores/orders/
/api/stores/orders/:id
```

### Store Managers

```bash
/api/stores/managers/sign-in/
/api/stores/managers/sign-up/
/api/stores/managers/:id
```

### Store Employees

```bash
/api/stores/employees/sign-in/
/api/stores/employees/sign-up/
/api/stores/employees/:id
```

### Stripe Webhook

```bash
/api/webhooks/
```
