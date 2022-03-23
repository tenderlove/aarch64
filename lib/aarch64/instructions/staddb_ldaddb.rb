module AArch64
  module Instructions
    # STADDB, STADDLB -- A64
    # Atomic add on byte in memory, without return
    # STADDB  <Ws>, [<Xn|SP>]
    # LDADDB <Ws>, WZR, [<Xn|SP>]
    # STADDLB  <Ws>, [<Xn|SP>]
    # LDADDLB <Ws>, WZR, [<Xn|SP>]
    class STADDB_LDADDB
      def encode
        raise NotImplementedError
      end

      private

      def STADDB_LDADDB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_000_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
