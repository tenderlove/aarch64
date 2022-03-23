module AArch64
  module Instructions
    # LDARB -- A64
    # Load-Acquire Register Byte
    # LDARB  <Wt>, [<Xn|SP>{,#0}]
    class LDARB
      def encode
        raise NotImplementedError
      end

      private

      def LDARB rn, rt
        insn = 0b00_001000_1_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end