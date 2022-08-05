module AArch64
  module Instructions
    # PACIA, PACIA1716, PACIASP, PACIAZ, PACIZA -- A64
    # Pointer Authentication Code for Instruction address, using key A
    # PACIA1716
    # PACIASP
    # PACIAZ
    class PACIA2 < Instruction
      def initialize crm, op2
        @crm = check_mask(crm, 0x0f)
        @op2 = check_mask(op2, 0x07)
      end

      def encode
        PACIA2(@crm, @op2)
      end

      private

      def PACIA2 crm, op2
        insn = 0b11010101000000110010_0000_000_11111
        insn |= ((crm) << 8)
        insn |= ((op2) << 5)
        insn
      end
    end
  end
end
