module AArch64
  module Instructions
    # CSET -- A64
    # Conditional Set
    # CSET  <Wd>, <cond>
    # CSINC <Wd>, WZR, WZR, invert(<cond>)
    # CSET  <Xd>, <cond>
    # CSINC <Xd>, XZR, XZR, invert(<cond>)
    class CSET_CSINC
      def encode
        raise NotImplementedError
      end

      private

      def CSET_CSINC sf, rd
        insn = 0b0_0_0_11010100_11111_!= 111x_0_1_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
