module AArch64
  module Instructions
    # MOV (register) -- A64
    # Move (register)
    # MOV  <Wd>, <Wm>
    # ORR <Wd>, WZR, <Wm>
    # MOV  <Xd>, <Xm>
    # ORR <Xd>, XZR, <Xm>
    class MOV_ORR_log_shift
      def encode
        raise NotImplementedError
      end

      private

      def MOV_ORR_log_shift sf, rm, rd
        insn = 0b0_01_01010_00_0_00000_000000_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
