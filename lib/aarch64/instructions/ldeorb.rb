module AArch64
  module Instructions
    # LDEORB, LDEORAB, LDEORALB, LDEORLB -- A64
    # Atomic exclusive OR on byte in memory
    # LDEORAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDEORB
      def encode
        raise NotImplementedError
      end

      private

      def LDEORB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_010_00_00000_00000
        insn |= ((a & 0x1) << 23)
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
