module AArch64
  module Instructions
    # ADD (immediate) -- A64
    # Add (immediate)
    # ADD  <Wd|WSP>, <Wn|WSP>, #<imm>{, <shift>}
    class ADD_addsub_imm < Instruction
      def initialize rd, rn, imm12, sh, sf
        @rd    = rd
        @rn    = rn
        @imm12 = imm12
        @sh    = sh
        @sf    = sf
      end

      def encode
        ADD_addsub_imm(@sf, @sh, @imm12, @rn.to_i, @rd.to_i)
      end

      private

      def ADD_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_0_0_100010_0_000000000000_00000_00000
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
