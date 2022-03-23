module AArch64
  module Instructions
    # STCLRB, STCLRLB -- A64
    # Atomic bit clear on byte in memory, without return
    # STCLRB  <Ws>, [<Xn|SP>]
    # LDCLRB <Ws>, WZR, [<Xn|SP>]
    # STCLRLB  <Ws>, [<Xn|SP>]
    # LDCLRLB <Ws>, WZR, [<Xn|SP>]
    class STCLRB_LDCLRB
      def encode
        raise NotImplementedError
      end

      private

      def STCLRB_LDCLRB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_001_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
