module AArch64
  module Instructions
    # AUTIA, AUTIA1716, AUTIASP, AUTIAZ, AUTIZA -- A64
    # Authenticate Instruction address, using key A
    # AUTIA  <Xd>, <Xn|SP>
    # AUTIZA  <Xd>
    # AUTIA1716
    # AUTIASP
    # AUTIAZ
    class AUTIA < Instruction
      def initialize z, rd, rn
        @z  = check_mask(z, 0x01)
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        AUTIA(@z, @rn, @rd)
      end

      private

      def AUTIA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_100_00000_00000
        insn |= ((z) << 13)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
