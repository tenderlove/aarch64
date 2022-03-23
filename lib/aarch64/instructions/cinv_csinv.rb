module AArch64
  module Instructions
    # CINV -- A64
    # Conditional Invert
    # CINV  <Wd>, <Wn>, <cond>
    # CSINV <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CINV  <Xd>, <Xn>, <cond>
    # CSINV <Xd>, <Xn>, <Xn>, invert(<cond>)
    class CINV_CSINV
      def encode
        raise NotImplementedError
      end

      private

      def CINV_CSINV sf, rd
        insn = 0b0_1_0_11010100_!= 11111_!= 111x_0_0_!= 11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
