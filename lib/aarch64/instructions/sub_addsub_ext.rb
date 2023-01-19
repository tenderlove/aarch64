module AArch64
  module Instructions
    # SUB (extended register) -- A64
    # Subtract (extended register)
    # SUB  <Wd|WSP>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUB  <Xd|SP>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class SUB_addsub_ext < Instruction
      def initialize rd, rn, rm, extend, amount, sf
        @rd     = check_mask(rd, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @extend = check_mask(extend, 0x07)
        @amount = check_mask(amount, 0x07)
        @sf     = check_mask(sf, 0x01)
      end

      def encode _
        SUB_addsub_ext(@sf, @rm, @extend, @amount, @rn, @rd)
      end

      private

      def SUB_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_1_0_01011_00_1_00000_000_000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((option) << 13)
        insn |= ((imm3) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
