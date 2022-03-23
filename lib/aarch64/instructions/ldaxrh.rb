module AArch64
  module Instructions
    # LDAXRH -- A64
    # Load-Acquire Exclusive Register Halfword
    # LDAXRH  <Wt>, [<Xn|SP>{,#0}]
    class LDAXRH
      def encode
        raise NotImplementedError
      end

      private

      def LDAXRH rn, rt
        insn = 0b01_001000_0_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
