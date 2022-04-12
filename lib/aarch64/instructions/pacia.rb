module AArch64
  module Instructions
    # PACIA, PACIA1716, PACIASP, PACIAZ, PACIZA -- A64
    # Pointer Authentication Code for Instruction address, using key A
    # PACIA  <Xd>, <Xn|SP>
    # PACIZA  <Xd>
    # PACIA1716
    # PACIASP
    # PACIAZ
    class PACIA
      def initialize rd, rn, z
        @rd = rd
        @rn = rn
        @z  = z
      end

      def encode
        self.PACIA(@z, @rn.to_i, @rd.to_i)
      end

      private

      def PACIA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_000_00000_00000
        insn |= ((z & 0x1) << 13)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
