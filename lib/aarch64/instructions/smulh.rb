module AArch64
  module Instructions
    # SMULH -- A64
    # Signed Multiply High
    # SMULH  <Xd>, <Xn>, <Xm>
    class SMULH
      def initialize rd, rn, rm
        @rd = rd
        @rn = rn
        @rm = rm
      end

      def encode
        SMULH(@rm.to_i, @rn.to_i, @rd.to_i)
      end

      private

      def SMULH rm, rn, rd
        insn = 0b1_00_11011_0_10_00000_0_11111_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
