module AArch64
  module Instructions
    # SUBS (extended register) -- A64
    # Subtract (extended register), setting flags
    # SUBS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUBS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class SUBS_addsub_ext
      def initialize rd, rn, rm, extend, amount
        @rd     = rd
        @rn     = rn
        @rm     = rm
        @extend = extend
        @amount = amount
      end

      def encode
        SUBS_addsub_ext(@rd.sf, @rm.to_i, @extend, @amount, @rn.to_i, @rd.to_i)
      end

      private

      def SUBS_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_1_1_01011_00_1_00000_000_000_00000_00000
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
