module AArch64
  module Instructions
    # CSETM -- A64
    # Conditional Set Mask
    # CSETM  <Wd>, <cond>
    # CSINV <Wd>, WZR, WZR, invert(<cond>)
    # CSETM  <Xd>, <cond>
    # CSINV <Xd>, XZR, XZR, invert(<cond>)
    class CSETM_CSINV
      def encode
        raise NotImplementedError
      end

      private

      def CSETM_CSINV sf, rd
        insn = 0b0_1_0_11010100_11111_!= 111x_0_0_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
