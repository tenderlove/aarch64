module AArch64
  module Instructions
    # LSRV -- A64
    # Logical Shift Right Variable
    # LSRV  <Wd>, <Wn>, <Wm>
    # LSRV  <Xd>, <Xn>, <Xm>
    class LSRV
      def encode
        raise NotImplementedError
      end

      private

      def LSRV sf, rm, rn, rd
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
