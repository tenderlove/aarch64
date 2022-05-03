module AArch64
  module Instructions
    # PACIA, PACIA1716, PACIASP, PACIAZ, PACIZA -- A64
    # Pointer Authentication Code for Instruction address, using key A
    # PACIA1716
    # PACIASP
    # PACIAZ
    class PACIA2
      def initialize crm, op2
        @crm = crm
        @op2 = op2
      end

      def encode
        PACIA2(@crm, @op2)
      end

      private

      def PACIA2 crm, op2
        insn = 0b11010101000000110010_0000_000_11111
        insn |= ((crm & 0xf) << 8)
        insn |= ((op2 & 0x7) << 5)
        insn
      end
    end
  end
end
