module AArch64
  module Instructions
    # CLZ -- A64
    # Count Leading Zeros
    # CLZ  <Wd>, <Wn>
    # CLZ  <Xd>, <Xn>
    class CLZ_int
      def encode
        raise NotImplementedError
      end

      private

      def CLZ_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_00010_0_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
