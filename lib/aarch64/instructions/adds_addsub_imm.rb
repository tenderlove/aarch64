module AArch64
  module Instructions
    # ADDS (immediate) -- A64
    # Add (immediate), setting flags
    # ADDS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # ADDS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    class ADDS_addsub_imm < Instruction
      def initialize d, n, imm, shift, sf
        @d     = d
        @n     = n
        @imm   = imm
        @shift = shift
        @sf    = sf
      end

      def encode
        ADDS_addsub_imm(@sf, @shift, @imm, @n, @d)
      end

      private

      def ADDS_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_0_1_100010_0_000000000000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(sh, 0x1)) << 22)
        insn |= ((apply_mask(imm12, 0xfff)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
