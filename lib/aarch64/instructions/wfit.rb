module AArch64
  module Instructions
    # WFIT -- A64
    # Wait For Interrupt with Timeout
    # WFIT  <Xt>
    class WFIT < Instruction
      def initialize rd
        @rd = check_mask(rd, 0x1f)
      end

      def encode
        WFIT(@rd)
      end

      private

      def WFIT rd
        insn = 0b11010101000000110001_0000_001_00000
        insn |= (rd)
        insn
      end
    end
  end
end
