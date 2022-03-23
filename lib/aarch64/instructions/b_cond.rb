module AArch64
  module Instructions
    # B.cond -- A64
    # Branch conditionally
    # B.<cond>  <label>
    class B_cond
      def encode
        raise NotImplementedError
      end

      private

      def B_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_0_0000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (cond & 0xf)
        insn
      end
    end
  end
end
