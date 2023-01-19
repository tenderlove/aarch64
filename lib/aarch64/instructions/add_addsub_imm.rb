module AArch64
  module Instructions
    # ADD (immediate) -- A64
    # Add (immediate)
    # ADD  <Wd|WSP>, <Wn|WSP>, #<imm>{, <shift>}
    class ADD_addsub_imm < Instruction
      def initialize rd, rn, imm12, sh, sf
        @rd    = check_mask(rd, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
        @sh    = check_mask(sh, 0x01)
        @sf    = check_mask(sf, 0x01)
      end

      def encode _
        ADD_addsub_imm(@sf, @sh, @imm12, @rn, @rd)
      end

      private

      def ADD_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_0_0_100010_0_000000000000_00000_00000
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
