#
class TestClass
  #
  #
  # @return [Object]
  def test
    'testing'
  end

  #
  #
  # @param a [Object]
  # @param b [Object]
  # @return [Object]
  def test_ab(a, b)
    "#{a} #{b}"
  end

  #
  #
  # @param a [Object]
  # @param b [Object] defaults to 2
  # @return [Object]
  def test_ab_hash(a:, b: 2)
    "#{a} #{b}"
  end

  #
  #
  # @param a [Object]
  # @param b [Object] defaults to 2
  # @return [Object]
  def test_ab_equals(a, b = 2)
    "#{a} #{b}"
  end

  # Keep my comments as is, don't apply new ones after
  # @param a [String] Keep my comments
  # @param b [String] Keep my comments
  # @return [String] The result should be the same
  def test_dont_erase_my_comments(a, b = 2)
    "#{a} #{b}"
  end
end
