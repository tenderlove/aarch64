module AArch64
  module Instructions
    # MOV (to/from SP) -- A64
    # Move between register and stack pointer
    # MOV  <Wd|WSP>, <Wn|WSP>
    # ADD <Wd|WSP>, <Wn|WSP>, #0
    # MOV  <Xd|SP>, <Xn|SP>
    # ADD <Xd|SP>, <Xn|SP>, #0
    class MOV_ADD_addsub_imm
      def encode
        raise NotImplementedError
      end

      private

      def MOV_ADD_addsub_imm sf, rn, rd
        insn = 0b0_0_0_100010_0_000000000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
