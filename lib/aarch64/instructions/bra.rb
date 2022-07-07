module AArch64
  module Instructions
    # BRAA, BRAAZ, BRAB, BRABZ -- A64
    # Branch to Register, with pointer authentication
    # BRAAZ  <Xn>
    # BRAA  <Xn>, <Xm|SP>
    # BRABZ  <Xn>
    # BRAB  <Xn>, <Xm|SP>
    class BRA < Instruction
      def initialize rn, rm, z, m
        @rn = rn
        @rm = rm
        @z  = z
        @m  = m
      end

      def encode
        BRA(@z, @m, @rn.to_i, @rm.to_i)
      end

      private

      def BRA z, m, rn, rm
        insn = 0b1101011_0_0_00_11111_0000_1_0_00000_00000
        insn |= ((z & 0x1) << 24)
        insn |= ((m & 0x1) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rm & 0x1f)
        insn
      end
    end
  end
end
