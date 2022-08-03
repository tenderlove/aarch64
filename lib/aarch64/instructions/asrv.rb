module AArch64
  module Instructions
    # ASRV -- A64
    # Arithmetic Shift Right Variable
    # ASRV  <Wd>, <Wn>, <Wm>
    # ASRV  <Xd>, <Xn>, <Xm>
    class ASRV < Instruction
      def initialize rd, rn, rm, sf
        @rd = rd
        @rn = rn
        @rm = rm
        @sf = sf
      end

      def encode
        ASRV(@sf, @rm, @rn, @rd)
      end

      private

      def ASRV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_10_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
