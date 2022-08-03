module AArch64
  module Instructions
    # LDEOR, LDEORA, LDEORAL, LDEORL -- A64
    # Atomic exclusive OR on word or doubleword in memory
    # LDEOR  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORA  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEOR  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORA  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORL  <Xs>, <Xt>, [<Xn|SP>]
    class LDEOR < Instruction
      def initialize rs, rt, rn, a, r, size
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @a    = a
        @r    = r
        @size = size
      end

      def encode
        LDEOR(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDEOR size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_010_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(a, 0x1)) << 23)
        insn |= ((apply_mask(r, 0x1)) << 22)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
