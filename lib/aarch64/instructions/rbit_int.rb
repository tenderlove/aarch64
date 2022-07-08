module AArch64
  module Instructions
    # RBIT -- A64
    # Reverse Bits
    # RBIT  <Wd>, <Wn>
    # RBIT  <Xd>, <Xn>
    class RBIT_int < Instruction
      def initialize rd, rn, sf
        @rd = rd
        @rn = rn
        @sf = sf
      end

      def encode
        RBIT_int(@sf, @rn.to_i, @rd.to_i)
      end

      private

      def RBIT_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_0000_00_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
