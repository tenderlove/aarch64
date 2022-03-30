require "aarch64/instructions"
require "aarch64/utils"

module AArch64
  module Registers
    class Register < Struct.new(:to_i, :sf, :x?, :sp?)
      def integer?; false; end
    end

    31.times { |i|
      x = const_set(:"X#{i}", Register.new(i, 1, true, false))
      define_method(:"x#{i}") { x }
      w = const_set(:"W#{i}", Register.new(i, 0, false, false))
      define_method(:"w#{i}") { w }
    }

    SP = Register.new(31, 1, false, true)
    def sp; SP; end
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

    def adds d, n, m, extend: nil, amount: 0, lsl: 0, shift: :lsl
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
          @insns = @insns << ADDS_addsub_imm.new(d, n, m, lsl / 12)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          @insns = @insns << ADDS_addsub_shift.new(d, n, m, shift, amount)
        end
      end
    end

    def adr xd, label
      @insns = @insns << ADR.new(xd, label)
    end

    def adrp xd, label
      @insns = @insns << ADRP.new(xd, label)
    end

    def and d, n, m, shift: :lsl, amount: 0
      if m.integer?
        @insns = @insns << AND_log_imm.new(d, n, m)
      else
        shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
        @insns = @insns << AND_log_shift.new(d, n, m, shift, amount)
      end
    end

    def ands d, n, m, shift: :lsl, amount: 0
      if m.integer?
        @insns = @insns << ANDS_log_imm.new(d, n, m)
      else
        shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
        @insns = @insns << ANDS_log_shift.new(d, n, m, shift, amount)
      end
    end

    def asr d, n, m
      if m.integer?
        @insns = @insns << ASR_SBFM.new(d, n, m)
      else
        @insns = @insns << ASR_ASRV.new(d, n, m)
      end
    end

    def asrv d, n, m
      @insns = @insns << ASRV.new(d, n, m)
    end

    def at at_op, t
      @insns = @insns << AT_SYS.new(at_op, t)
    end

    def autda d, n
      @insns = @insns << AUTDA.new(d, n)
    end

    def autdza d
      @insns = @insns << AUTDA.new(d, 0b11111)
    end

    def autdb d, n
      @insns = @insns << AUTDB.new(d, n)
    end

    def autdzb d
      @insns = @insns << AUTDB.new(d, 0b11111)
    end

    def autia d, n
      @insns = @insns << AUTIA.new(d, n)
    end

    def autiza d
      @insns = @insns << AUTIA.new(d, 0b11111)
    end

    def autia1716
      @insns = @insns << HINT.new(0b0001, 0b100)
    end

    def autiasp
      @insns = @insns << HINT.new(0b0011, 0b101)
    end

    def autiaz
      @insns = @insns << HINT.new(0b0011, 0b100)
    end

    def autib d, n
      @insns = @insns << AUTIB.new(d, n)
    end

    def autizb d
      @insns = @insns << AUTIB.new(d, 0b11111)
    end

    def autib1716
      @insns = @insns << HINT.new(0b0001, 0b110)
    end

    def autibsp
      @insns = @insns << HINT.new(0b0011, 0b111)
    end

    def autibz
      @insns = @insns << HINT.new(0b0011, 0b110)
    end

    def axflag
      @insns = @insns << AXFLAG.new
    end

    def b label, cond: nil
      if cond
        @insns = @insns << B_cond.new(cond, label)
      else
        @insns = @insns << B_uncond.new(label)
      end
    end

    def bc label, cond:
      @insns = @insns << BC_cond.new(cond, label)
    end

    def bfc d, lsb, width
      @insns = @insns << BFC_BFM.new(d, lsb, width)
    end

    def bfi d, lsb, width
      @insns = @insns << BFI_BFM.new(d, lsb, width)
    end

    def bfm d, n, immr, imms
      @insns = @insns << BFM.new(d, n, immr, imms)
    end

    def bfxil d, n, lsb, width
      @insns = @insns << BFXIL_BFM.new(d, n, lsb, width)
    end

    def bic d, n, m, shift: :lsl, amount: 0
      shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
      @insns = @insns << BIC_log_shift.new(d, n, m, shift, amount)
    end

    def bics d, n, m, shift: :lsl, amount: 0
      shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
      @insns = @insns << BICS.new(d, n, m, shift, amount)
    end

    def bl label
      @insns = @insns << BL.new(label)
    end

    def blr n
      @insns = @insns << BLR.new(n)
    end

    def blraaz rn
      @insns = @insns << BLRA.new(rn, 0b11111, 0, 0)
    end

    def blraa rn, rm
      @insns = @insns << BLRA.new(rn, rm, 1, 0)
    end

    def blrabz rn
      @insns = @insns << BLRA.new(rn, 0b11111, 0, 1)
    end

    def blrab rn, rm
      @insns = @insns << BLRA.new(rn, rm, 1, 1)
    end

    def br rn
      @insns = @insns << BR.new(rn)
    end

    def braaz rn
      @insns = @insns << BRA.new(rn, 0b11111, 0, 0)
    end

    def braa rn, rm
      @insns = @insns << BRA.new(rn, rm, 1, 0)
    end

    def brabz rn
      @insns = @insns << BRA.new(rn, 0b11111, 0, 1)
    end

    def brab rn, rm
      @insns = @insns << BRA.new(rn, rm, 1, 1)
    end

    def brk imm
      @insns = @insns << BRK.new(imm)
    end

    def bti target
      target = [:c, :j, :jc].index(target) || raise(NotImplementedError)
      @insns = @insns << BTI.new(target)
    end

    def cas s, t, n_list
      @insns = @insns << CAS.new(s, t, n_list[0], 0, 0)
    end

    def casa s, t, n_list
      @insns = @insns << CAS.new(s, t, n_list[0], 1, 0)
    end

    def casl s, t, n_list
      @insns = @insns << CAS.new(s, t, n_list[0], 0, 1)
    end

    def casal s, t, n_list
      @insns = @insns << CAS.new(s, t, n_list[0], 1, 1)
    end

    def casb rs, rt, rn_list
      @insns = @insns << CASB.new(rs, rt, rn_list[0], 0, 0)
    end

    def casalb rs, rt, rn_list
      @insns = @insns << CASB.new(rs, rt, rn_list[0], 1, 1)
    end

    def caslb rs, rt, rn_list
      @insns = @insns << CASB.new(rs, rt, rn_list[0], 0, 1)
    end

    def casah rs, rt, rn_list
      @insns = @insns << CASH.new(rs, rt, rn_list[0], 1, 0)
    end

    def casalh rs, rt, rn_list
      @insns = @insns << CASH.new(rs, rt, rn_list[0], 1, 1)
    end

    def cash rs, rt, rn_list
      @insns = @insns << CASH.new(rs, rt, rn_list[0], 0, 0)
    end

    def caslh rs, rt, rn_list
      @insns = @insns << CASH.new(rs, rt, rn_list[0], 0, 1)
    end

    def casp rs, rs1, rt, rt1, rn_list
      @insns = @insns << CASP.new(rs, rt, rn_list[0], 0, 0)
    end

    def caspa rs, rs1, rt, rt1, rn_list
      @insns = @insns << CASP.new(rs, rt, rn_list[0], 1, 0)
    end

    def caspl rs, rs1, rt, rt1, rn_list
      @insns = @insns << CASP.new(rs, rt, rn_list[0], 0, 1)
    end

    def caspal rs, rs1, rt, rt1, rn_list
      @insns = @insns << CASP.new(rs, rt, rn_list[0], 1, 1)
    end

    def cbnz rt, label
      @insns = @insns << CBNZ.new(rt, label)
    end

    def cbz rt, label
      @insns = @insns << CBZ.new(rt, label)
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

    def sbfm d, n, immr, imms
      @insns = @insns << SBFM.new(d, n, immr, imms)
    end

    def write_to io
      io.write @insns.map(&:encode).pack("L<*")
    end
  end
end
