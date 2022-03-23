module AArch64
  module Instructions
    # SUB (extended register) -- A64
    # Subtract (extended register)
    # SUB  <Wd|WSP>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUB  <Xd|SP>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class SUB_addsub_ext
      def encode
        raise NotImplementedError
      end

      private

      def SUB_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_1_0_01011_00_1_00000_000_000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((option & 0x7) << 13)
        insn |= ((imm3 & 0x7) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
