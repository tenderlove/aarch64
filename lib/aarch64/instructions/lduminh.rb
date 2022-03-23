module AArch64
  module Instructions
    # LDUMINH, LDUMINAH, LDUMINALH, LDUMINLH -- A64
    # Atomic unsigned minimum on halfword in memory
    # LDUMINAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMINH
      def encode
        raise NotImplementedError
      end

      private

      def LDUMINH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_111_00_00000_00000
        insn |= ((a & 0x1) << 23)
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
