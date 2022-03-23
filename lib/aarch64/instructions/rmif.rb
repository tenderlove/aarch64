module AArch64
  module Instructions
    # RMIF -- A64
    # Rotate, Mask Insert Flags
    # RMIF  <Xn>, #<shift>, #<mask>
    class RMIF
      def encode
        raise NotImplementedError
      end

      private

      def RMIF imm6, rn, mask
        insn = 0b1_0_1_11010000_000000_00001_00000_0_0000
        insn |= ((imm6 & 0x3f) << 15)
        insn |= ((rn & 0x1f) << 5)
        insn |= (mask & 0xf)
        insn
      end
    end
  end
end
