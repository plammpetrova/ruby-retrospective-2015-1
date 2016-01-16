def convert_to_bgn(price, currency)
  rates_usd = {:usd => 1.7408}
  rates_eur = {:eur => 1.9557}
  rates_gbp = {:gbp => 2.6415}
  if (currency.to_s <=> 'usd') == 0
    (price*(rates_usd[:usd])).round(2)
  elsif(currency.to_s <=> 'eur') == 0
    (price*(rates_eur[:eur])).round(2)
  else(currency.to_s <=> 'gbp') == 0
    (price*(rates_gbp[:gbp])).round(2)
  end
end

def compare_prices(a, b, c, d)
  convert_to_bgn(a, b) <=> convert_to_bgn(c, d)
end