module AArch64
  module Instructions
    # SETGPT, SETGMT, SETGET -- A64
    # Memory Set with tag setting, unprivileged
    # SETGET  [<Xd>]!, <Xn>!, <Xs>
    # SETGMT  [<Xd>]!, <Xn>!, <Xs>
    # SETGPT  [<Xd>]!, <Xn>!, <Xs>
    class SETGPT < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETGPT sz, rs, rn, rd
        insn = 0b00_011_1_01_11_0_00000_xx01_01_00000_00000
        insn |= ((apply_mask(sz, 0x3)) << 30)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
