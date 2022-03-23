module AArch64
  module Instructions
    # NGCS -- A64
    # Negate with Carry, setting flags
    # NGCS  <Wd>, <Wm>
    # SBCS <Wd>, WZR, <Wm>
    # NGCS  <Xd>, <Xm>
    # SBCS <Xd>, XZR, <Xm>
    class NGCS_SBCS
      def encode
        raise NotImplementedError
      end

      private

      def NGCS_SBCS sf, rm, rd
        insn = 0b0_1_1_11010000_00000_000000_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
