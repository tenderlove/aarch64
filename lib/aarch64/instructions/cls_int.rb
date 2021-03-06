module AArch64
  module Instructions
    # CLS -- A64
    # Count Leading Sign bits
    # CLS  <Wd>, <Wn>
    # CLS  <Xd>, <Xn>
    class CLS_int
      def initialize rd, rn, sf
        @rd = rd
        @rn = rn
        @sf = sf
      end

      def encode
        CLS_int(@sf, @rn.to_i, @rd.to_i)
      end

      private

      def CLS_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_00010_1_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
