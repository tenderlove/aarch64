require "helper"

class NotSupportedYetTest < AArch64::Test
  def setup
    skip "These aren't supported by clang"
  end

  def test_SETGP
    # SETGE  [<Xd>]!, <Xn>!, <Xs>
    # SETGM  [<Xd>]!, <Xn>!, <Xs>
    # SETGP  [<Xd>]!, <Xn>!, <Xs>
  end
end
