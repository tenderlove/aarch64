require "aarch64/instructions"

module AArch64
  module Registers
    class Register < Struct.new(:to_i, :sf, :x?)
      def integer?; false; end
    end

    31.times { |i|
      const_set(:"X#{i}", Register.new(i, 1, true))
      const_set(:"W#{i}", Register.new(i, 0, false))
    }
  end

  class Assembler
    include Instructions
    include Registers

    class Label
      def initialize name
        @name   = name
        @offset = nil
      end

      def set_offset offset
        @offset = offset
        freeze
      end

      def to_i
        @offset * 4
      end
    end

    def initialize
      @insns = []
    end

    def make_label name
      Label.new name
    end

    def put_label label
      label.set_offset @insns.length
    end

    def adc d, n, m
      @insns = @insns << ADC.new(d, n, m)
    end

    def adcs d, n, m
      @insns = @insns << ADCS.new(d, n, m)
    end

    def add d, n, m, extend: nil, amount: 0, lsl: 0, shift: :lsl
      if extend
        extend = case extend
                 when :uxtb then 0b000
                 when :uxth then 0b001
                 when :uxtw then 0b010
                 when :uxtx then 0b011
                 when :sxtb then 0b100
                 when :sxth then 0b101
                 when :sxtw then 0b110
                 when :sxtx then 0b111
                 else
                   raise "Unknown extend #{extend}"
                 end

        if m.x?
          if (extend & 0x3 != 0x3)
            raise "Wrong extend"
          end
        else
          if (extend & 0x3 == 0x3)
            raise "Wrong extend"
          end
        end

        @insns = @insns << ADD_addsub_ext.new(d, n, m, extend, amount)
      else
        if m.integer?
          # add immediate
          @insns = @insns << ADD_addsub_imm.new(d, n, m, lsl / 12)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          @insns = @insns << ADD_addsub_shift.new(d, n, m, shift, amount)
        end
      end
    end

    def addg xd, xn, imm6, imm4
      @insns = @insns << ADDG.new(xd, xn, imm6, imm4)
    end

    def adds d, n, m, extend: nil, amount: 0, shift: 0
      if extend
        extend = case extend
                 when :uxtb then 0b000
                 when :uxth then 0b001
                 when :uxtw then 0b010
                 when :uxtx then 0b011
                 when :sxtb then 0b100
                 when :sxth then 0b101
                 when :sxtw then 0b110
                 when :sxtx then 0b111
                 else
                   raise "Unknown extend #{extend}"
                 end
        @insns = @insns << ADDS_addsub_ext.new(d, n, m, extend, amount)
      else
        if m.integer?
          @insns = @insns << ADDS_addsub_imm.new(d, n, m, shift)
        else
          raise NotImplementedError
        end
      end
    end

    def b label
      @insns = @insns << B_uncond.new(label)
    end

    def brk imm
      @insns = @insns << BRK.new(imm)
    end

    def movz reg, imm, lsl: 0
      @insns = @insns << MOVZ.new(reg, imm, lsl / 16)
    end

    def movk reg, imm, lsl: 0
      @insns = @insns << MOVK.new(reg, imm, lsl / 16)
    end

    def ret reg = X30
      @insns = @insns << RET.new(reg)
    end

    def write_to io
      io.write @insns.map(&:encode).pack("L<*")
    end
  end
end
