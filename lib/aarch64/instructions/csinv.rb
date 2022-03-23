module AArch64
  module Instructions
    # CSINV -- A64
    # Conditional Select Invert
    # CSINV  <Wd>, <Wn>, <Wm>, <cond>
    # CSINV  <Xd>, <Xn>, <Xm>, <cond>
    class CSINV
      def encode
        raise NotImplementedError
      end

      private

      def CSINV sf, rm, cond, rn, rd
        insn = 0b0_1_0_11010100_00000_0000_0_0_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((cond & 0xf) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
