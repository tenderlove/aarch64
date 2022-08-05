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
        @z  = z
        @rd = rd
        @rn = rn
      end

      def encode
        AUTIA(@z, @rn, @rd)
      end

      private

      def AUTIA z, rn, rd
        insn = 0b1_1_0_11010110_00001_0_0_0_100_00000_00000
        insn |= ((apply_mask(z, 0x1)) << 13)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
