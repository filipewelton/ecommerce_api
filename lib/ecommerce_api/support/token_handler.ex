defmodule EcommerceApi.Support.TokenHandler do
  import Joken

  alias Joken.Claim
  alias EcommerceApi.Support.Error

  @issuer UUID.uuid4()
  @secret "018c104d-f413-7941-aae5-9ddea672cf9d"
  @signer Joken.Signer.create("HS512", @secret)

  defp get_token_config(audiences) do
    iss = %Claim{
      generate: fn -> @issuer end,
      validate: fn iss, _claims, _context -> iss == @issuer end
    }

    exp = %Claim{
      generate: fn -> current_time() + 60 * 60 end,
      validate: fn exp, _claims, _context -> current_time() < exp end
    }

    aud = %Claim{
      generate: fn -> audiences end,
      validate: fn aud, _claim, _ctx -> validate_audiences(aud, audiences) end
    }

    %{
      "iss" => iss,
      "exp" => exp,
      "aud" => aud
    }
  end

  defp validate_audiences(aud, audiences), do: Enum.any?(aud, fn e -> e in audiences end)

  def generate_token(claims, audiences) do
    token_config = get_token_config(audiences)

    case generate_and_sign(token_config, claims, @signer) do
      {:ok, token, _claims} ->
        {:ok, token}

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end

  def validate_token(token, audiences) do
    token_config = get_token_config(audiences)

    case verify_and_validate(token_config, token, @signer) do
      {:ok, _} -> :ok
      {:error, _} -> Error.build(401, %{token: "unauthorized"})
    end
  end
end
