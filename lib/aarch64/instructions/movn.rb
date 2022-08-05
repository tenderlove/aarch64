module AArch64
  module Instructions
    # MOVN -- A64
    # Move wide with NOT
    # MOVN  <Wd>, #<imm>{, LSL #<shift>}
    # MOVN  <Xd>, #<imm>{, LSL #<shift>}
    class MOVN < Instruction
      def initialize rd, imm16, hw, sf
        @rd    = check_mask(rd, 0x1f)
        @imm16 = check_mask(imm16, 0xffff)
        @hw    = check_mask(hw, 0x03)
        @sf    = check_mask(sf, 0x01)
      end

      def encode
        MOVN(@sf, @hw, @imm16, @rd)
      end

      private

      def MOVN sf, hw, imm16, rd
        insn = 0b0_00_100101_00_0000000000000000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(hw, 0x3)) << 21)
        insn |= ((apply_mask(imm16, 0xffff)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
