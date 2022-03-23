module AArch64
  module Instructions
    # LDAXRB -- A64
    # Load-Acquire Exclusive Register Byte
    # LDAXRB  <Wt>, [<Xn|SP>{,#0}]
    class LDAXRB
      def encode
        raise NotImplementedError
      end

      private

      def LDAXRB rn, rt
        insn = 0b00_001000_0_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
