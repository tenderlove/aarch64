module AArch64
  module Instructions
    # PACDB, PACDZB -- A64
    # Pointer Authentication Code for Data address, using key B
    # PACDB  <Xd>, <Xn|SP>
    # PACDZB  <Xd>
    class PACDB < Instruction
      def initialize rd, rn, z
        @rd = rd
        @rn = rn
        @z  = z
      end

      def encode
        PACDB(@z, @rn.to_i, @rd.to_i)
      end

      private

      def PACDB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_011_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 13)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
