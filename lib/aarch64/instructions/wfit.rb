module AArch64
  module Instructions
    # WFIT -- A64
    # Wait For Interrupt with Timeout
    # WFIT  <Xt>
    class WFIT
      def encode
        raise NotImplementedError
      end

      private

      def WFIT rd
        insn = 0b11010101000000110001_0000_001_00000
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
