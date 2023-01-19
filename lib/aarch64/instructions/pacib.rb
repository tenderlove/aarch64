module AArch64
  module Instructions
    # PACIB, PACIB1716, PACIBSP, PACIBZ, PACIZB -- A64
    # Pointer Authentication Code for Instruction address, using key B
    # PACIB  <Xd>, <Xn|SP>
    # PACIZB  <Xd>
    # PACIB1716
    # PACIBSP
    # PACIBZ
    class PACIB < Instruction
      def initialize rd, rn, z
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @z  = check_mask(z, 0x01)
      end

      def encode _
        PACIB(@z, @rn, @rd)
      end

      private

      def PACIB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_001_00000_00000
        insn |= ((z) << 13)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
