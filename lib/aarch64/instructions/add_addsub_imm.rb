module AArch64
  module Instructions
    # ADD (immediate) -- A64
    # Add (immediate)
    # ADD  <Wd|WSP>, <Wn|WSP>, #<imm>{, <shift>}
    class ADD_addsub_imm
      def initialize d, n, imm12, sh
        @rd = d
        @rn = n
        @imm12 = imm12
        @sh = sh
      end

      def encode
        ADD_addsub_imm(@rd.sf, @sh, @imm12, @rn.to_i, @rd.to_i)
      end

      private

      def ADD_addsub_imm sf, sh, imm12, rn, rd
        insn = 0b0_0_0_100010_0_000000000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((sh & 0x1) << 22)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
