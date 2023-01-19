module AArch64
  module Instructions
    # LDLAR -- A64
    # Load LOAcquire Register
    # LDLAR  <Wt>, [<Xn|SP>{,#0}]
    # LDLAR  <Xt>, [<Xn|SP>{,#0}]
    class LDLAR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode _
        LDLAR(@size, @rn, @rt)
      end

      private

      def LDLAR size, rn, rt
        insn = 0b00_001000_1_1_0_11111_0_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
