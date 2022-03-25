module AArch64
  module Instructions
    # ADDS (extended register) -- A64
    # Add (extended register), setting flags
    # ADDS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class ADDS_addsub_ext
      def initialize d, n, m, extend, amount
        @d = d
        @n = n
        @m = m
        @extend = extend
        @amount = amount
      end

      def encode
        ADDS_addsub_ext(@d.sf, @m.to_i, @extend, @amount, @n.to_i, @d.to_i)
      end

      private

      def ADDS_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_0_1_01011_00_1_00000_000_000_00000_00000
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
