module AArch64
  module Instructions
    # AUTIB, AUTIB1716, AUTIBSP, AUTIBZ, AUTIZB -- A64
    # Authenticate Instruction address, using key B
    # AUTIB  <Xd>, <Xn|SP>
    # AUTIZB  <Xd>
    # AUTIB1716
    # AUTIBSP
    # AUTIBZ
    class AUTIB < Instruction
      def initialize d, n
        @d = d
        @n = n
      end

      def encode
        if @n.integer?
          AUTIB(1, @n.to_i, @d.to_i)
        else
          AUTIB(0, @n.to_i, @d.to_i)
        end
      end

      private

      def AUTIB z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_101_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 13)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
