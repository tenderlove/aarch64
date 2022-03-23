module AArch64
  module Instructions
    # MOV (bitmask immediate) -- A64
    # Move (bitmask immediate)
    # MOV  <Wd|WSP>, #<imm>
    # ORR <Wd|WSP>, WZR, #<imm>
    # MOV  <Xd|SP>, #<imm>
    # ORR <Xd|SP>, XZR, #<imm>
    class MOV_ORR_log_imm
      def encode
        raise NotImplementedError
      end

      private

      def MOV_ORR_log_imm sf, n, immr, imms, rd
        insn = 0b0_01_100100_0_000000_000000_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
