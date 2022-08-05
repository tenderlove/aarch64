module AArch64
  module Instructions
    # MOVK -- A64
    # Move wide with keep
    # MOVK  <Wd>, #<imm>{, LSL #<shift>}
    # MOVK  <Xd>, #<imm>{, LSL #<shift>}
    class MOVK < Instruction
      def initialize reg, imm, shift, sf
        @reg   = check_mask(reg, 0x1f)
        @imm   = check_mask(imm, 0xffff)
        @shift = check_mask(shift, 0x03)
        @sf    = check_mask(sf, 0x01)
      end

      def encode
        MOVK(@sf, @shift, @imm, @reg)
      end

      private

      def MOVK sf, hw, imm16, rd
        insn = 0b0_11_100101_00_0000000000000000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(hw, 0x3)) << 21)
        insn |= ((apply_mask(imm16, 0xffff)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
