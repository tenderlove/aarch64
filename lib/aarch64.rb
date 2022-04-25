# frozen_string_literal: true

require "aarch64/instructions"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64/utils"

module AArch64
  module Registers
    class Register < Struct.new(:to_i, :sf, :x?, :sp?, :zr?, :size)
      def integer?; false; end
      def sizeb
        x? ? 0b11 : 0b10
      end

      def opc
        x? ? 0b10 : 0b11
      end

      def opc2
        x? ? 0b11 : 0b10
      end

      def zr
        x? ? XZR : WZR
      end
    end

    31.times { |i|
      x = const_set(:"X#{i}", Register.new(i, 1, true, false, false, 64))
      define_method(:"x#{i}") { x }
      w = const_set(:"W#{i}", Register.new(i, 0, false, false, false, 32))
      define_method(:"w#{i}") { w }
    }

    SP = Register.new(31, 1, true, true, false, 64)
    def sp; SP; end

    WSP = Register.new(31, 0, false, true, false, 32)
    def wsp; WSP; end

    XZR = Register.new(31, 1, true, false, true, 64)
    def xzr; XZR; end

    WZR = Register.new(31, 0, false, false, true, 32)
    def wzr; WZR; end
  end

  module Conditions
    module_eval Utils::COND_TABLE.keys.map { |key|
      "def #{key.downcase}; #{key.dump}; end"
    }.join("\n")
  end

  module Names
    module_eval 0x10.times.map { |i|
      const_set(:"C#{i}", i)
      "def c#{i}; #{i}; end"
    }.join("\n")
  end

  module Extends
    class Extend < Struct.new(:amount, :type, :name)
      def extend?; true; end
      def shift?; false; end
    end

    module_eval [
      :uxtb,
      :uxth,
      :uxtw,
      :uxtx,
      :sxtb,
      :sxth,
      :sxtw,
      :sxtx ].map.with_index { |n, i|
        "def #{n}(amount = 0); Extend.new(amount, #{i}, :#{n}); end"
      }.join("\n")
  end

  module Shifts
    class Shift < Struct.new(:amount, :type, :name)
      def extend?; false; end
      def shift?; true; end
    end

    module_eval [:lsl, :lsr, :asr, :ror].map.with_index { |n, i|
      "def #{n}(amount = 0); Shift.new(amount, #{i}, :#{n}); end"
    }.join("\n")
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

    def adds d, n, m, option = nil, extend: nil, amount: 0, lsl: 0, shift: :lsl
      if n.sp? && !m.integer?
        if n.x?
          extend ||= :uxtx
        else
          extend ||= :uxtw
        end
      end

      if option
        if option.extend?
          extend = option.name
          amount = option.amount
        else
          if m.integer?
            lsl = option.amount
          else
            shift = option.name
            amount = option.amount
          end
        end
      end

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

    def bfc rd, lsb, width
      div = rd.x? ? 64 : 32
      rn  = rd.x? ? XZR : WZR
      bfm(rd, rn, -lsb % div, width - 1)
    end

    def bfi rd, rn, lsb, width
      div = rd.x? ? 64 : 32
      bfm(rd, rn, -lsb % div, width - 1)
    end

    def bfm d, n, immr, imms
      @insns = @insns << BFM.new(d, n, immr, imms)
    end

    def bfxil d, n, lsb, width
      @insns = @insns << BFXIL_BFM.new(d, n, lsb, width)
    end

    def bic d, n, m, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
      @insns = @insns << BIC_log_shift.new(d, n, m, shift, amount)
    end

    def bics d, n, m, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
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

    def ccmn rn, rm, nzcv, cond
      if rm.integer?
        @insns = @insns << CCMN_imm.new(rn, rm, nzcv, cond)
      else
        @insns = @insns << CCMN_reg.new(rn, rm, nzcv, cond)
      end
    end

    def ccmp rn, rm, nzcv, cond
      if rm.integer?
        @insns = @insns << CCMP_imm.new(rn, rm, nzcv, cond)
      else
        @insns = @insns << CCMP_reg.new(rn, rm, nzcv, cond)
      end
    end

    def cfinv
      @insns = @insns << CFINV.new
    end

    def cfp_rcfx rt
      @insns = @insns << CFP_SYS.new(rt)
    end

    def cinc rd, rn, cond
      @insns = @insns << CSINC.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1)
    end

    def cset rd, cond
      @insns = @insns << CSINC.new(rd, WZR, WZR, Utils.cond2bin(cond) ^ 1)
    end

    def csetm rd, cond
      reg = rd.x? ? XZR : WZR
      @insns = @insns << CSINV.new(rd, reg, reg, Utils.cond2bin(cond) ^ 1)
    end

    def csinc rd, rn, rm, cond
      @insns = @insns << CSINC.new(rd, rn, rm, Utils.cond2bin(cond))
    end

    def cinv rd, rn, cond
      @insns = @insns << CSINV.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1)
    end

    def csinv rd, rn, rm, cond
      @insns = @insns << CSINV.new(rd, rn, rm, Utils.cond2bin(cond))
    end

    def clrex imm = 15
      @insns = @insns << CLREX.new(imm)
    end

    def cls rd, rn
      @insns = @insns << CLS_int.new(rd, rn)
    end

    def clz rd, rn
      @insns = @insns << CLZ_int.new(rd, rn)
    end

    def cmn rn, rm, option = nil, extend: nil, amount: 0, shift: :lsl, lsl: 0
      if rn.x?
        adds(XZR, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
      else
        adds(WZR, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
      end
    end

    def cmp rn, rm, option = nil, extend: nil, amount: 0, shift: :lsl, lsl: 0
      if rn.x?
        subs(XZR, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
      else
        subs(WZR, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
      end
    end

    def cmpp xn, xm
      subps XZR, xn, xm
    end

    def cneg rd, rn, cond
      @insns = @insns << CSNEG.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1)
    end

    def cpp _, xn
      sys 3, Names::C7, Names::C3, 7, xn
    end

    def crc32b rd, rn, rm
      @insns = @insns << CRC32.new(rd, rn, rm, 0x00)
    end

    def crc32h rd, rn, rm
      @insns = @insns << CRC32.new(rd, rn, rm, 0x01)
    end

    def crc32w rd, rn, rm
      @insns = @insns << CRC32.new(rd, rn, rm, 0x02)
    end

    def crc32x rd, rn, rm
      @insns = @insns << CRC32.new(rd, rn, rm, 0x03)
    end

    def crc32cb rd, rn, rm
      @insns = @insns << CRC32C.new(rd, rn, rm, 0x00)
    end

    def crc32ch rd, rn, rm
      @insns = @insns << CRC32C.new(rd, rn, rm, 0x01)
    end

    def crc32cw rd, rn, rm
      @insns = @insns << CRC32C.new(rd, rn, rm, 0x02)
    end

    def crc32cx rd, rn, rm
      @insns = @insns << CRC32C.new(rd, rn, rm, 0x03)
    end

    def csdb
      @insns = @insns << CSDB.new
    end

    def csel rd, rn, rm, cond
      @insns = @insns << CSEL.new(rd, rn, rm, Utils.cond2bin(cond))
    end

    def csneg rd, rn, rm, cond
      @insns = @insns << CSNEG.new(rd, rn, rm, Utils.cond2bin(cond))
    end

    def dc dc_op, xt
      op1, cm, op2 = Utils.dc_op(dc_op)
      sys op1, Names::C7, cm, op2, xt
    end

    def dcps1 imm = 0
      @insns = @insns << DCPS.new(imm, 0x1)
    end

    def dcps2 imm = 0
      @insns = @insns << DCPS.new(imm, 0x2)
    end

    def dcps3 imm = 0
      @insns = @insns << DCPS.new(imm, 0x3)
    end

    def dgh
      @insns = @insns << DGH.new
    end

    def dmb option
      if Numeric === option
        @insns = @insns << DMB.new(option)
      else
        @insns = @insns << DMB.new(Utils.dmb2imm(option))
      end
    end

    def drps
      @insns = @insns << DRPS.new
    end

    def dsb option
      if Numeric === option
        @insns = @insns << DSB.new(option)
      else
        @insns = @insns << DSB.new(Utils.dmb2imm(option))
      end
    end

    def dvp _, xt
      sys 3, Names::C7, Names::C3, 5, xt
    end

    def eon d, n, m, option = nil, amount: 0, shift: :lsl
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
      @insns = @insns << EON.new(d, n, m, shift, amount)
    end

    def eor rd, rn, rm, options = nil, shift: :lsl, amount: 0
      if options
        shift = options.name
        amount = options.amount
      end

      if rm.integer?
        encoding = Utils.encode_mask(rm, rd.size)
        n = rd.x? ? encoding.n : 0
        @insns = @insns << EOR_log_imm.new(rd, rn, n, encoding.immr, encoding.imms)
      else
        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
        @insns = @insns << EOR_log_shift.new(rd, rn, rm, shift, amount)
      end
    end

    def eret
      @insns = @insns << ERET.new
    end

    def eretaa
      @insns = @insns << ERETA.new(0)
    end

    def eretab
      @insns = @insns << ERETA.new(1)
    end

    def esb
      @insns = @insns << ESB.new
    end

    def extr rd, rn, rm, lsb
      @insns = @insns << EXTR.new(rd, rn, rm, lsb)
    end

    def gmi rd, rn, rm
      @insns = @insns << GMI.new(rd, rn, rm)
    end

    def hint imm
      @insns = @insns << HINT.new(31, imm)
    end

    def hlt imm
      @insns = @insns << HLT.new(imm)
    end

    def hvc imm
      @insns = @insns << HVC.new(imm)
    end

    def ic op, xt = SP
      op1, crm, op2 = Utils.ic_op(op)
      sys op1, Names::C7, crm, op2, xt
    end

    def irg rd, rn, rm = XZR
      @insns = @insns << IRG.new(rd, rn, rm)
    end

    def isb option = 0b1111
      @insns = @insns << ISB.new(option)
    end

    def ldadd rs, rt, rn
      if rs.x?
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b11, 0, 0)
      else
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b10, 0, 0)
      end
    end

    def ldadda rs, rt, rn
      if rs.x?
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b11, 1, 0)
      else
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b10, 1, 0)
      end
    end

    def ldaddal rs, rt, rn
      if rs.x?
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b11, 1, 1)
      else
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b10, 1, 1)
      end
    end

    def ldaddl rs, rt, rn
      if rs.x?
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b11, 0, 1)
      else
        @insns = @insns << LDADD.new(rs, rt, rn.first, 0b10, 0, 1)
      end
    end

    def ldaddab rs, rt, rn
      @insns = @insns << LDADDB.new(rs, rt, rn.first, 1, 0)
    end

    def ldaddalb rs, rt, rn
      @insns = @insns << LDADDB.new(rs, rt, rn.first, 1, 1)
    end

    def ldaddb rs, rt, rn
      @insns = @insns << LDADDB.new(rs, rt, rn.first, 0, 0)
    end

    def ldaddlb rs, rt, rn
      @insns = @insns << LDADDB.new(rs, rt, rn.first, 0, 1)
    end

    def ldaddah rs, rt, rn
      @insns = @insns << LDADDH.new(rs, rt, rn.first, 1, 0)
    end

    def ldaddalh rs, rt, rn
      @insns = @insns << LDADDH.new(rs, rt, rn.first, 1, 1)
    end

    def ldaddh rs, rt, rn
      @insns = @insns << LDADDH.new(rs, rt, rn.first, 0, 0)
    end

    def ldaddlh rs, rt, rn
      @insns = @insns << LDADDH.new(rs, rt, rn.first, 0, 1)
    end

    def ldapr rt, rn
      if rt.x?
        @insns = @insns << LDAPR.new(rt, rn.first, 0b11)
      else
        @insns = @insns << LDAPR.new(rt, rn.first, 0b10)
      end
    end

    def ldaprb rt, rn
      @insns = @insns << LDAPRB.new(rt, rn.first)
    end

    def ldaprh rt, rn
      @insns = @insns << LDAPRH.new(rt, rn.first)
    end

    def ldapur rt, rn
      if rt.x?
        @insns = @insns << LDAPUR_gen.new(0b11, 0b01, rt, rn.first, rn[1] || 0)
      else
        @insns = @insns << LDAPUR_gen.new(0b10, 0b01, rt, rn.first, rn[1] || 0)
      end
    end

    def ldapurb rt, rn
      @insns = @insns << LDAPUR_gen.new(0b00, 0b01, rt, rn.first, rn[1] || 0)
    end

    def ldapurh rt, rn
      @insns = @insns << LDAPUR_gen.new(0b01, 0b01, rt, rn.first, rn[1] || 0)
    end

    def ldapursb rt, rn
      if rt.x?
        @insns = @insns << LDAPUR_gen.new(0b00, 0b10, rt, rn.first, rn[1] || 0)
      else
        @insns = @insns << LDAPUR_gen.new(0b00, 0b11, rt, rn.first, rn[1] || 0)
      end
    end

    def ldapursh rt, rn
      if rt.x?
        @insns = @insns << LDAPUR_gen.new(0b01, 0b10, rt, rn.first, rn[1] || 0)
      else
        @insns = @insns << LDAPUR_gen.new(0b01, 0b11, rt, rn.first, rn[1] || 0)
      end
    end

    def ldapursw rt, rn
      @insns = @insns << LDAPUR_gen.new(0b10, 0b10, rt, rn.first, rn[1] || 0)
    end

    def ldar rt, rn
      size = rt.x? ? 0b11 : 0b10
      @insns = @insns << LDAR.new(rt, rn.first, size)
    end

    def ldarb rt, rn
      @insns = @insns << LDAR.new(rt, rn.first, 0x00)
    end

    def ldarh rt, rn
      @insns = @insns << LDAR.new(rt, rn.first, 0x01)
    end

    def ldaxp rt1, rt2, xn
      @insns = @insns << LDAXP.new(rt1, rt2, xn.first)
    end

    def ldaxr rt1, xn
      size = rt1.x? ? 0b11 : 0b10
      @insns = @insns << LDAXR.new(rt1, xn.first, size)
    end

    def ldaxrb rt1, xn
      @insns = @insns << LDAXR.new(rt1, xn.first, 0b00)
    end

    def ldaxrh rt1, xn
      @insns = @insns << LDAXR.new(rt1, xn.first, 0b01)
    end

    def ldclr rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDCLR.new(rs, rt, rn.first, 0, 0, size)
    end

    def ldclra rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDCLR.new(rs, rt, rn.first, 1, 0, size)
    end

    def ldclral rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDCLR.new(rs, rt, rn.first, 1, 1, size)
    end

    def ldclrl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDCLR.new(rs, rt, rn.first, 0, 1, size)
    end

    def ldclrab rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 1, 0, 0b00)
    end

    def ldclralb rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 1, 1, 0b00)
    end

    def ldclrb rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 0, 0, 0b00)
    end

    def ldclrlb rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 0, 1, 0b00)
    end

    def ldclrah rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 1, 0, 0b01)
    end

    def ldclralh rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 1, 1, 0b01)
    end

    def ldclrh rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 0, 0, 0b01)
    end

    def ldclrlh rs, rt, rn
      @insns = @insns << LDCLRB.new(rs, rt, rn.first, 0, 1, 0b01)
    end

    def ldeor rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 0, size)
    end

    def ldeora rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 0, size)
    end

    def ldeoral rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 1, size)
    end

    def ldeorl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 1, size)
    end

    def ldeorab rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 0, 0b00)
    end

    def ldeoralb rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 1, 0b00)
    end

    def ldeorb rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 0, 0b00)
    end

    def ldeorlb rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 1, 0b00)
    end

    def ldeorah rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 0, 0b01)
    end

    def ldeoralh rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 1, 1, 0b01)
    end

    def ldeorh rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 0, 0b01)
    end

    def ldeorlh rs, rt, rn
      @insns = @insns << LDEOR.new(rs, rt, rn.first, 0, 1, 0b01)
    end

    def ldg xt, xn
      a LDG.new(xt, xn.first, xn[1] || 0)
    end

    def ldgm xt, xn
      a LDGM.new(xt, xn.first)
    end

    def ldlar rt, rn
      size = rt.x? ? 0b11 : 0b10
      @insns = @insns << LDLAR.new(rt, rn.first, size)
    end

    def ldlarb rt, rn
      @insns = @insns << LDLAR.new(rt, rn.first, 0b00)
    end

    def ldlarh rt, rn
      @insns = @insns << LDLAR.new(rt, rn.first, 0b01)
    end

    def ldnp rt1, rt2, rn
      opc = rt1.x? ? 0b10 : 0b00
      div = rt1.x? ? 8 : 4
      @insns = @insns << LDNP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, opc)
    end

    def ldp rt1, rt2, rn, imm = nil
      opc = rt1.x? ? 0b10 : 0b00
      div = rt1.x? ? 8 : 4

      if imm
        if imm == :!
          # pre-index
          @insns = @insns << LDP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, 0b011, opc)
        else
          # post-index
          @insns = @insns << LDP_gen.new(rt1, rt2, rn.first, (imm || 0) / div, 0b001, opc)
        end
      else
        # signed offset
        @insns = @insns << LDP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, 0b010, opc)
      end
    end

    def ldpsw rt, rt2, rn, imm = nil
      div = 4

      if imm
        if imm == :!
          # pre-index
          @insns = @insns << LDPSW.new(rt, rt2, rn.first, (rn[1] || 0) / div, 0b011)
        else
          # post-index
          @insns = @insns << LDPSW.new(rt, rt2, rn.first, (imm || 0) / div, 0b001)
        end
      else
        # signed offset
        @insns = @insns << LDPSW.new(rt, rt2, rn.first, (rn[1] || 0) / div, 0b010)
      end
    end

    def ldr rt, rn, simm = nil
      size = rt.x? ? 0b11 : 0b10

      if simm
        if simm == :!
          @insns = @insns << LDR_imm_gen.new(rt, rn.first, (rn[1] || 0), size, 0b11)
        else
          if simm.integer?
            @insns = @insns << LDR_imm_gen.new(rt, rn.first, simm, size, 0b01)
          else
            raise
          end
        end
      else
        if rn.is_a?(Array)
          simm = rn[1] || 0
          if simm.integer?
            div = rt.x? ? 8 : 4
            @insns = @insns << LDR_imm_unsigned.new(rt, rn.first, simm / div, size)
          else
            rn, rm, option = *rn
            option ||= Shifts::Shift.new(0, 0, :lsl)
            extend = case option.name
                     when :uxtw then 0b010
                     when :lsl  then 0b011
                     when :sxtw then 0b110
                     when :sxtx then 0b111
                     else
                       raise
                     end

            amount = if rt.x?
                       if option.amount == 3
                         1
                       else
                         0
                       end
                     else
                       if option.amount == 2
                         1
                       else
                         0
                       end
                     end

            @insns = @insns << LDR_reg_gen.new(rt, rn, rm, size, extend, amount)
          end
        else
          size = rt.x? ? 0b01 : 0b00
          @insns = @insns << LDR_lit_gen.new(rt, rn, size)
        end
      end
    end

    def ldraa xt, xn, option = nil
      imm = xn[1] || 0
      s = imm < 0 ? 1 : 0
      a LDRA.new(xt, xn.first, imm / 8, 0, option == :! ? 1 : 0, s)
    end

    def ldrab xt, xn, option = nil
      imm = xn[1] || 0
      s = imm < 0 ? 1 : 0
      a LDRA.new(xt, xn.first, imm / 8, 1, option == :! ? 1 : 0, s)
    end

    def ldrb wt, xn, imm = nil
      if imm
        if imm == :!
          a LDRB_imm.new(wt, xn.first, xn[1], 0b11)
        else
          # Post index
          a LDRB_imm.new(wt, xn.first, imm, 0b01)
        end
      else
        xn, imm, option = *xn
        imm ||= 0
        if imm.integer?
          a LDRB_unsigned.new(wt, xn, imm)
        else
          if option
            option_name = option ? option.name : :lsl

            val = case option_name
                  when :lsl then 0b011
                  when :uxtw then 0b010
                  when :sxtw then 0b110
                  when :sxtx then 0b111
                  end

            a LDRB_reg.new(wt, xn, imm, option.shift? ? 1 : 0, val)
          else
            a LDRB_reg.new(wt, xn, imm, 0, 0b11)
          end
        end
      end
    end

    def ldrh wt, xn, imm = nil
      if imm
        if imm == :!
          a LDRH_imm.new(wt, xn.first, xn[1], 0b11)
        else
          # Post index
          a LDRH_imm.new(wt, xn.first, imm, 0b01)
        end
      else
        xn, imm, option = *xn
        imm ||= 0
        if imm.integer?
          a LDRH_unsigned.new(wt, xn, imm)
        else
          if option
            option_name = option ? option.name : :lsl

            val = case option_name
                  when :lsl then 0b011
                  when :uxtw then 0b010
                  when :sxtw then 0b110
                  when :sxtx then 0b111
                  end

            a LDRH_reg.new(wt, xn, imm, option.shift? ? 1 : 0, val)
          else
            a LDRH_reg.new(wt, xn, imm, 0, 0b11)
          end
        end
      end
    end

    def ldrsb wt, xn, imm = nil
      opc = wt.x? ? 0b10 : 0b11

      if imm
        if imm == :!
          a LDRSB_imm.new(wt, xn.first, xn[1], 0b11, opc)
        else
          # Post index
          a LDRSB_imm.new(wt, xn.first, imm, 0b01, opc)
        end
      else
        xn, imm, option = *xn
        imm ||= 0
        if imm.integer?
          a LDRSB_unsigned.new(wt, xn, imm, opc)
        else
          if option
            option_name = option ? option.name : :lsl

            val = case option_name
                  when :uxtw then 0b010
                  when :sxtw then 0b110
                  when :sxtx then 0b111
                  end

            a LDRSB_reg.new(wt, xn, imm, 1, val, opc)
          else
            a LDRSB_reg.new(wt, xn, imm, 0, 0b11, opc)
          end
        end
      end
    end

    def ldrsh wt, xn, imm = nil
      opc = wt.x? ? 0b10 : 0b11

      if imm
        if imm == :!
          a LDRSH_imm.new(wt, xn.first, xn[1] || 0, 0b11, opc)
        else
          a LDRSH_imm.new(wt, xn.first, imm, 0b01, opc)
        end
      else
        xn, imm, option = *xn
        imm ||= 0
        if imm.integer?
          a LDRSH_unsigned.new(wt, xn, imm / 2, opc)
        else
          if option
            option_name = option ? option.name : :lsl

            val = case option_name
                  when :uxtw then 0b010
                  when :sxtw then 0b110
                  when :sxtx then 0b111
                  end

            a LDRSH_reg.new(wt, xn, imm, 1, val, opc)
          else
            a LDRSH_reg.new(wt, xn, imm, 0, 0b11, opc)
          end
        end
      end
    end

    def ldrsw xt, xn, imm = nil
      if imm
        if imm == :!
          a LDRSW_imm.new(xt, xn.first, xn[1] || 0, 0b11)
        else
          a LDRSW_imm.new(xt, xn.first, imm, 0b01)
        end
      else
        if xn.is_a?(Array)
          xn, imm, option = *xn
          imm ||= 0
          if imm.integer?
            a LDRSW_unsigned.new(xt, xn, imm / 4)
          else
            if option
              option_name = option ? option.name : :lsl

              val = case option_name
                    when :uxtw then 0b010
                    when :lsl  then 0b011
                    when :sxtw then 0b110
                    when :sxtx then 0b111
                    end

              a LDRSW_reg.new(xt, xn, imm, option.amount / 2, val)
            else
              a LDRSW_reg.new(xt, xn, imm, 0, 0b11)
            end
          end
        else
          a LDRSW_lit.new(xt, xn)
        end
      end
    end

    def ldset rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSET.new(rs, rt, rn.first, size, 0, 0)
    end

    def ldseta rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSET.new(rs, rt, rn.first, size, 1, 0)
    end

    def ldsetal rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSET.new(rs, rt, rn.first, size, 1, 1)
    end

    def ldsetl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSET.new(rs, rt, rn.first, size, 0, 1)
    end

    def ldsetb rs, rt, rn
      a LDSETB.new(rs, rt, rn.first, 0, 0)
    end

    def ldsetab rs, rt, rn
      a LDSETB.new(rs, rt, rn.first, 1, 0)
    end

    def ldsetalb rs, rt, rn
      a LDSETB.new(rs, rt, rn.first, 1, 1)
    end

    def ldsetlb rs, rt, rn
      a LDSETB.new(rs, rt, rn.first, 0, 1)
    end

    def ldseth rs, rt, rn
      a LDSETH.new(rs, rt, rn.first, 0, 0)
    end

    def ldsetah rs, rt, rn
      a LDSETH.new(rs, rt, rn.first, 1, 0)
    end

    def ldsetalh rs, rt, rn
      a LDSETH.new(rs, rt, rn.first, 1, 1)
    end

    def ldsetlh rs, rt, rn
      a LDSETH.new(rs, rt, rn.first, 0, 1)
    end

    def ldsmax rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMAX.new(rs, rt, rn.first, size, 0, 0)
    end

    def ldsmaxa rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMAX.new(rs, rt, rn.first, size, 1, 0)
    end

    def ldsmaxal rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMAX.new(rs, rt, rn.first, size, 1, 1)
    end

    def ldsmaxl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMAX.new(rs, rt, rn.first, size, 0, 1)
    end

    def ldsmaxab rs, rt, rn
      a LDSMAXB.new(rs, rt, rn.first, 1, 0)
    end

    def ldsmaxalb rs, rt, rn
      a LDSMAXB.new(rs, rt, rn.first, 1, 1)
    end

    def ldsmaxb rs, rt, rn
      a LDSMAXB.new(rs, rt, rn.first, 0, 0)
    end

    def ldsmaxlb rs, rt, rn
      a LDSMAXB.new(rs, rt, rn.first, 0, 1)
    end

    def ldsmaxah rs, rt, rn
      a LDSMAXH.new(rs, rt, rn.first, 1, 0)
    end

    def ldsmaxalh rs, rt, rn
      a LDSMAXH.new(rs, rt, rn.first, 1, 1)
    end

    def ldsmaxh rs, rt, rn
      a LDSMAXH.new(rs, rt, rn.first, 0, 0)
    end

    def ldsmaxlh rs, rt, rn
      a LDSMAXH.new(rs, rt, rn.first, 0, 1)
    end

    def ldsmin rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMIN.new(rs, rt, rn.first, size, 0, 0)
    end

    def ldsmina rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMIN.new(rs, rt, rn.first, size, 1, 0)
    end

    def ldsminal rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMIN.new(rs, rt, rn.first, size, 1, 1)
    end

    def ldsminl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      a LDSMIN.new(rs, rt, rn.first, size, 0, 1)
    end

    def ldsminb rs, rt, rn
      a LDSMINB.new(rs, rt, rn.first, 0, 0)
    end

    def ldsminab rs, rt, rn
      a LDSMINB.new(rs, rt, rn.first, 1, 0)
    end

    def ldsminalb rs, rt, rn
      a LDSMINB.new(rs, rt, rn.first, 1, 1)
    end

    def ldsminlb rs, rt, rn
      a LDSMINB.new(rs, rt, rn.first, 0, 1)
    end

    def ldsminh rs, rt, rn
      a LDSMINH.new(rs, rt, rn.first, 0, 0)
    end

    def ldsminah rs, rt, rn
      a LDSMINH.new(rs, rt, rn.first, 1, 0)
    end

    def ldsminalh rs, rt, rn
      a LDSMINH.new(rs, rt, rn.first, 1, 1)
    end

    def ldsminlh rs, rt, rn
      a LDSMINH.new(rs, rt, rn.first, 0, 1)
    end

    def ldtr rt, rn
      size = rt.x? ? 0b11 : 0b10
      a LDTR.new(rt, rn.first, rn[1] || 0, size)
    end

    def ldtrb rt, rn
      a LDTRB.new(rt, rn.first, rn[1] || 0)
    end

    def ldtrh rt, rn
      a LDTRH.new(rt, rn.first, rn[1] || 0)
    end

    def ldtrsb rt, rn
      opc = rt.x? ? 0b10 : 0b11
      a LDTRSB.new(rt, rn.first, rn[1] || 0, opc)
    end

    def ldtrsh rt, rn
      opc = rt.x? ? 0b10 : 0b11
      a LDTRSH.new(rt, rn.first, rn[1] || 0, opc)
    end

    def ldtrsw rt, rn
      a LDTRSW.new(rt, rn.first, rn[1] || 0)
    end

    def ldumax rs, rt, rn
      size = rt.x? ? 0b11 : 0b10
      a LDUMAX.new(rs, rt, rn.first, size, 0, 0)
    end

    def ldumaxa rs, rt, rn
      size = rt.x? ? 0b11 : 0b10
      a LDUMAX.new(rs, rt, rn.first, size, 1, 0)
    end

    def ldumaxal rs, rt, rn
      size = rt.x? ? 0b11 : 0b10
      a LDUMAX.new(rs, rt, rn.first, size, 1, 1)
    end

    def ldumaxl rs, rt, rn
      size = rt.x? ? 0b11 : 0b10
      a LDUMAX.new(rs, rt, rn.first, size, 0, 1)
    end

    def ldumaxab rs, rt, rn
      a LDUMAXB.new(rs, rt, rn.first, 1, 0)
    end

    def ldumaxalb rs, rt, rn
      a LDUMAXB.new(rs, rt, rn.first, 1, 1)
    end

    def ldumaxb rs, rt, rn
      a LDUMAXB.new(rs, rt, rn.first, 0, 0)
    end

    def ldumaxlb rs, rt, rn
      a LDUMAXB.new(rs, rt, rn.first, 0, 1)
    end

    def ldumaxah rs, rt, rn
      a LDUMAXH.new(rs, rt, rn.first, 1, 0)
    end

    def ldumaxalh rs, rt, rn
      a LDUMAXH.new(rs, rt, rn.first, 1, 1)
    end

    def ldumaxh rs, rt, rn
      a LDUMAXH.new(rs, rt, rn.first, 0, 0)
    end

    def ldumaxlh rs, rt, rn
      a LDUMAXH.new(rs, rt, rn.first, 0, 1)
    end

    def ldumin rs, rt, rn
      a LDUMIN.new(rs, rt, rn.first, rs.sizeb, 0, 0)
    end

    def ldumina rs, rt, rn
      a LDUMIN.new(rs, rt, rn.first, rs.sizeb, 1, 0)
    end

    def lduminal rs, rt, rn
      a LDUMIN.new(rs, rt, rn.first, rs.sizeb, 1, 1)
    end

    def lduminl rs, rt, rn
      a LDUMIN.new(rs, rt, rn.first, rs.sizeb, 0, 1)
    end

    def lduminab rs, rt, rn
      a LDUMINB.new(rs, rt, rn.first, 1, 0)
    end

    def lduminalb rs, rt, rn
      a LDUMINB.new(rs, rt, rn.first, 1, 1)
    end

    def lduminb rs, rt, rn
      a LDUMINB.new(rs, rt, rn.first, 0, 0)
    end

    def lduminlb rs, rt, rn
      a LDUMINB.new(rs, rt, rn.first, 0, 1)
    end

    def lduminah rs, rt, rn
      a LDUMINH.new(rs, rt, rn.first, 1, 0)
    end

    def lduminalh rs, rt, rn
      a LDUMINH.new(rs, rt, rn.first, 1, 1)
    end

    def lduminh rs, rt, rn
      a LDUMINH.new(rs, rt, rn.first, 0, 0)
    end

    def lduminlh rs, rt, rn
      a LDUMINH.new(rs, rt, rn.first, 0, 1)
    end

    def ldursb rt, rn
      a LDURSB.new(rt, rn.first, rn[1] || 0, rt.opc)
    end

    def ldursh rt, rn
      a LDURSH.new(rt, rn.first, rn[1] || 0, rt.opc)
    end

    def ldursw rt, rn
      a LDURSW.new(rt, rn.first, rn[1] || 0)
    end

    def ldxp rt, rt2, rn
      a LDXP.new(rt, rt2, rn.first, rt.sf)
    end

    def ldur rt, rn
      if rt.x?
        a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b11)
      else
        a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b10)
      end
    end

    def ldurb rt, rn
      a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b00)
    end

    def ldurh rt, rn
      a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b01)
    end

    def ldxr rt, rn
      if rt.x?
        a LDXR.new(rt, rn.first, 0b11)
      else
        a LDXR.new(rt, rn.first, 0b10)
      end
    end

    def ldxrb rt, rn
      a LDXR.new(rt, rn.first, 0b00)
    end

    def ldxrh rt, rn
      a LDXR.new(rt, rn.first, 0b01)
    end

    def lsl rd, rn, rm
      if rm.integer?
        if rd.x?
          ubfm rd, rn, -rm % 64, 63 - rm
        else
          ubfm rd, rn, -rm % 32, 31 - rm
        end
      else
        lslv rd, rn, rm
      end
    end

    def lslv rd, rn, rm
      a LSLV.new(rd, rn, rm)
    end

    def lsr rd, rn, rm
      if rm.integer?
        if rd.x?
          ubfm rd, rn, rm, 63
        else
          ubfm rd, rn, rm, 31
        end
      else
        lsrv rd, rn, rm
      end
    end

    def lsrv rd, rn, rm
      a LSRV.new(rd, rn, rm)
    end

    def madd rd, rn, rm, ra
      a MADD.new(rd, rn, rm, ra)
    end

    def mneg rd, rn, rm
      msub rd, rn, rm, rd.x? ? XZR : WZR
    end

    def mov rd, rm
      if rm.integer?
        if rm < 0
          rm = ~rm
          if rm < 65536 || rm % 65536 == 0
            movn(rd, rm)
          else
            orr(rd, rd.x? ? XZR : WZR, ~rm)
          end
        else
          if rm < 65536 || rm % 65536 == 0
            movz(rd, rm)
          else
            orr(rd, rd.x? ? XZR : WZR, rm)
          end
        end
      else
        if rd.sp? || rm.sp?
          add rd, rm, 0
        else
          orr(rd, rd.x? ? XZR : WZR, rm)
        end
      end
    end

    def movn rd, imm, lsl: 0
      lsl /= 16
      while imm > 65535
        lsl += 1
        imm >>= 16
      end
      a MOVN.new(rd, imm, lsl)
    end

    def movz reg, imm, lsl: 0
      lsl /= 16
      while imm > 65535
        lsl += 1
        imm >>= 16
      end
      @insns = @insns << MOVZ.new(reg, imm, lsl)
    end

    def movk reg, imm, lsl: 0
      @insns = @insns << MOVK.new(reg, imm, lsl / 16)
    end

    def mrs rt, reg
      a MRS.new(reg.op0, reg.op1, reg.CRn, reg.CRm, reg.op2, rt)
    end

    def msr reg, rt
      if rt.integer?
        raise NotImplementedError
      else
        a MSR_reg.new(reg.op0, reg.op1, reg.CRn, reg.CRm, reg.op2, rt)
      end
    end

    def msub rd, rn, rm, ra
      a MSUB.new(rd, rn, rm, ra)
    end

    def mul rd, rn, rm
      madd rd, rn, rm, rd.x? ? XZR : WZR
    end

    def mvn rd, rm, option = nil, shift: :lsl, amount: 0
      orn rd, rd.zr, rm, option, shift: shift, amount: amount
    end

    def neg rd, rm, option = nil, extend: nil, amount: 0, lsl: 0, shift: :lsl
      sub rd, rd.zr, rm, option, extend: extend, amount: amount, lsl: lsl, shift: shift
    end

    def negs rd, rm, option = nil, shift: :lsl, amount: 0
      subs rd, rd.zr, rm, option, shift: shift, amount: amount
    end

    def ngc rd, rm
      sbc rd, rd.zr, rm
    end

    def ngcs rd, rm
      sbcs rd, rd.zr, rm
    end

    def nop
      a NOP.new
    end

    def orn rd, rn, rm, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)

      a ORN_log_shift.new(rd, rn, rm, shift, amount)
    end

    def orr rd, rn, rm, option = nil, shift: :lsl, amount: 0
      if rm.integer?
        encoding = Utils.encode_mask(rm, rd.size)
        a ORR_log_imm.new(rd, rn, encoding.n, encoding.immr, encoding.imms)
      else
        if option
          shift = option.name
          amount = option.amount
        end

        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)

        a ORR_log_shift.new(rd, rn, rm, shift, amount)
      end
    end

    def pacda xd, xn
      a PACDA.new(xd, xn, 0)
    end

    def pacdza xd
      a PACDA.new(xd, xd.zr, 1)
    end

    def pacdb xd, xn
      a PACDB.new(xd, xn, 0)
    end

    def pacdzb xd
      a PACDB.new(xd, xd.zr, 1)
    end

    def pacga xd, xn, xm
      a PACGA.new(xd, xn, xm)
    end

    def pacia xd, xn
      a PACIA.new(xd, xn, 0)
    end

    def paciza xd
      a PACIA.new(xd, xd.zr, 1)
    end

    def pacia1716
      a PACIA2.new(0b0001, 0b000)
    end

    def paciasp
      a PACIA2.new(0b0011, 0b001)
    end

    def paciaz
      a PACIA2.new(0b0011, 0b000)
    end

    def pacib xd, xn
      a PACIB.new(xd, xn, 0)
    end

    def pacizb xd
      a PACIB.new(xd, xd.zr, 1)
    end

    def pacib1716
      a PACIA2.new(0b0001, 0b010)
    end

    def pacibsp
      a PACIA2.new(0b0011, 0b011)
    end

    def pacibz
      a PACIA2.new(0b0011, 0b010)
    end

    def prfm rt, xn
      if rt.is_a?(Symbol)
        rt = Utils.prfop(rt)
      end

      if xn.is_a?(Array)
        xn, rm, option = *xn
        rm ||= 0
        if rm.integer?
          a PRFM_imm.new(rt, xn, rm / 8)
        else
          shift = case option.name
                  when :uxtw then 0b010
                  when :lsl  then 0b011
                  when :sxtw then 0b110
                  when :sxtx then 0b111
                  else
                    raise
                  end
          a PRFM_reg.new(rt, xn, rm, shift, option.amount / 3)
        end
      else
        a PRFM_lit.new(rt, xn)
      end
    end

    def prfum rt, rn
      if rt.is_a?(Symbol)
        rt = Utils.prfop(rt)
      end
      a PRFUM.new(rt, rn.first, rn[1] || 0)
    end

    def psb _
      a PSB.new
    end

    def pssbb
      dsb 4
    end

    def rbit rd, rn
      a RBIT_int.new(rd, rn, rd.sf)
    end

    def ret reg = X30
      @insns = @insns << RET.new(reg)
    end

    def retaa
      a RETA.new(0)
    end

    def retab
      a RETA.new(1)
    end

    def rev rd, rn
      a REV.new(rd, rn, rd.sf, rd.opc2)
    end

    def rev16 rd, rn
      a REV.new(rd, rn, rd.sf, 0b01)
    end

    def rev32 rd, rn
      a REV.new(rd, rn, rd.sf, 0b10)
    end

    alias :rev64 :rev

    def rmif rn, shift, mask
      a RMIF.new(rn, shift, mask)
    end

    def ror rd, rs, shift
      if shift.integer?
        extr rd, rs, rs, shift
      else
        rorv rd, rs, shift
      end
    end

    def rorv rd, rn, rm
      a RORV.new(rd, rn, rm, rd.sf)
    end

    def sb
      a SB.new
    end

    def sbc rd, rn, rm
      a SBC.new(rd, rn, rm, rd.sf)
    end

    def sbcs rd, rn, rm
      a SBCS.new(rd, rn, rm, rd.sf)
    end

    def sbfiz rd, rn, lsb, width
      sbfm rd, rn, -lsb % rd.size, width - 1
    end

    def sbfm d, n, immr, imms
      @insns = @insns << SBFM.new(d, n, immr, imms)
    end

    def sbfx rd, rn, lsb, width
      sbfm rd, rn, lsb, lsb + width - 1
    end

    def sdiv rd, rn, rm
      a SDIV.new(rd, rn, rm, rd.sf)
    end

    def setf8 rn
      a SETF.new(rn, 0)
    end

    def setf16 rn
      a SETF.new(rn, 1)
    end

    def sev
      a SEV.new
    end

    def sevl
      a SEVL.new
    end

    def smaddl xd, wn, wm, xa
      a SMADDL.new(xd, wn, wm, xa)
    end

    def smc imm
      a SMC.new(imm)
    end

    def smnegl rd, rn, rm
      smsubl rd, rn, rm, XZR
    end

    def smsubl rd, rn, rm, ra
      a SMSUBL.new(rd, rn, rm, ra)
    end

    def smulh rd, rn, rm
      a SMULH.new(rd, rn, rm)
    end

    def smull rd, rn, rm
      smaddl rd, rn, rm, XZR
    end

    def ssbb
      dsb 0
    end

    def st2g rt, rn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a ST2G.new(rt, rn.first, (rn[1] || 0) / 16, 0b11)
        else
          # Post index
          a ST2G.new(rt, rn.first, (imm || 0) / 16, 0b01)
        end
      else
        # Signed offset
        a ST2G.new(rt, rn.first, (rn[1] || 0) / 16, 0b10)
      end
    end

    def st64b rt, rn
      a ST64B.new(rt, rn.first)
    end

    def stxp rs, rt1, rt2, rn
      @insns = @insns << STXP.new(rs, rt1, rt2, rn.first)
    end

    def stxr rs, rt, rn
      size = rt.x? ? 0b11 : 0b10
      @insns = @insns << STXR.new(rs, rt, rn.first, size)
    end

    def stxrb rs, rt, rn
      @insns = @insns << STXRB.new(rs, rt, rn.first)
    end

    def stxrh rs, rt, rn
      @insns = @insns << STXRH.new(rs, rt, rn.first)
    end

    def stzgm rt, rn
      @insns = @insns << STZGM.new(rt, rn.first)
    end

    def subs d, n, m, option = nil, extend: nil, amount: 0, lsl: 0, shift: :lsl
      if n.sp? && !m.integer?
        if n.x?
          extend ||= :uxtx
        else
          extend ||= :uxtw
        end
      end

      if option
        if option.extend?
          extend = option.name
          amount = option.amount
        else
          if m.integer?
            lsl = option.amount
          else
            shift = option.name
            amount = option.amount
          end
        end
      end

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
        @insns = @insns << SUBS_addsub_ext.new(d, n, m, extend, amount)
      else
        if m.integer?
          @insns = @insns << SUBS_addsub_imm.new(d, n, m, lsl / 12)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          @insns = @insns << SUBS_addsub_shift.new(d, n, m, shift, amount)
        end
      end
    end

    def sub d, n, m, option = nil, extend: nil, amount: 0, lsl: 0, shift: :lsl
      if (d.sp? || n.sp?) && !m.integer?
        if n.x?
          extend ||= :uxtx
        else
          extend ||= :uxtw
        end
      end

      if option
        if option.extend?
          extend = option.name
          amount = option.amount
        else
          if m.integer?
            lsl = option.amount
          else
            shift = option.name
            amount = option.amount
          end
        end
      end

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
        @insns = @insns << SUB_addsub_ext.new(d, n, m, extend, amount)
      else
        if m.integer?
          @insns = @insns << SUB_addsub_imm.new(d, n, m, lsl / 12)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          @insns = @insns << SUB_addsub_shift.new(d, n, m, shift, amount)
        end
      end
    end

    def subg xd, xn, uimm6, uimm4
      raise NotImplementedError unless xd.x?
      @insns = @insns << SUBG.new(xd, xn, uimm6, uimm4)
    end

    def subp xd, xn, xm
      raise NotImplementedError unless xd.x?
      @insns = @insns << SUBP.new(xd, xn, xm)
    end

    def subps xd, xn, xm
      raise NotImplementedError unless xd.x?
      @insns = @insns << SUBPS.new(xd, xn, xm)
    end

    def svc imm
      @insns = @insns << SVC.new(imm)
    end

    def swp rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << SWP.new(rs, rt, rn.first, size, 0, 0)
    end

    def swpal rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << SWP.new(rs, rt, rn.first, size, 1, 1)
    end

    def swpl rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << SWP.new(rs, rt, rn.first, size, 0, 1)
    end

    def swpa rs, rt, rn
      size = rs.x? ? 0b11 : 0b10
      @insns = @insns << SWP.new(rs, rt, rn.first, size, 1, 0)
    end

    def swpab rs, rt, rn
      @insns = @insns << SWPB.new(rs, rt, rn.first, 1, 0)
    end

    def swpalb rs, rt, rn
      @insns = @insns << SWPB.new(rs, rt, rn.first, 1, 1)
    end

    def swpb rs, rt, rn
      @insns = @insns << SWPB.new(rs, rt, rn.first, 0, 0)
    end

    def swplb rs, rt, rn
      @insns = @insns << SWPB.new(rs, rt, rn.first, 0, 1)
    end

    def swpah rs, rt, rn
      @insns = @insns << SWPH.new(rs, rt, rn.first, 1, 0)
    end

    def swpalh rs, rt, rn
      @insns = @insns << SWPH.new(rs, rt, rn.first, 1, 1)
    end

    def swph rs, rt, rn
      @insns = @insns << SWPH.new(rs, rt, rn.first, 0, 0)
    end

    def swplh rs, rt, rn
      @insns = @insns << SWPH.new(rs, rt, rn.first, 0, 1)
    end

    def sxtb rd, rn
      sbfm rd, rn, 0, 7
    end

    def sxth rd, rn
      sbfm rd, rn, 0, 15
    end

    def sxtw rd, rn
      sbfm rd, rn, 0, 31
    end

    def sys op1, cn, cm, op2, xt = XZR
      @insns = @insns << SYS.new(op1, cn, cm, op2, xt)
    end

    def sysl xt, op1, cn, cm, op2
      @insns = @insns << SYSL.new(xt, op1, cn, cm, op2)
    end

    def tbnz rt, imm, label
      @insns = @insns << TBNZ.new(rt, imm, label)
    end

    def tbz rt, imm, label
      @insns = @insns << TBZ.new(rt, imm, label)
    end

    def tlbi tlbi_op, xt = XZR
      op1, crm, op2 = Utils.tlbi_op(tlbi_op)
      sys op1, Names::C8, crm, op2, xt
    end

    def tsb _
      @insns = @insns << TSB.new
    end

    def tst rn, rm, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      zr = rn.x? ? XZR : WZR
      ands zr, rn, rm, shift: shift, amount: amount
    end

    def ubfm rd, rn, immr, imms
      @insns = @insns << UBFM.new(rd, rn, immr, imms)
    end

    def ubfiz rd, rn, lsb, width
      ubfm rd, rn, (-lsb) % rd.size, width - 1
    end

    def ubfx rd, rn, lsb, width
      ubfm rd, rn, lsb, lsb + width - 1
    end

    def udf imm
      @insns = @insns << UDF_perm_undef.new(imm)
    end

    def udiv rd, rn, rm
      @insns = @insns << UDIV.new(rd, rn, rm)
    end

    def umaddl xd, wn, wm, xa
      @insns = @insns << UMADDL.new(xd, wn, wm, xa)
    end

    def umnegl xd, wn, wm
      umsubl xd, wn, wm, XZR
    end

    def umsubl xd, wn, wm, xa
      @insns = @insns << UMSUBL.new(xd, wn, wm, xa)
    end

    def umulh rd, rn, rm
      @insns = @insns << UMULH.new(rd, rn, rm)
    end

    def umull xd, wn, wm
      umaddl xd, wn, wm, XZR
    end

    def uxtb rd, rn
      ubfm rd, rn, 0, 7
    end

    def uxth rd, rn
      ubfm rd, rn, 0, 15
    end

    def wfe
      @insns = @insns << WFE.new
    end

    def wfet rd
      @insns = @insns << WFET.new(rd)
    end

    def wfi
      @insns = @insns << WFI.new
    end

    def wfit rd
      @insns = @insns << WFIT.new(rd)
    end

    def xaflag
      @insns = @insns << XAFLAG.new
    end

    def xpacd rd
      @insns = @insns << XPAC.new(rd, 1)
    end

    def xpaci rd
      @insns = @insns << XPAC.new(rd, 0)
    end

    def xpaclri
      @insns = @insns << XPACLRI.new
    end

    def yield
      @insns = @insns << YIELD.new
    end

    def write_to io
      io.write @insns.map(&:encode).pack("L<*")
    end

    private

    def a insn
      @insns = @insns << insn
    end
  end
end
