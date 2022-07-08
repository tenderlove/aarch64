module AArch64
  module Instructions
    # SUB (extended register) -- A64
    # Subtract (extended register)
    # SUB  <Wd|WSP>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUB  <Xd|SP>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class SUB_addsub_ext < Instruction
      def initialize rd, rn, rm, extend, amount, sf
        @rd     = rd
        @rn     = rn
        @rm     = rm
        @extend = extend
        @amount = amount
        @sf     = sf
      end

      def encode
        SUB_addsub_ext(@sf, @rm.to_i, @extend, @amount, @rn.to_i, @rd.to_i)
      end

      private

      def SUB_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_1_0_01011_00_1_00000_000_000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(option, 0x7)) << 13)
        insn |= ((apply_mask(imm3, 0x7)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
