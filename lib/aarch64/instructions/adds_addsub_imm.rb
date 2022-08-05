module AArch64
  module Instructions
    # ADDS (immediate) -- A64
    # Add (immediate), setting flags
    # ADDS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # ADDS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    class ADDS_addsub_imm < Instruction
      def initialize d, n, imm, shift, sf
        @d     = check_mask(d, 0x1f)
        @n     = check_mask(n, 0x1f)
        @imm   = check_mask(imm, 0xfff)
        @shift = check_mask(shift, 0x01)
        @sf    = check_mask(sf, 0x01)
      end

      def encode
        ADDS_addsub_imm(@sf, @shift, @imm, @n, @d)
      end

      private

      def ADDS_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_0_1_100010_0_000000000000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((sh) << 22)
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
