module AArch64
  module Instructions
    # SETF8, SETF16 -- A64
    # Evaluation of 8 or 16 bit flag values
    # SETF8  <Wn>
    # SETF16  <Wn>
    class SETF
      def initialize rn, sz
        @rn = rn
        @sz = sz
      end

      def encode
        self.SETF(@sz, @rn.to_i)
      end

      private

      def SETF sz, rn
        insn = 0b0_0_1_11010000_000000_0_0010_00000_0_1101
        insn |= ((sz & 0x1) << 14)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
