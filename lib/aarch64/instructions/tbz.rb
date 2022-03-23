module AArch64
  module Instructions
    # TBZ -- A64
    # Test bit and Branch if Zero
    # TBZ  <R><t>, #<imm>, <label>
    class TBZ
      def encode
        raise NotImplementedError
      end

      private

      def TBZ b5, b40, imm14, rt
        insn = 0b0_011011_0_00000_00000000000000_00000
        insn |= ((b5 & 0x1) << 31)
        insn |= ((b40 & 0x1f) << 19)
        insn |= ((imm14 & 0x3fff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
