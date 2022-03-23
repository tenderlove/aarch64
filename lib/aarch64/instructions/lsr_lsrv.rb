module AArch64
  module Instructions
    # LSR (register) -- A64
    # Logical Shift Right (register)
    # LSR  <Wd>, <Wn>, <Wm>
    # LSRV <Wd>, <Wn>, <Wm>
    # LSR  <Xd>, <Xn>, <Xm>
    # LSRV <Xd>, <Xn>, <Xm>
    class LSR_LSRV
      def encode
        raise NotImplementedError
      end

      private

      def LSR_LSRV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_01_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
