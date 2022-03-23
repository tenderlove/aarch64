module AArch64
  module Instructions
    # LDLAR -- A64
    # Load LOAcquire Register
    # LDLAR  <Wt>, [<Xn|SP>{,#0}]
    # LDLAR  <Xt>, [<Xn|SP>{,#0}]
    class LDLAR
      def encode
        raise NotImplementedError
      end

      private

      def LDLAR rn, rt
        insn = 0b1x_001000_1_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
