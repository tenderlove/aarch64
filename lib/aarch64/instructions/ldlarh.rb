module AArch64
  module Instructions
    # LDLARH -- A64
    # Load LOAcquire Register Halfword
    # LDLARH  <Wt>, [<Xn|SP>{,#0}]
    class LDLARH
      def encode
        raise NotImplementedError
      end

      private

      def LDLARH rn, rt
        insn = 0b01_001000_1_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
