module AArch64
  module Instructions
    # ROR (register) -- A64
    # Rotate Right (register)
    # ROR  <Wd>, <Wn>, <Wm>
    # RORV <Wd>, <Wn>, <Wm>
    # ROR  <Xd>, <Xn>, <Xm>
    # RORV <Xd>, <Xn>, <Xm>
    class ROR_RORV
      def encode
        raise NotImplementedError
      end

      private

      def ROR_RORV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_11_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
