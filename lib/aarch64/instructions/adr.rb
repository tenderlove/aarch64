module AArch64
  module Instructions
    # ADR -- A64
    # Form PC-relative address
    # ADR  <Xd>, <label>
    class ADR
      def encode
        raise NotImplementedError
      end

      private

      def ADR immlo, immhi, rd
        insn = 0b0_00_10000_0000000000000000000_00000
        insn |= ((immlo & 0x3) << 29)
        insn |= ((immhi & 0x7ffff) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
