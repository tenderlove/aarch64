module AArch64
  module Instructions
    # CNEG -- A64
    # Conditional Negate
    # CNEG  <Wd>, <Wn>, <cond>
    # CSNEG <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CNEG  <Xd>, <Xn>, <cond>
    # CSNEG <Xd>, <Xn>, <Xn>, invert(<cond>)
    class CNEG_CSNEG
      def encode
        raise NotImplementedError
      end

      private

      def CNEG_CSNEG sf, rm, rn, rd
        insn = 0b0_1_0_11010100_00000_!= 111x_0_1_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
