module AArch64
  module Instructions
    # PACIB, PACIB1716, PACIBSP, PACIBZ, PACIZB -- A64
    # Pointer Authentication Code for Instruction address, using key B
    # PACIB  <Xd>, <Xn|SP>
    # PACIZB  <Xd>
    # PACIB1716
    # PACIBSP
    # PACIBZ
    class PACIB
      def initialize rd, rn, z
        @rd = rd
        @rn = rn
        @z  = z
      end

      def encode
        self.PACIB(@z, @rn.to_i, @rd.to_i)
      end

      private

      def PACIB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_001_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
