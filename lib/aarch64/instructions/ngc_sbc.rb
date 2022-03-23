module AArch64
  module Instructions
    # NGC -- A64
    # Negate with Carry
    # NGC  <Wd>, <Wm>
    # SBC <Wd>, WZR, <Wm>
    # NGC  <Xd>, <Xm>
    # SBC <Xd>, XZR, <Xm>
    class NGC_SBC
      def encode
        raise NotImplementedError
      end

      private

      def NGC_SBC sf, rm, rd
        insn = 0b0_1_0_11010000_00000_000000_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
