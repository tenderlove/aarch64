module AArch64
  module Instructions
    # SUB (immediate) -- A64
    # Subtract (immediate)
    # SUB  <Wd|WSP>, <Wn|WSP>, #<imm>{, <shift>}
    # SUB  <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    class SUB_addsub_imm < Instruction
      def initialize rd, rn, imm, shift, sf
        @rd    = rd
        @rn    = rn
        @imm   = imm
        @shift = shift
        @sf    = sf
      end

      def encode
        SUB_addsub_imm(@sf, @shift, @imm, @rn.to_i, @rd.to_i)
      end

      private

      def SUB_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_1_0_100010_0_000000000000_00000_00000
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
