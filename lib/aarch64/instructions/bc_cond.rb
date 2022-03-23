module AArch64
  module Instructions
    # BC.cond -- A64
    # Branch Consistent conditionally
    # BC.<cond>  <label>
    class BC_cond
      def encode
        raise NotImplementedError
      end

      private

      def BC_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_1_0000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (cond & 0xf)
        insn
      end
    end
  end
end
