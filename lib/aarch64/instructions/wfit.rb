module AArch64
  module Instructions
    # WFIT -- A64
    # Wait For Interrupt with Timeout
    # WFIT  <Xt>
    class WFIT < Instruction
      def initialize rd
        @rd = rd
      end

      def encode
        WFIT(@rd.to_i)
      end

      private

      def WFIT rd
        insn = 0b11010101000000110001_0000_001_00000
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
