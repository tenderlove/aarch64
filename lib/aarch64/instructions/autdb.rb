module AArch64
  module Instructions
    # AUTDB, AUTDZB -- A64
    # Authenticate Data address, using key B
    # AUTDB  <Xd>, <Xn|SP>
    # AUTDZB  <Xd>
    class AUTDB
      def encode
        raise NotImplementedError
      end

      private

      def AUTDB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_111_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
