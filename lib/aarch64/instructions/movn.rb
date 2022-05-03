module AArch64
  module Instructions
    # MOVN -- A64
    # Move wide with NOT
    # MOVN  <Wd>, #<imm>{, LSL #<shift>}
    # MOVN  <Xd>, #<imm>{, LSL #<shift>}
    class MOVN
      def initialize rd, imm16, hw, sf
        @rd    = rd
        @imm16 = imm16
        @hw    = hw
        @sf    = sf
      end

      def encode
        MOVN(@sf, @hw, @imm16, @rd.to_i)
      end

      private

      def MOVN sf, hw, imm16, rd
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
