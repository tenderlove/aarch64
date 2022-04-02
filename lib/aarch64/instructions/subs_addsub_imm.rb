module AArch64
  module Instructions
    # SUBS (immediate) -- A64
    # Subtract (immediate), setting flags
    # SUBS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # SUBS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    class SUBS_addsub_imm
      def initialize rd, rn, imm, shift
        @rd    = rd
        @rn    = rn
        @imm   = imm
        @shift = shift
      end

      def encode
        SUBS_addsub_imm(@rd.sf, @shift, @imm, @rn.to_i, @rd.to_i)
      end

      private

      def SUBS_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_1_1_100010_0_000000000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((sh & 0x1) << 22)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
