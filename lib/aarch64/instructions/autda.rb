module AArch64
  module Instructions
    # AUTDA, AUTDZA -- A64
    # Authenticate Data address, using key A
    # AUTDA  <Xd>, <Xn|SP>
    # AUTDZA  <Xd>
    class AUTDA < Instruction
      def initialize z, rd, rn
        @z  = z
        @rd = rd
        @rn = rn
      end

      def encode
        AUTDA(@z, @rn, @rd)
      end

      private

      def AUTDA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_110_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 13)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
