module AArch64
  module Instructions
    # AUTIB, AUTIB1716, AUTIBSP, AUTIBZ, AUTIZB -- A64
    # Authenticate Instruction address, using key B
    # AUTIB  <Xd>, <Xn|SP>
    # AUTIZB  <Xd>
    # AUTIB1716
    # AUTIBSP
    # AUTIBZ
    class AUTIB
      def encode
        raise NotImplementedError
      end

      private

      def AUTIB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_101_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
