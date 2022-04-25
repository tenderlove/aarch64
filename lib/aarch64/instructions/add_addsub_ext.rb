module AArch64
  module Instructions
    # ADD (extended register) -- A64
    # Add (extended register)
    # ADD  <Wd|WSP>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADD  <Xd|SP>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class ADD_addsub_ext
      def initialize rd, rn, rm, extend, amount, sf
        @rd     = rd
        @rn     = rn
        @rm     = rm
        @extend = extend
        @amount = amount
        @sf     = sf
      end

      def encode
        self.ADD_addsub_ext(@sf, @rm.to_i, @extend, @amount, @rn.to_i, @rd.to_i)
      end

      private

      def ADD_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_0_0_01011_00_1_00000_000_000_00000_00000
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
