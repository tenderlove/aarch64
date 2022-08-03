module AArch64
  module Instructions
    # SUBS (immediate) -- A64
    # Subtract (immediate), setting flags
    # SUBS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # SUBS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    class SUBS_addsub_imm < Instruction
      def initialize rd, rn, imm, shift, sf
        @rd    = rd
        @rn    = rn
        @imm   = imm
        @shift = shift
        @sf    = sf
      end

      def encode
        SUBS_addsub_imm(@sf, @shift, @imm, @rn, @rd)
      end

      private

      def SUBS_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_1_1_100010_0_000000000000_00000_00000
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
