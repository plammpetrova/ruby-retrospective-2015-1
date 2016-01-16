def convert_to_bgn(price, currency)
  currencies = {usd: 1.7408, eur: 1.9557, gbp: 2.6415, bgn: 1.00}
  (price * currencies[currency]).round(2)
end

def compare_prices(price, currency, price_two, currency_two)
  convert_to_bgn(price, currency) <=> convert_to_bgn(price_two, currency_two)
end