module AArch64
  module Instructions
    # LDAR -- A64
    # Load-Acquire Register
    # LDAR  <Wt>, [<Xn|SP>{,#0}]
    # LDAR  <Xt>, [<Xn|SP>{,#0}]
    class LDAR
      def encode
        raise NotImplementedError
      end

      private

      def LDAR rn, rt
        insn = 0b1x_001000_1_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
