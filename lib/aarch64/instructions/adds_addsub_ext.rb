module AArch64
  module Instructions
    # ADDS (extended register) -- A64
    # Add (extended register), setting flags
    # ADDS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class ADDS_addsub_ext < Instruction
      def initialize d, n, m, extend, amount, sf
        @d      = check_mask(d, 0x1f)
        @n      = check_mask(n, 0x1f)
        @m      = check_mask(m, 0x1f)
        @extend = check_mask(extend, 0x07)
        @amount = check_mask(amount, 0x07)
        @sf     = check_mask(sf, 0x01)
      end

      def encode
        ADDS_addsub_ext(@sf, @m, @extend, @amount, @n, @d)
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
