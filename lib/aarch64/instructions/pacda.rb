module AArch64
  module Instructions
    # PACDA, PACDZA -- A64
    # Pointer Authentication Code for Data address, using key A
    # PACDA  <Xd>, <Xn|SP>
    # PACDZA  <Xd>
    class PACDA
      def encode
        raise NotImplementedError
      end

      private

      def PACDA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_010_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
