module AArch64
  module Instructions
    # AUTDA, AUTDZA -- A64
    # Authenticate Data address, using key A
    # AUTDA  <Xd>, <Xn|SP>
    # AUTDZA  <Xd>
    class AUTDA
      def encode
        raise NotImplementedError
      end

      private

      def AUTDA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_110_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
