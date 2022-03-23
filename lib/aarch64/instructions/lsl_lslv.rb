module AArch64
  module Instructions
    # LSL (register) -- A64
    # Logical Shift Left (register)
    # LSL  <Wd>, <Wn>, <Wm>
    # LSLV <Wd>, <Wn>, <Wm>
    # LSL  <Xd>, <Xn>, <Xm>
    # LSLV <Xd>, <Xn>, <Xm>
    class LSL_LSLV
      def encode
        raise NotImplementedError
      end

      private

      def LSL_LSLV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_00_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
