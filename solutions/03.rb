class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def get_raw_rational(position)
    n, k = position, 1
    while n >= k
      n -= k
      k += 1
    end
    if k.even? then [k - n, n + 1] else [n + 1, k - n] end
  end

  def each
    current, current_size = 0, 0
    while current_size < @limit
      numerator, denominator = get_raw_rational current

      if numerator.gcd(denominator) == 1
        yield Rational(numerator, denominator)
        current_size += 1
      end
      current += 1
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def is_prime?(n)
    return false if n <= 1
    Math.sqrt(n).to_i.downto(2).each {|i| return false if n % i == 0}
    true
  end

  def each
    current, current_size = 2, 0
    while current_size < @limit
      if(is_prime?(current))
        yield current
        current_size += 1
      end
      current += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit, @first, @second = limit, first, second
  end

  def each
    current, previous = @second, @first
    (0...@limit).each do
      yield previous
      current, previous = current + previous, current
    end
  end
end

module DrunkenMathematician
  module_function

  def is_prime?(n)
    return false if n <= 1
    Math.sqrt(n).to_i.downto(2).each {|i| return false if n % i == 0}
    true
  end

  def meaningless(n)
    groups = RationalSequence.new(n).partition do |rational|
              is_prime?(rational.numerator) or is_prime?(rational.denominator)
            end
    groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
  end

  def aimless(n)
    aimless_sum = 0
    PrimeSequence.new(n).each_slice(2) do |prime|
      aimless_sum += Rational(prime[0], prime.fetch(1, 1))
    end
    aimless_sum
  end

  def worthless(n)
    limit = FibonacciSequence.new(n).to_a.fetch(-1, 0)
    rationals = RationalSequence.new(Float::INFINITY).lazy

    sum  = 0
    rationals.take_while do |rational|
      sum += rational
      sum <= limit
    end.force
  end
end