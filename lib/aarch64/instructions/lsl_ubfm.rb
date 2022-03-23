module AArch64
  module Instructions
    # LSL (immediate) -- A64
    # Logical Shift Left (immediate)
    # LSL  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #(-<shift> MOD 32), #(31-<shift>)
    # LSL  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #(-<shift> MOD 64), #(63-<shift>)
    class LSL_UBFM
      def encode
        raise NotImplementedError
      end

      private

      def LSL_UBFM sf, n, immr, rn, rd
        insn = 0b0_10_100110_0_000000_!= x11111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
