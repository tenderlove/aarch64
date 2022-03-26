module AArch64
  module Instructions
    # AT -- A64
    # Address Translate
    # AT  <at_op>, <Xt>
    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
    class AT_SYS
      AT_TABLE = {
        :s1e1r  => { :op1 => 0b000, :crm => 0b1000, :op2 => 0b000 },
        :s1e1w  => { :op1 => 0b000, :crm => 0b1000, :op2 => 0b001 },
        :s1e0r  => { :op1 => 0b000, :crm => 0b1000, :op2 => 0b010 },
        :s1e0w  => { :op1 => 0b000, :crm => 0b1000, :op2 => 0b011 },
        :s1e1rp => { :op1 => 0b000, :crm => 0b1001, :op2 => 0b000 },
        :s1e1wp => { :op1 => 0b000, :crm => 0b1001, :op2 => 0b001 },
        :s1e2r  => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b000 },
        :s1e2w  => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b001 },
        :s12e1r => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b100 },
        :s12e1w => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b101 },
        :s12e0r => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b110 },
        :s12e0w => { :op1 => 0b100, :crm => 0b1000, :op2 => 0b111 },
        :s1e3r  => { :op1 => 0b110, :crm => 0b1000, :op2 => 0b000 },
        :s1e3w  => { :op1 => 0b110, :crm => 0b1000, :op2 => 0b001 },
      }

      def initialize at_op, t
        @at_op = at_op
        @t     = t
      end

      def encode
        op = AT_TABLE.fetch(@at_op)
        AT_SYS(op[:op1], op[:op2], op[:crm], @t.to_i)
      end

      private

      def AT_SYS op1, op2, crm, rt
        #insn = 0b1101010100_0_01_000_0111_100x_000_00000
        insn = 0b1101010100_0_01_000_0111_1000_000_00000
        insn |= ((op1 & 0x7) << 16)
        insn |= ((op2 & 0x7) << 5)
        insn |= ((crm & 0xf) << 8)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
