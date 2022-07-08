module AArch64
  module Instructions
    # SETPTN, SETMTN, SETETN -- A64
    # Memory Set, unprivileged and non-temporal
    # SETETN  [<Xd>]!, <Xn>!, <Xs>
    # SETMTN  [<Xd>]!, <Xn>!, <Xs>
    # SETPTN  [<Xd>]!, <Xn>!, <Xs>
    class SETPTN < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETPTN sz, rs, rn, rd
        insn = 0b00_011_0_01_11_0_00000_xx11_01_00000_00000
        insn |= ((apply_mask(sz, 0x3)) << 30)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
