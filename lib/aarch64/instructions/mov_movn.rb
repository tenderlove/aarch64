module AArch64
  module Instructions
    # MOV (inverted wide immediate) -- A64
    # Move (inverted wide immediate)
    # MOV  <Wd>, #<imm>
    # MOVN <Wd>, #<imm16>, LSL #<shift>
    # MOV  <Xd>, #<imm>
    # MOVN <Xd>, #<imm16>, LSL #<shift>
    class MOV_MOVN
      def encode
        raise NotImplementedError
      end

      private

      def MOV_MOVN sf, hw, imm16, rd
        insn = 0b0_00_100101_00_0000000000000000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((hw & 0x3) << 21)
        insn |= ((imm16 & 0xffff) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
