module AArch64
  module Instructions
    # SDIV -- A64
    # Signed Divide
    # SDIV  <Wd>, <Wn>, <Wm>
    # SDIV  <Xd>, <Xn>, <Xm>
    class SDIV
      def encode
        raise NotImplementedError
      end

      private

      def SDIV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_00001_1_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
