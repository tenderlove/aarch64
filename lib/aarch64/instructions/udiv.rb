module AArch64
  module Instructions
    # UDIV -- A64
    # Unsigned Divide
    # UDIV  <Wd>, <Wn>, <Wm>
    # UDIV  <Xd>, <Xn>, <Xm>
    class UDIV
      def encode
        raise NotImplementedError
      end

      private

      def UDIV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_00001_0_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
