module AArch64
  module Instructions
    # UMADDL -- A64
    # Unsigned Multiply-Add Long
    # UMADDL  <Xd>, <Wn>, <Wm>, <Xa>
    class UMADDL < Instruction
      def initialize xd, wn, wm, xa
        @xd = check_mask(xd, 0x1f)
        @wn = check_mask(wn, 0x1f)
        @wm = check_mask(wm, 0x1f)
        @xa = check_mask(xa, 0x1f)
      end

      def encode
        UMADDL(@wm, @xa, @wn, @xd)
      end

      private

      def UMADDL rm, ra, rn, rd
        insn = 0b1_00_11011_1_01_00000_0_00000_00000_00000
        insn |= ((rm) << 16)
        insn |= ((ra) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
