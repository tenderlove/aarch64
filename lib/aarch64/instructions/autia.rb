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
      def initialize d, n
        @d = d
        @n = n
      end

      def encode
        if @n.integer?
          AUTIA(1, @n.to_i, @d.to_i)
        else
          AUTIA(0, @n.to_i, @d.to_i)
        end
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
