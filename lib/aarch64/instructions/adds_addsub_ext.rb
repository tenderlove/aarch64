module AArch64
  module Instructions
    # ADDS (extended register) -- A64
    # Add (extended register), setting flags
    # ADDS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class ADDS_addsub_ext < Instruction
      def initialize d, n, m, extend, amount, sf
        @d      = d
        @n      = n
        @m      = m
        @extend = extend
        @amount = amount
        @sf     = sf
      end

      def encode
        ADDS_addsub_ext(@sf, @m.to_i, @extend, @amount, @n.to_i, @d.to_i)
      end

      private

      def ADDS_addsub_ext sf, rm, option, imm3, rn, rd
        insn = 0b0_0_1_01011_00_1_00000_000_000_00000_00000
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
