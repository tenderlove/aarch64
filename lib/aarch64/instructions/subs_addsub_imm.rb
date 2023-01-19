module AArch64
  module Instructions
    # SUBS (immediate) -- A64
    # Subtract (immediate), setting flags
    # SUBS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # SUBS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    class SUBS_addsub_imm < Instruction
      def initialize rd, rn, imm, shift, sf
        @rd    = check_mask(rd, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm   = check_mask(imm, 0xfff)
        @shift = check_mask(shift, 0x01)
        @sf    = check_mask(sf, 0x01)
      end

      def encode _
        SUBS_addsub_imm(@sf, @shift, @imm, @rn, @rd)
      end

      private

      def SUBS_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_1_1_100010_0_000000000000_00000_00000
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
