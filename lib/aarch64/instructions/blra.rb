module AArch64
  module Instructions
    # BLRAA, BLRAAZ, BLRAB, BLRABZ -- A64
    # Branch with Link to Register, with pointer authentication
    # BLRAAZ  <Xn>
    # BLRAA  <Xn>, <Xm|SP>
    # BLRABZ  <Xn>
    # BLRAB  <Xn>, <Xm|SP>
    class BLRA < Instruction
      def initialize rn, rm, z, m
        @rn = rn
        @rm = rm
        @z  = z
        @m  = m
      end

      def encode
        BLRA(@z, @m, @rn, @rm)
      end

      private

      def BLRA z, m, rn, rm
        insn = 0b1101011_0_0_01_11111_0000_1_0_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 24)
        insn |= ((apply_mask(m, 0x1)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rm, 0x1f))
        insn
      end
    end
  end
end
