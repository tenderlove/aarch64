module AArch64
  module Instructions
    # ROR (immediate) -- A64
    # Rotate right (immediate)
    # ROR  <Wd>, <Ws>, #<shift>
    # EXTR <Wd>, <Ws>, <Ws>, #<shift>
    # ROR  <Xd>, <Xs>, #<shift>
    # EXTR <Xd>, <Xs>, <Xs>, #<shift>
    class ROR_EXTR
      def encode
        raise NotImplementedError
      end

      private

      def ROR_EXTR sf, n, rm, imms, rn, rd
        insn = 0b0_00_100111_0_0_00000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
