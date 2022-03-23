module AArch64
  module Instructions
    # LDARH -- A64
    # Load-Acquire Register Halfword
    # LDARH  <Wt>, [<Xn|SP>{,#0}]
    class LDARH
      def encode
        raise NotImplementedError
      end

      private

      def LDARH rn, rt
        insn = 0b01_001000_1_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
