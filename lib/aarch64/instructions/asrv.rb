module AArch64
  module Instructions
    # ASRV -- A64
    # Arithmetic Shift Right Variable
    # ASRV  <Wd>, <Wn>, <Wm>
    # ASRV  <Xd>, <Xn>, <Xm>
    class ASRV
      def initialize d, n, m
        @d = d
        @n = n
        @m = m
      end

      def encode
        ASRV(@d.sf, @m.to_i, @n.to_i, @d.to_i)
      end

      private

      def ASRV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_10_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
