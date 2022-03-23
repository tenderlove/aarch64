module AArch64
  module Instructions
    # LDLARB -- A64
    # Load LOAcquire Register Byte
    # LDLARB  <Wt>, [<Xn|SP>{,#0}]
    class LDLARB
      def encode
        raise NotImplementedError
      end

      private

      def LDLARB rn, rt
        insn = 0b00_001000_1_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
