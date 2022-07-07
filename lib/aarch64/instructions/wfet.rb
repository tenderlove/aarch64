module AArch64
  module Instructions
    # WFET -- A64
    # Wait For Event with Timeout
    # WFET  <Xt>
    class WFET < Instruction
      def initialize rd
        @rd = rd
      end

      def encode
        WFET(@rd.to_i)
      end

      private

      def WFET rd
        insn = 0b11010101000000110001_0000_000_00000
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
