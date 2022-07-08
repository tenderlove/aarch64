module AArch64
  module Instructions
    # UMADDL -- A64
    # Unsigned Multiply-Add Long
    # UMADDL  <Xd>, <Wn>, <Wm>, <Xa>
    class UMADDL < Instruction
      def initialize xd, wn, wm, xa
        @xd = xd
        @wn = wn
        @wm = wm
        @xa = xa
      end

      def encode
        UMADDL(@wm.to_i, @xa.to_i, @wn.to_i, @xd.to_i)
      end

      private

      def UMADDL rm, ra, rn, rd
        insn = 0b1_00_11011_1_01_00000_0_00000_00000_00000
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(ra, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
