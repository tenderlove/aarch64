module AArch64
  module Instructions
    # ASR (register) -- A64
    # Arithmetic Shift Right (register)
    # ASR  <Wd>, <Wn>, <Wm>
    # ASRV <Wd>, <Wn>, <Wm>
    # ASR  <Xd>, <Xn>, <Xm>
    # ASRV <Xd>, <Xn>, <Xm>
    class ASR_ASRV
      def initialize d, n, m
        @d = d
        @n = n
        @m = m
      end

      def encode
        ASR_ASRV(@d.sf, @m.to_i, @n.to_i, @d.to_i)
      end

      private

      def ASR_ASRV sf, rm, rn, rd
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
