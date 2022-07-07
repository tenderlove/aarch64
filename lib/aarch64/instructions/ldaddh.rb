module AArch64
  module Instructions
    # LDADDH, LDADDAH, LDADDALH, LDADDLH -- A64
    # Atomic add on halfword in memory
    # LDADDAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDADDH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDADDH(@a, @r, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDADDH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_000_00_00000_00000
        insn |= ((a & 0x1) << 23)
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
