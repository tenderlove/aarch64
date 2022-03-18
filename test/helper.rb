require "aarch64"
require "minitest/autorun"
require "hatstone"
require "stringio"

module AArch64
  class Test < Minitest::Test
    def disasm code
      hs = Hatstone.new(Hatstone::ARCH_ARM64, Hatstone::MODE_ARM)
      hs.disasm(code, 0x0)
    end
  end
end
