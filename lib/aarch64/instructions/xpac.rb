module AArch64
  module Instructions
    # XPACD, XPACI, XPACLRI -- A64
    # Strip Pointer Authentication Code
    # XPACD  <Xd>
    # XPACI  <Xd>
    # XPACLRI
    class XPAC
      def initialize rd, d
        @rd = rd
        @d  = d
      end

      def encode
        self.XPAC(@d, @rd.to_i)
      end

      private

      def XPAC d, rd
        insn = 0b1_1_0_11010110_00001_0_1_000_0_11111_00000
        insn |= ((d & 0x1) << 10)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
