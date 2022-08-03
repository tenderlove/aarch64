module AArch64
  module Instructions
    # AUTDB, AUTDZB -- A64
    # Authenticate Data address, using key B
    # AUTDB  <Xd>, <Xn|SP>
    # AUTDZB  <Xd>
    class AUTDB < Instruction
      def initialize d, n
        @d = d
        @n = n
      end

      def encode
        if @n.integer?
          AUTDB(1, @n, @d)
        else
          AUTDB(0, @n, @d)
        end
      end

      private

      def AUTDB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_111_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 13)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
