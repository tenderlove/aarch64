module AArch64
  module Instructions
    # CINC -- A64
    # Conditional Increment
    # CINC  <Wd>, <Wn>, <cond>
    # CSINC <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CINC  <Xd>, <Xn>, <cond>
    # CSINC <Xd>, <Xn>, <Xn>, invert(<cond>)
    class CINC_CSINC
      def encode
        raise NotImplementedError
      end

      private

      def CINC_CSINC sf, rd
        insn = 0b0_0_0_11010100_!= 11111_!= 111x_0_1_!= 11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
