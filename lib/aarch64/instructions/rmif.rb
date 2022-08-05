module AArch64
  module Instructions
    # RMIF -- A64
    # Rotate, Mask Insert Flags
    # RMIF  <Xn>, #<shift>, #<mask>
    class RMIF < Instruction
      def initialize rn, imm6, mask
        @rn   = check_mask(rn, 0x1f)
        @imm6 = check_mask(imm6, 0x3f)
        @mask = check_mask(mask, 0x0f)
      end

      def encode
        RMIF(@imm6, @rn, @mask)
      end

      private

      def RMIF imm6, rn, mask
        insn = 0b1_0_1_11010000_000000_00001_00000_0_0000
        insn |= ((imm6) << 15)
        insn |= ((rn) << 5)
        insn |= (mask)
        insn
      end
    end
  end
end
