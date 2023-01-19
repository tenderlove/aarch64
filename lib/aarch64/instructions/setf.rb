module AArch64
  module Instructions
    # SETF8, SETF16 -- A64
    # Evaluation of 8 or 16 bit flag values
    # SETF8  <Wn>
    # SETF16  <Wn>
    class SETF < Instruction
      def initialize rn, sz
        @rn = check_mask(rn, 0x1f)
        @sz = check_mask(sz, 0x01)
      end

      def encode _
        SETF(@sz, @rn)
      end

      private

      def SETF sz, rn
        insn = 0b0_0_1_11010000_000000_0_0010_00000_0_1101
        insn |= ((sz) << 14)
        insn |= ((rn) << 5)
        insn
      end
    end
  end
end
