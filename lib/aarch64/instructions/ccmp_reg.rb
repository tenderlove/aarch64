module AArch64
  module Instructions
    # CCMP (register) -- A64
    # Conditional Compare (register)
    # CCMP  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMP  <Xn>, <Xm>, #<nzcv>, <cond>
    class CCMP_reg
      def encode
        raise NotImplementedError
      end

      private

      def CCMP_reg sf, rm, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_0_0_00000_0_0000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((cond & 0xf) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (nzcv & 0xf)
        insn
      end
    end
  end
end
