module AArch64
  module Instructions
    # SWP, SWPA, SWPAL, SWPL -- A64
    # Swap word or doubleword in memory
    # SWP  <Ws>, <Wt>, [<Xn|SP>]
    # SWPA  <Ws>, <Wt>, [<Xn|SP>]
    # SWPAL  <Ws>, <Wt>, [<Xn|SP>]
    # SWPL  <Ws>, <Wt>, [<Xn|SP>]
    # SWP  <Xs>, <Xt>, [<Xn|SP>]
    # SWPA  <Xs>, <Xt>, [<Xn|SP>]
    # SWPAL  <Xs>, <Xt>, [<Xn|SP>]
    # SWPL  <Xs>, <Xt>, [<Xn|SP>]
    class SWP < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
        @a    = check_mask(a, 0x01)
        @r    = check_mask(r, 0x01)
      end

      def encode
        SWP(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def SWP size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_1_000_00_00000_00000
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
