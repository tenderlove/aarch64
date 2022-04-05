module AArch64
  module Instructions
    # AND (immediate) -- A64
    # Bitwise AND (immediate)
    # AND  <Wd|WSP>, <Wn>, #<imm>
    # AND  <Xd|SP>, <Xn>, #<imm>
    class AND_log_imm
      def initialize d, n, imm
        @d = d
        @n = n
        @imm = imm
      end

      def encode
        enc = Utils.encode_mask(@imm, @d.size) || raise("Can't encode mask #{@imm}")

        if @d.x?
          AND_log_imm(@d.sf, enc.n, enc.immr, enc.imms, @n.to_i, @d.to_i)
        else
          AND_log_imm(@d.sf, 0, enc.immr, enc.imms, @n.to_i, @d.to_i)
        end
      end

      private

      def AND_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_00_100100_0_000000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
