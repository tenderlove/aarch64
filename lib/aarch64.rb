# frozen_string_literal: true

require "aarch64/instructions"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64/utils"

module AArch64
  module Registers
    class Register < ClassGen.pos(:to_i, :sp, :zr)
      alias sp? sp
      alias zr? zr
      def integer?; false; end
      def register?; true; end
    end

    class XRegister < Register
      def x?; true; end
      def zr; XZR; end
      def size; 64; end
      def sf; 1; end
      def sizeb; 0b11; end
      def sz; 0b1; end
      def opc; 0b10; end
      def opc2; 0b11; end
      def opc3; 0b10; end
      def name; "X#{to_i}"; end
    end

    class WRegister < Register
      def x?; false; end
      def zr; WZR; end
      def size; 32; end
      def sf; 0; end
      def sizeb; 0b10; end
      def sz; 0b0; end
      def opc; 0b11; end
      def opc2; 0b10; end
      def opc3; 0b00; end
      def name; "W#{to_i}"; end
    end

    31.times { |i|
      const_set(:"X#{i}", XRegister.new(i, false, false))
      const_set(:"W#{i}", WRegister.new(i, false, false))
    }

    SP = XRegister.new(31, true, false)
    WSP = WRegister.new(31, true, false)
    XZR = XRegister.new(31, false, true)
    WZR = WRegister.new(31, false, true)

    module Methods
      str = 31.times.map { |i|
        "def x#{i}; ::AArch64::Registers::X#{i}; end; " +
          "def w#{i}; ::AArch64::Registers::W#{i}; end"
      }.join("; ")

      module_eval str, __FILE__, __LINE__

      def sp; SP; end
      def wsp; WSP; end
      def xzr; XZR; end
      def wzr; WZR; end
    end
  end

  module Conditions
    module Methods
      module_eval Utils::COND_TABLE.keys.map { |key|
        "def #{key.downcase}; #{key.dump}; end"
      }.join("\n")
    end
  end

  module Names
    0x10.times.map { |i| const_set(:"C#{i}", i) }

    module Methods
      module_eval 0x10.times.map { |i|
        "def c#{i}; #{i}; end"
      }.join("\n")
    end
  end

  module Extends
    class Extend < ClassGen.pos(:amount, :type, :name)
      def extend?; true; end
      def shift?; false; end
    end

    module Methods
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
  end

  module Shifts
    class Shift < ClassGen.pos(:amount, :type, :name)
      def extend?; false; end
      def shift?; true; end
    end

    module Methods
      module_eval [:lsl, :lsr, :asr, :ror].map.with_index { |n, i|
        "def #{n}(amount = 0); Shift.new(amount, #{i}, :#{n}); end"
      }.join("\n")
    end
  end

  class DSL
    include AArch64::Registers
    include AArch64::Registers::Methods
    include AArch64::Conditions::Methods
    include AArch64::Extends::Methods
    include AArch64::Shifts::Methods
    include AArch64::Names::Methods
    include AArch64::SystemRegisters
  end

  class Assembler
    include Instructions
    include Registers

    class Immediate
      def initialize offset
        @offset = offset
        freeze
      end

      def unwrap_label
        @offset
      end
      def immediate?; true; end
    end

    class Label
      attr_reader :offset

      def initialize name
        @name   = name
        @offset = nil
      end

      def set_offset offset
        @offset = offset
        freeze
      end

      def unwrap_label
        to_i
      end

      def to_i
        @offset
      end

      def immediate?; false; end
      def integer?; false; end
    end

    def initialize
      @insns = []
    end

    # Creates a DSL object so you can write prettier assembly.  For example:
    #
    #   asm = AArch64::Assembler.new
    #   asm.pretty do
    #     asm.movz x0, 42
    #     asm.ret
    #   end
    def pretty &block
      DSL.new.instance_eval(&block)
    end

    # Makes a new label with +name+.  Place the label using the +put_label+
    # method.
    def make_label name
      Label.new name
    end

    # Puts the label at the current position.  Labels can only be placed once.
    def put_label label
      label.set_offset(@insns.length)
      self
    end

    def adc d, n, m
      a ADC.new(d, n, m, d.sf)
    end

    def adcs d, n, m
      a ADCS.new(d, n, m, d.sf)
    end

    def add d, n, m, extend: nil, amount: 0, lsl: 0, shift: :lsl
      if extend
        extend = case extend
                 when :uxtb then 0b000
                 when :uxth then 0b001
                 when :uxtw then 0b010
                 when :lsl  then 0b010
                 when :uxtx then 0b011
                 when :sxtb then 0b100
                 when :sxth then 0b101
                 when :sxtw then 0b110
                 when :sxtx then 0b111
                 else
                   raise "Unknown extend #{extend}"
                 end

        a ADD_addsub_ext.new(d, n, m, extend, amount, d.sf)
      else
        if m.integer?
          # add immediate
          a ADD_addsub_imm.new(d, n, m, (lsl || 0) / 12, d.sf)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          a ADD_addsub_shift.new(d, n, m, shift, amount, d.sf)
        end
      end
    end

    def addg xd, xn, imm6, imm4
      a ADDG.new(xd, xn, imm6, imm4)
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
                 when :lsl then 0b010
                 when :uxtx then 0b011
                 when :sxtb then 0b100
                 when :sxth then 0b101
                 when :sxtw then 0b110
                 when :sxtx then 0b111
                 else
                   raise "Unknown extend #{extend}"
                 end
        a ADDS_addsub_ext.new(d, n, m, extend, amount, d.sf)
      else
        if m.integer?
          a ADDS_addsub_imm.new(d, n, m, lsl / 12, d.sf)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          a ADDS_addsub_shift.new(d, n, m, shift, amount, d.sf)
        end
      end
    end

    def adr xd, label
      label = Immediate.new(label) if label.integer?
      a ADR.new(xd, label)
    end

    def adrp xd, label
      label = Immediate.new(label) if label.integer?
      a ADRP.new(xd, label)
    end

    def and d, n, m, shift: :lsl, amount: 0
      if m.integer?
        enc = Utils.encode_mask(m, d.size) || raise("Can't encode mask #{m}")
        a AND_log_imm.new(d, n, enc.immr, enc.imms, enc.n, d.sf)
      else
        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
        a AND_log_shift.new(d, n, m, shift, amount, d.sf)
      end
    end

    def ands d, n, m, shift: :lsl, amount: 0
      if m.integer?
        enc = Utils.encode_mask(m, d.size) || raise("Can't encode mask #{m}")
        a ANDS_log_imm.new(d, n, enc.immr, enc.imms, enc.n, d.sf)
      else
        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
        a ANDS_log_shift.new(d, n, m, shift, amount, d.sf)
      end
    end

    def asr d, n, m
      if m.integer?
        sbfm d, n, m, d.size - 1
      else
        asrv d, n, m
      end
    end

    def asrv d, n, m
      a ASRV.new(d, n, m, d.sf)
    end

    def at at_op, t
      op = Utils.at_op(at_op)
      sys op[:op1], Names::C7, op[:crm], op[:op2], t
    end

    def autda d, n
      if n.integer?
        a AUTDA.new(1, d, n)
      else
        a AUTDA.new(0, d, n)
      end
    end

    def autdza d
      a AUTDA.new(1, d, 0b11111)
    end

    def autdb d, n
      if n.integer?
        a AUTDB.new(1, d, n)
      else
        a AUTDB.new(0, d, n)
      end
    end

    def autdzb d
      a AUTDB.new(1, d, 0b11111)
    end

    def autia d, n
      if n.integer?
        a AUTIA.new(1, d, n)
      else
        a AUTIA.new(0, d, n)
      end
    end

    def autiza d
      a AUTIA.new(1, d, 0b11111)
    end

    def autia1716
      a HINT.new(0b0001, 0b100)
    end

    def autiasp
      a HINT.new(0b0011, 0b101)
    end

    def autiaz
      a HINT.new(0b0011, 0b100)
    end

    def autib d, n
      if n.integer?
        a AUTIB.new(1, d, n)
      else
        a AUTIB.new(0, d, n)
      end
    end

    def autizb d
      a AUTIB.new(1, d, 0b11111)
    end

    def autib1716
      a HINT.new(0b0001, 0b110)
    end

    def autibsp
      a HINT.new(0b0011, 0b111)
    end

    def autibz
      a HINT.new(0b0011, 0b110)
    end

    def axflag
      a AXFLAG.new
    end

    def b label, cond: nil
      if label.integer?
        label = wrap_offset_with_label label
      end

      if cond
        a B_cond.new(Utils.cond2bin(cond), label)
      else
        a B_uncond.new(label)
      end
    end

    def bc label, cond:
      if label.integer?
        label = wrap_offset_with_label label
      end
      a BC_cond.new(Utils.cond2bin(cond), label)
    end

    def bfc rd, lsb, width
      bfm(rd, rd.zr, -lsb % rd.size, width - 1)
    end

    def bfi rd, rn, lsb, width
      bfm(rd, rn, -lsb % rd.size, width - 1)
    end

    def bfm d, n, immr, imms
      a BFM.new(d, n, immr, imms, d.sf)
    end

    def bfxil d, n, lsb, width
      bfm d, n, lsb, lsb + width - 1
    end

    def bic d, n, m, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
      a BIC_log_shift.new(d, n, m, shift, amount, d.sf)
    end

    def bics d, n, m, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
      a BICS.new(d, n, m, shift, amount, d.sf)
    end

    def bl label
      if label.integer?
        label = wrap_offset_with_label label
      end

      a BL.new(label)
    end

    def blr n
      a BLR.new(n)
    end

    def blraaz rn
      a BLRA.new(rn, 0b11111, 0, 0)
    end

    def blraa rn, rm
      a BLRA.new(rn, rm, 1, 0)
    end

    def blrabz rn
      a BLRA.new(rn, 0b11111, 0, 1)
    end

    def blrab rn, rm
      a BLRA.new(rn, rm, 1, 1)
    end

    def br rn
      a BR.new(rn)
    end

    def braaz rn
      a BRA.new(rn, 0b11111, 0, 0)
    end

    def braa rn, rm
      a BRA.new(rn, rm, 1, 0)
    end

    def brabz rn
      a BRA.new(rn, 0b11111, 0, 1)
    end

    def brab rn, rm
      a BRA.new(rn, rm, 1, 1)
    end

    def brk imm
      a BRK.new(imm)
    end

    def bti target
      target = [:c, :j, :jc].index(target) || raise(NotImplementedError)
      a BTI.new(target)
    end

    def cas s, t, n_list
      a CAS.new(s, t, n_list[0], 0, 0, s.sf)
    end

    def casa s, t, n_list
      a CAS.new(s, t, n_list[0], 1, 0, s.sf)
    end

    def casl s, t, n_list
      a CAS.new(s, t, n_list[0], 0, 1, s.sf)
    end

    def casal s, t, n_list
      a CAS.new(s, t, n_list[0], 1, 1, s.sf)
    end

    def casb rs, rt, rn_list
      a CASB.new(rs, rt, rn_list[0], 0, 0)
    end

    def casalb rs, rt, rn_list
      a CASB.new(rs, rt, rn_list[0], 1, 1)
    end

    def caslb rs, rt, rn_list
      a CASB.new(rs, rt, rn_list[0], 0, 1)
    end

    def casah rs, rt, rn_list
      a CASH.new(rs, rt, rn_list[0], 1, 0)
    end

    def casalh rs, rt, rn_list
      a CASH.new(rs, rt, rn_list[0], 1, 1)
    end

    def cash rs, rt, rn_list
      a CASH.new(rs, rt, rn_list[0], 0, 0)
    end

    def caslh rs, rt, rn_list
      a CASH.new(rs, rt, rn_list[0], 0, 1)
    end

    def casp rs, rs1, rt, rt1, rn_list
      a CASP.new(rs, rt, rn_list[0], 0, 0, rs.sf)
    end

    def caspa rs, rs1, rt, rt1, rn_list
      a CASP.new(rs, rt, rn_list[0], 1, 0, rs.sf)
    end

    def caspl rs, rs1, rt, rt1, rn_list
      a CASP.new(rs, rt, rn_list[0], 0, 1, rs.sf)
    end

    def caspal rs, rs1, rt, rt1, rn_list
      a CASP.new(rs, rt, rn_list[0], 1, 1, rs.sf)
    end

    def cbnz rt, label
      if label.integer?
        label = wrap_offset_with_label label
      end
      a CBNZ.new(rt, label, rt.sf)
    end

    def cbz rt, label
      if label.integer?
        label = wrap_offset_with_label label
      end
      a CBZ.new(rt, label, rt.sf)
    end

    def ccmn rn, rm, nzcv, cond
      cond = Utils.cond2bin(cond)

      if rm.integer?
        a CCMN_imm.new(rn, rm, nzcv, cond, rn.sf)
      else
        a CCMN_reg.new(rn, rm, nzcv, cond, rn.sf)
      end
    end

    def ccmp rn, rm, nzcv, cond
      cond = Utils.cond2bin(cond)

      if rm.integer?
        a CCMP_imm.new(rn, rm, nzcv, cond, rn.sf)
      else
        a CCMP_reg.new(rn, rm, nzcv, cond, rn.sf)
      end
    end

    def cfinv
      a CFINV.new
    end

    def cfp_rcfx rt
      sys 3, Names::C7, Names::C3, 4, rt
    end

    def cinc rd, rn, cond
      a CSINC.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1, rd.sf)
    end

    def cset rd, cond
      a CSINC.new(rd, WZR, WZR, Utils.cond2bin(cond) ^ 1, rd.sf)
    end

    def csetm rd, cond
      reg = rd.zr
      a CSINV.new(rd, reg, reg, Utils.cond2bin(cond) ^ 1, rd.sf)
    end

    def csinc rd, rn, rm, cond
      a CSINC.new(rd, rn, rm, Utils.cond2bin(cond), rd.sf)
    end

    def cinv rd, rn, cond
      a CSINV.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1, rd.sf)
    end

    def csinv rd, rn, rm, cond
      a CSINV.new(rd, rn, rm, Utils.cond2bin(cond), rd.sf)
    end

    def clrex imm = 15
      a CLREX.new(imm)
    end

    def cls rd, rn
      a CLS_int.new(rd, rn, rd.sf)
    end

    def clz rd, rn
      a CLZ_int.new(rd, rn, rd.sf)
    end

    def cmn rn, rm, option = nil, extend: nil, amount: 0, shift: :lsl, lsl: 0
      adds(rn.zr, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
    end

    def cmp rn, rm, option = nil, extend: nil, amount: 0, shift: :lsl, lsl: 0
      subs(rn.zr, rn, rm, option, extend: extend, amount: amount, shift: shift, lsl: lsl)
    end

    def cmpp xn, xm
      subps XZR, xn, xm
    end

    def cneg rd, rn, cond
      a CSNEG.new(rd, rn, rn, Utils.cond2bin(cond) ^ 1, rd.sf)
    end

    def cpp _, xn
      sys 3, Names::C7, Names::C3, 7, xn
    end

    def crc32b rd, rn, rm
      a CRC32.new(rd, rn, rm, 0x00, 0b0)
    end

    def crc32h rd, rn, rm
      a CRC32.new(rd, rn, rm, 0x01, 0b0)
    end

    def crc32w rd, rn, rm
      a CRC32.new(rd, rn, rm, 0x02, 0b0)
    end

    def crc32x rd, rn, rm
      a CRC32.new(rd, rn, rm, 0x03, 0b1)
    end

    def crc32cb rd, rn, rm
      a CRC32C.new(rd, rn, rm, 0x00, 0b0)
    end

    def crc32ch rd, rn, rm
      a CRC32C.new(rd, rn, rm, 0x01, 0b0)
    end

    def crc32cw rd, rn, rm
      a CRC32C.new(rd, rn, rm, 0x02, 0b0)
    end

    def crc32cx rd, rn, rm
      a CRC32C.new(rd, rn, rm, 0x03, 0b1)
    end

    def csdb
      a CSDB.new
    end

    def csel rd, rn, rm, cond
      a CSEL.new(rd, rn, rm, Utils.cond2bin(cond), rd.sf)
    end

    def csneg rd, rn, rm, cond
      a CSNEG.new(rd, rn, rm, Utils.cond2bin(cond), rd.sf)
    end

    def dc dc_op, xt
      op1, cm, op2 = Utils.dc_op(dc_op)
      sys op1, Names::C7, cm, op2, xt
    end

    def dcps1 imm = 0
      a DCPS.new(imm, 0x1)
    end

    def dcps2 imm = 0
      a DCPS.new(imm, 0x2)
    end

    def dcps3 imm = 0
      a DCPS.new(imm, 0x3)
    end

    def dgh
      a DGH.new
    end

    def dmb option
      if Numeric === option
        a DMB.new(option)
      else
        a DMB.new(Utils.dmb2imm(option))
      end
    end

    def drps
      a DRPS.new
    end

    def dsb option
      if Numeric === option
        a DSB.new(option)
      else
        a DSB.new(Utils.dmb2imm(option))
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
      a EON.new(d, n, m, shift, amount, d.sf)
    end

    def eor rd, rn, rm, options = nil, shift: :lsl, amount: 0
      if options
        shift = options.name
        amount = options.amount
      end

      if rm.integer?
        encoding = Utils.encode_mask(rm, rd.size)
        a EOR_log_imm.new(rd, rn, encoding.n, encoding.immr, encoding.imms, rd.sf)
      else
        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
        a EOR_log_shift.new(rd, rn, rm, shift, amount, rd.sf)
      end
    end

    def eret
      a ERET.new
    end

    def eretaa
      a ERETA.new(0)
    end

    def eretab
      a ERETA.new(1)
    end

    def esb
      a ESB.new
    end

    def extr rd, rn, rm, lsb
      a EXTR.new(rd, rn, rm, lsb, rd.sf)
    end

    def gmi rd, rn, rm
      a GMI.new(rd, rn, rm)
    end

    def hint imm
      a HINT.new(imm >> 3, imm & 0b111)
    end

    def hlt imm
      a HLT.new(imm)
    end

    def hvc imm
      a HVC.new(imm)
    end

    def ic op, xt = SP
      op1, crm, op2 = Utils.ic_op(op)
      sys op1, Names::C7, crm, op2, xt
    end

    def irg rd, rn, rm = XZR
      a IRG.new(rd, rn, rm)
    end

    def isb option = 0b1111
      a ISB.new(option)
    end

    def ld64b rt, rn
      a LD64B.new(rt, rn.first)
    end

    def ldadd rs, rt, rn
      a LDADD.new(rs, rt, rn.first, rs.opc2, 0, 0)
    end

    def ldadda rs, rt, rn
      a LDADD.new(rs, rt, rn.first, rs.opc2, 1, 0)
    end

    def ldaddal rs, rt, rn
      a LDADD.new(rs, rt, rn.first, rs.opc2, 1, 1)
    end

    def ldaddl rs, rt, rn
      a LDADD.new(rs, rt, rn.first, rs.opc2, 0, 1)
    end

    def ldaddab rs, rt, rn
      a LDADDB.new(rs, rt, rn.first, 1, 0)
    end

    def ldaddalb rs, rt, rn
      a LDADDB.new(rs, rt, rn.first, 1, 1)
    end

    def ldaddb rs, rt, rn
      a LDADDB.new(rs, rt, rn.first, 0, 0)
    end

    def ldaddlb rs, rt, rn
      a LDADDB.new(rs, rt, rn.first, 0, 1)
    end

    def ldaddah rs, rt, rn
      a LDADDH.new(rs, rt, rn.first, 1, 0)
    end

    def ldaddalh rs, rt, rn
      a LDADDH.new(rs, rt, rn.first, 1, 1)
    end

    def ldaddh rs, rt, rn
      a LDADDH.new(rs, rt, rn.first, 0, 0)
    end

    def ldaddlh rs, rt, rn
      a LDADDH.new(rs, rt, rn.first, 0, 1)
    end

    def ldapr rt, rn
      a LDAPR.new(rt, rn.first, rt.opc2)
    end

    def ldaprb rt, rn
      a LDAPRB.new(rt, rn.first)
    end

    def ldaprh rt, rn
      a LDAPRH.new(rt, rn.first)
    end

    def ldapur rt, rn
      a LDAPUR_gen.new(rt.opc2, 0b01, rt, rn.first, rn[1] || 0)
    end

    def ldapurb rt, rn
      a LDAPUR_gen.new(0b00, 0b01, rt, rn.first, rn[1] || 0)
    end

    def ldapurh rt, rn
      a LDAPUR_gen.new(0b01, 0b01, rt, rn.first, rn[1] || 0)
    end

    def ldapursb rt, rn
      a LDAPUR_gen.new(0b00, rt.opc, rt, rn.first, rn[1] || 0)
    end

    def ldapursh rt, rn
      a LDAPUR_gen.new(0b01, rt.opc, rt, rn.first, rn[1] || 0)
    end

    def ldapursw rt, rn
      a LDAPUR_gen.new(0b10, 0b10, rt, rn.first, rn[1] || 0)
    end

    def ldar rt, rn
      a LDAR.new(rt, rn.first, rt.opc2)
    end

    def ldarb rt, rn
      a LDAR.new(rt, rn.first, 0x00)
    end

    def ldarh rt, rn
      a LDAR.new(rt, rn.first, 0x01)
    end

    def ldaxp rt1, rt2, xn
      a LDAXP.new(rt1, rt2, xn.first, rt1.sf)
    end

    def ldaxr rt1, xn
      a LDAXR.new(rt1, xn.first, rt1.opc2)
    end

    def ldaxrb rt1, xn
      a LDAXR.new(rt1, xn.first, 0b00)
    end

    def ldaxrh rt1, xn
      a LDAXR.new(rt1, xn.first, 0b01)
    end

    def ldclr rs, rt, rn
      a LDCLR.new(rs, rt, rn.first, 0, 0, rs.opc2)
    end

    def ldclra rs, rt, rn
      a LDCLR.new(rs, rt, rn.first, 1, 0, rs.opc2)
    end

    def ldclral rs, rt, rn
      a LDCLR.new(rs, rt, rn.first, 1, 1, rs.opc2)
    end

    def ldclrl rs, rt, rn
      a LDCLR.new(rs, rt, rn.first, 0, 1, rs.opc2)
    end

    def ldclrab rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 1, 0, 0b00)
    end

    def ldclralb rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 1, 1, 0b00)
    end

    def ldclrb rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 0, 0, 0b00)
    end

    def ldclrlb rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 0, 1, 0b00)
    end

    def ldclrah rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 1, 0, 0b01)
    end

    def ldclralh rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 1, 1, 0b01)
    end

    def ldclrh rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 0, 0, 0b01)
    end

    def ldclrlh rs, rt, rn
      a LDCLRB.new(rs, rt, rn.first, 0, 1, 0b01)
    end

    def ldeor rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 0, rs.opc2)
    end

    def ldeora rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 0, rs.opc2)
    end

    def ldeoral rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 1, rs.opc2)
    end

    def ldeorl rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 1, rs.opc2)
    end

    def ldeorab rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 0, 0b00)
    end

    def ldeoralb rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 1, 0b00)
    end

    def ldeorb rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 0, 0b00)
    end

    def ldeorlb rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 1, 0b00)
    end

    def ldeorah rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 0, 0b01)
    end

    def ldeoralh rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 1, 1, 0b01)
    end

    def ldeorh rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 0, 0b01)
    end

    def ldeorlh rs, rt, rn
      a LDEOR.new(rs, rt, rn.first, 0, 1, 0b01)
    end

    def ldg xt, xn
      a LDG.new(xt, xn.first, xn[1] || 0)
    end

    def ldgm xt, xn
      a LDGM.new(xt, xn.first)
    end

    def ldlar rt, rn
      a LDLAR.new(rt, rn.first, rt.opc2)
    end

    def ldlarb rt, rn
      a LDLAR.new(rt, rn.first, 0b00)
    end

    def ldlarh rt, rn
      a LDLAR.new(rt, rn.first, 0b01)
    end

    def ldnp rt1, rt2, rn
      div = rt1.size / 8
      a LDNP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, rt1.opc3)
    end

    def ldp rt1, rt2, rn, imm = nil
      opc = rt1.opc3
      div = rt1.size / 8

      if imm
        if imm == :!
          # pre-index
          a LDP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, 0b011, opc)
        else
          # post-index
          a LDP_gen.new(rt1, rt2, rn.first, (imm || 0) / div, 0b001, opc)
        end
      else
        # signed offset
        a LDP_gen.new(rt1, rt2, rn.first, (rn[1] || 0) / div, 0b010, opc)
      end
    end

    def ldpsw rt, rt2, rn, imm = nil
      div = 4

      if imm
        if imm == :!
          # pre-index
          a LDPSW.new(rt, rt2, rn.first, (rn[1] || 0) / div, 0b011)
        else
          # post-index
          a LDPSW.new(rt, rt2, rn.first, (imm || 0) / div, 0b001)
        end
      else
        # signed offset
        a LDPSW.new(rt, rt2, rn.first, (rn[1] || 0) / div, 0b010)
      end
    end

    def ldr rt, rn, simm = nil
      size = rt.opc2

      if simm
        if simm == :!
          a LDR_imm_gen.new(rt, rn.first, (rn[1] || 0), size, 0b11)
        else
          if simm.integer?
            a LDR_imm_gen.new(rt, rn.first, simm, size, 0b01)
          else
            raise
          end
        end
      else
        if rn.is_a?(Array)
          simm = rn[1] || 0
          if simm.integer?
            div = rt.size / 8
            a LDR_imm_unsigned.new(rt, rn.first, simm / div, size)
          else
            rn, rm, option = *rn
            option ||= Shifts::Shift.new(0, 0, :lsl)
            extend = case option.name
                     when :uxtw then 0b010
                     when :lsl  then 0b011
                     when :sxtw then 0b110
                     when :sxtx then 0b111
                     else
                       raise option.name
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

            a LDR_reg_gen.new(rt, rn, rm, size, extend, amount)
          end
        else
          if rn.integer?
            rn = wrap_offset_with_label rn
          end
          a LDR_lit_gen.new(rt, rn, rt.sf)
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

            s = if option.shift?
              !!option.amount
            else
              false
            end
            a LDRB_reg.new(wt, xn, imm, s ? 1 : 0, val)
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

            s = if option.shift?
              !!option.amount
            else
              false
            end
            a LDRH_reg.new(wt, xn, imm, s ? 1 : 0, val)
          else
            a LDRH_reg.new(wt, xn, imm, 0, 0b11)
          end
        end
      end
    end

    def ldrsb wt, xn, imm = nil
      opc = wt.opc

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
      opc = wt.opc

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

              a LDRSW_reg.new(xt, xn, imm, (option.amount || 0) / 2, val)
            else
              a LDRSW_reg.new(xt, xn, imm, 0, 0b11)
            end
          end
        else
          if xn.integer?
            xn = wrap_offset_with_label xn
          end
          a LDRSW_lit.new(xt, xn)
        end
      end
    end

    def ldset rs, rt, rn
      a LDSET.new(rs, rt, rn.first, rs.opc2, 0, 0)
    end

    def ldseta rs, rt, rn
      a LDSET.new(rs, rt, rn.first, rs.opc2, 1, 0)
    end

    def ldsetal rs, rt, rn
      a LDSET.new(rs, rt, rn.first, rs.opc2, 1, 1)
    end

    def ldsetl rs, rt, rn
      a LDSET.new(rs, rt, rn.first, rs.opc2, 0, 1)
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
      a LDSMAX.new(rs, rt, rn.first, rs.opc2, 0, 0)
    end

    def ldsmaxa rs, rt, rn
      a LDSMAX.new(rs, rt, rn.first, rs.opc2, 1, 0)
    end

    def ldsmaxal rs, rt, rn
      a LDSMAX.new(rs, rt, rn.first, rs.opc2, 1, 1)
    end

    def ldsmaxl rs, rt, rn
      a LDSMAX.new(rs, rt, rn.first, rs.opc2, 0, 1)
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
      a LDSMIN.new(rs, rt, rn.first, rs.opc2, 0, 0)
    end

    def ldsmina rs, rt, rn
      a LDSMIN.new(rs, rt, rn.first, rs.opc2, 1, 0)
    end

    def ldsminal rs, rt, rn
      a LDSMIN.new(rs, rt, rn.first, rs.opc2, 1, 1)
    end

    def ldsminl rs, rt, rn
      a LDSMIN.new(rs, rt, rn.first, rs.opc2, 0, 1)
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
      a LDTR.new(rt, rn.first, rn[1] || 0, rt.opc2)
    end

    def ldtrb rt, rn
      a LDTRB.new(rt, rn.first, rn[1] || 0)
    end

    def ldtrh rt, rn
      a LDTRH.new(rt, rn.first, rn[1] || 0)
    end

    def ldtrsb rt, rn
      a LDTRSB.new(rt, rn.first, rn[1] || 0, rt.opc)
    end

    def ldtrsh rt, rn
      a LDTRSH.new(rt, rn.first, rn[1] || 0, rt.opc)
    end

    def ldtrsw rt, rn
      a LDTRSW.new(rt, rn.first, rn[1] || 0)
    end

    def ldumax rs, rt, rn
      a LDUMAX.new(rs, rt, rn.first, rt.opc2, 0, 0)
    end

    def ldumaxa rs, rt, rn
      a LDUMAX.new(rs, rt, rn.first, rt.opc2, 1, 0)
    end

    def ldumaxal rs, rt, rn
      a LDUMAX.new(rs, rt, rn.first, rt.opc2, 1, 1)
    end

    def ldumaxl rs, rt, rn
      a LDUMAX.new(rs, rt, rn.first, rt.opc2, 0, 1)
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
      a LDUR_gen.new(rt, rn.first, rn[1] || 0, rt.opc2)
    end

    def ldurb rt, rn
      a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b00)
    end

    def ldurh rt, rn
      a LDUR_gen.new(rt, rn.first, rn[1] || 0, 0b01)
    end

    def ldxr rt, rn
      a LDXR.new(rt, rn.first, rt.opc2)
    end

    def ldxrb rt, rn
      a LDXR.new(rt, rn.first, 0b00)
    end

    def ldxrh rt, rn
      a LDXR.new(rt, rn.first, 0b01)
    end

    def lsl rd, rn, rm
      if rm.integer?
        ubfm rd, rn, -rm % rd.size, (rd.size - 1) - rm
      else
        lslv rd, rn, rm
      end
    end

    def lslv rd, rn, rm
      a LSLV.new(rd, rn, rm, rd.sf)
    end

    def lsr rd, rn, rm
      if rm.integer?
        ubfm rd, rn, rm, rd.size - 1
      else
        lsrv rd, rn, rm
      end
    end

    def lsrv rd, rn, rm
      a LSRV.new(rd, rn, rm, rd.sf)
    end

    def madd rd, rn, rm, ra
      a MADD.new(rd, rn, rm, ra, rd.sf)
    end

    def mneg rd, rn, rm
      msub rd, rn, rm, rd.zr
    end

    def mov rd, rm
      if rm.integer?
        if rm < 0
          rm = ~rm
          if rm < 65536 || rm % 65536 == 0
            movn(rd, rm)
          else
            orr(rd, rd.zr, ~rm)
          end
        else
          if rm < 65536 || rm % 65536 == 0
            movz(rd, rm)
          else
            orr(rd, rd.zr, rm)
          end
        end
      else
        if rd.sp? || rm.sp?
          add rd, rm, 0
        else
          orr(rd, rd.zr, rm)
        end
      end
    end

    def movn rd, imm, option = nil, lsl: 0
      lsl = option.amount if option

      lsl /= 16
      while imm > 65535
        lsl += 1
        imm >>= 16
      end
      a MOVN.new(rd, imm, lsl, rd.sf)
    end

    def movz reg, imm, option = nil, lsl: 0
      lsl = option.amount if option

      lsl /= 16
      while imm > 65535
        lsl += 1
        imm >>= 16
      end
      a MOVZ.new(reg, imm, lsl, reg.sf)
    end

    def movk reg, imm, option = nil, lsl: 0
      lsl = option.amount if option
      a MOVK.new(reg, imm, lsl / 16, reg.sf)
    end

    def mrs rt, reg
      o0 = case reg.op0
           when 2 then 0
           when 3 then 1
           else
             raise
           end
      a MRS.new(o0, reg.op1, reg.CRn, reg.CRm, reg.op2, rt)
    end

    def msr reg, rt
      if rt.integer?
        raise NotImplementedError
      else
        o0 = case reg.op0
             when 2 then 0
             when 3 then 1
             else
               raise
             end

        a MSR_reg.new(o0, reg.op1, reg.CRn, reg.CRm, reg.op2, rt)
      end
    end

    def msub rd, rn, rm, ra
      a MSUB.new(rd, rn, rm, ra, rd.sf)
    end

    def mul rd, rn, rm
      madd rd, rn, rm, rd.zr
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

      a ORN_log_shift.new(rd, rn, rm, shift, amount, rd.sf)
    end

    def orr rd, rn, rm, option = nil, shift: :lsl, amount: 0
      if rm.integer?
        encoding = Utils.encode_mask(rm, rd.size)
        a ORR_log_imm.new(rd, rn, encoding.n, encoding.immr, encoding.imms, rd.sf)
      else
        if option
          shift = option.name
          amount = option.amount
        end

        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)

        a ORR_log_shift.new(rd, rn, rm, shift, amount, rd.sf)
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
                    raise option.name
                  end
          a PRFM_reg.new(rt, xn, rm, shift, (option.amount || 0) / 3)
        end
      else
        if xn.integer?
          xn = wrap_offset_with_label xn
        end

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
      a RET.new(reg)
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
      a SBFM.new(d, n, immr, imms, d.sf)
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

    def st64bv rs, rt, rn
      a ST64BV.new(rs, rt, rn.first)
    end

    def st64bv0 rs, rt, rn
      a ST64BV0.new(rs, rt, rn.first)
    end

    def stadd rs, rn
      ldadd rs, rs.zr, rn
    end

    def staddl rs, rn
      ldaddl rs, rs.zr, rn
    end

    def staddb rs, rn
      ldaddb rs, rs.zr, rn
    end

    def staddlb rs, rn
      ldaddlb rs, rs.zr, rn
    end

    def staddh rs, rn
      ldaddh rs, rs.zr, rn
    end

    def staddlh rs, rn
      ldaddlh rs, rs.zr, rn
    end

    def stclr rs, rn
      ldclr rs, rs.zr, rn
    end

    def stclrl rs, rn
      ldclrl rs, rs.zr, rn
    end

    def stclrb rs, rn
      ldclrb rs, rs.zr, rn
    end

    def stclrlb rs, rn
      ldclrlb rs, rs.zr, rn
    end

    def stclrh rs, rn
      ldclrh rs, rs.zr, rn
    end

    def stclrlh rs, rn
      ldclrlh rs, rs.zr, rn
    end

    def steor rs, rn
      ldeor rs, rs.zr, rn
    end

    def steorl rs, rn
      ldeorl rs, rs.zr, rn
    end

    def steorb rs, rn
      ldeorb rs, rs.zr, rn
    end

    def steorlb rs, rn
      ldeorlb rs, rs.zr, rn
    end

    def steorh rs, rn
      ldeorh rs, rs.zr, rn
    end

    def steorlh rs, rn
      ldeorlh rs, rs.zr, rn
    end

    def stg rt, rn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a STG.new(rt, rn.first, (rn[1] || 0) / 16, 0b11)
        else
          # Post index
          a STG.new(rt, rn.first, (imm || 0) / 16, 0b01)
        end
      else
        # Signed offset
        a STG.new(rt, rn.first, (rn[1] || 0) / 16, 0b10)
      end
    end

    def stgm rt, rn
      a STGM.new(rt, rn.first)
    end

    def stgp xt1, xt2, xn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a STGP.new(xt1, xt2, xn.first, (xn[1] || 0) / 16, 0b011)
        else
          # Post index
          a STGP.new(xt1, xt2, xn.first, imm / 16, 0b001)
        end
      else
        # Signed offset
        a STGP.new(xt1, xt2, xn.first, (xn[1] || 0) / 16, 0b010)
      end
    end

    def stllr rt, rn
      a STLLR.new(rt, rn.first, rt.sizeb)
    end

    def stllrb rt, rn
      a STLLRB.new(rt, rn.first)
    end

    def stllrh rt, rn
      a STLLRH.new(rt, rn.first)
    end

    def stlr rt, rn
      a STLR.new(rt, rn.first, rt.sizeb)
    end

    def stlrb rt, rn
      a STLRB.new(rt, rn.first)
    end

    def stlrh rt, rn
      a STLRH.new(rt, rn.first)
    end

    def stlur rt, rn
      a STLUR_gen.new(rt, rn.first, rn[1] || 0, rt.sizeb)
    end

    def stlurb rt, rn
      a STLUR_gen.new(rt, rn.first, rn[1] || 0, 0b00)
    end

    def stlurh rt, rn
      a STLUR_gen.new(rt, rn.first, rn[1] || 0, 0b01)
    end

    def stlxp rs, rt, rt2, rn
      a STLXP.new(rs, rt, rt2, rn.first, rt.sz)
    end

    def stlxr rs, rt, rn
      a STLXR.new(rs, rt, rn.first, rt.sizeb)
    end

    def stlxrb rs, rt, rn
      a STLXRB.new(rs, rt, rn.first)
    end

    def stlxrh rs, rt, rn
      a STLXRH.new(rs, rt, rn.first)
    end

    def stnp rt, rt2, rn
      a STNP_gen.new(rt, rt2, rn.first, (rn[1] || 0) / (rt.size / 8), rt.opc3)
    end

    def stp rt, rt2, rn, imm = nil
      div = rt.size / 8

      if imm
        if imm == :!
          # Pre index
          a STP_gen.new(rt, rt2, rn.first, (rn[1] || 0) / div, rt.opc3, 0b011)
        else
          # Post index
          a STP_gen.new(rt, rt2, rn.first, imm / div, rt.opc3, 0b001)
        end
      else
        # Signed offset
        a STP_gen.new(rt, rt2, rn.first, (rn[1] || 0) / div, rt.opc3, 0b010)
      end
    end

    def str rt, rn, imm = nil
      if imm
        if imm == :!
          # Post index
          a STR_imm_gen.new(rt, rn.first, rn[1] || 0, 0b11, rt.sizeb)
        else
          # Pre index
          a STR_imm_gen.new(rt, rn.first, imm || 0, 0b01, rt.sizeb)
        end
      else
        imm = rn[1] || 0
        if imm.integer?
          # Unsigned
          div = rt.size / 8
          a STR_imm_unsigned.new(rt, rn.first, imm / div, rt.sizeb)
        else
          rn, rm, opt = *rn
          opt ||= Extends::Extend.new(0, 0, :lsl)
          extend = case opt.name
                   when :uxtw then 0b010
                   when :lsl  then 0b011
                   when :sxtw then 0b110
                   when :sxtx then 0b111
                   else
                     raise "Unknown type #{opt.name}"
                   end

          amount = (opt.amount || 0) / (rt.x? ? 3 : 2)
          a STR_reg_gen.new(rt, rn, rm, extend, amount, rt.sizeb)
        end
      end
    end

    def strb rt, rn, imm = nil
      if imm
        if imm == :!
          # Post index
          a STRB_imm.new(rt, rn.first, rn[1] || 0, 0b11)
        else
          # Pre index
          a STRB_imm.new(rt, rn.first, imm, 0b01)
        end
      else
        imm = rn[1] || 0
        if imm.integer?
          # Unsigned
          a STRB_imm_unsigned.new(rt, rn.first, imm)
        else
          amount = rn[2] ? 1 : 0

          rn, rm, opt = *rn
          opt ||= Extends::Extend.new(0, 0, :lsl)
          extend = case opt.name
                   when :uxtw then 0b010
                   when :lsl  then 0b011
                   when :sxtw then 0b110
                   when :sxtx then 0b111
                   else
                     raise "Unknown type #{opt.name}"
                   end

          a STRB_reg.new(rt, rn, rm, extend, amount)
        end
      end
    end

    def strh rt, rn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a STRH_imm.new(rt, rn.first, rn[1] || 0, 0b11)
        else
          # Post index
          a STRH_imm.new(rt, rn.first, imm, 0b01)
        end
      else
        imm = rn[1] || 0
        if imm.integer?
          # Unsigned
          a STRH_imm_unsigned.new(rt, rn.first, imm >> 1)
        else
          rn, rm, opt = *rn
          opt ||= Extends::Extend.new(0, 0, :lsl)
          extend = case opt.name
                   when :uxtw then 0b010
                   when :lsl  then 0b011
                   when :sxtw then 0b110
                   when :sxtx then 0b111
                   else
                     raise "Unknown type #{opt.name}"
                   end

          amount = (opt.amount || 0) > 0 ? 1 : 0

          a STRH_reg.new(rt, rn, rm, extend, amount)
        end
      end
    end

    def stset rs, rn
      ldset rs, rs.zr, rn
    end

    def stsetl rs, rn
      ldsetl rs, rs.zr, rn
    end

    def stsetb rs, rn
      ldsetb rs, rs.zr, rn
    end

    def stsetlb rs, rn
      ldsetlb rs, rs.zr, rn
    end

    def stseth rs, rn
      ldseth rs, rs.zr, rn
    end

    def stsetlh rs, rn
      ldsetlh rs, rs.zr, rn
    end

    def stsmax rs, rn
      ldsmax rs, rs.zr, rn
    end

    def stsmaxl rs, rn
      ldsmaxl rs, rs.zr, rn
    end

    def stsmaxb rs, rn
      ldsmaxb rs, rs.zr, rn
    end

    def stsmaxlb rs, rn
      ldsmaxlb rs, rs.zr, rn
    end

    def stsmaxh rs, rn
      ldsmaxh rs, rs.zr, rn
    end

    def stsmaxlh rs, rn
      ldsmaxlh rs, rs.zr, rn
    end

    def stsmin rs, rn
      ldsmin rs, rs.zr, rn
    end

    def stsminl rs, rn
      ldsminl rs, rs.zr, rn
    end

    def stsminb rs, rn
      ldsminb rs, rs.zr, rn
    end

    def stsminlb rs, rn
      ldsminlb rs, rs.zr, rn
    end

    def stsminh rs, rn
      ldsminh rs, rs.zr, rn
    end

    def stsminlh rs, rn
      ldsminlh rs, rs.zr, rn
    end

    def sttr rt, rn
      a STTR.new(rt, rn.first, rn[1] || 0, rt.sizeb)
    end

    def sttrb rt, rn
      a STTR.new(rt, rn.first, rn[1] || 0, 0b00)
    end

    def sttrh rt, rn
      a STTR.new(rt, rn.first, rn[1] || 0, 0b01)
    end

    def stumax rs, rn
      ldumax rs, rs.zr, rn
    end

    def stumaxl rs, rn
      ldumaxl rs, rs.zr, rn
    end

    def stumaxb rs, rn
      ldumaxb rs, rs.zr, rn
    end

    def stumaxlb rs, rn
      ldumaxlb rs, rs.zr, rn
    end

    def stumaxh rs, rn
      ldumaxh rs, rs.zr, rn
    end

    def stumaxlh rs, rn
      ldumaxlh rs, rs.zr, rn
    end

    def stumin rs, rn
      ldumin rs, rs.zr, rn
    end

    def stuminl rs, rn
      lduminl rs, rs.zr, rn
    end

    def stuminb rs, rn
      lduminb rs, rs.zr, rn
    end

    def stuminlb rs, rn
      lduminlb rs, rs.zr, rn
    end

    def stuminh rs, rn
      lduminh rs, rs.zr, rn
    end

    def stuminlh rs, rn
      lduminlh rs, rs.zr, rn
    end

    def stur rt, rn
      a STUR_gen.new(rt, rn.first, rn[1] || 0, rt.sizeb)
    end

    def sturb rt, rn
      a STUR_gen.new(rt, rn.first, rn[1] || 0, 0b00)
    end

    def sturh rt, rn
      a STUR_gen.new(rt, rn.first, rn[1] || 0, 0b01)
    end

    def stxp rs, rt1, rt2, rn
      a STXP.new(rs, rt1, rt2, rn.first, rt1.sf)
    end

    def stxr rs, rt, rn
      a STXR.new(rs, rt, rn.first, rt.opc2)
    end

    def stxrb rs, rt, rn
      a STXRB.new(rs, rt, rn.first)
    end

    def stxrh rs, rt, rn
      a STXRH.new(rs, rt, rn.first)
    end

    def stz2g rt, rn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a STZ2G.new(rt, rn.first, (rn[1] || 0) / 16, 0b11)
        else
          a STZ2G.new(rt, rn.first, imm / 16, 0b01)
        end
      else
        # Signed offset
        a STZ2G.new(rt, rn.first, (rn[1] || 0) / 16, 0b10)
      end
    end

    def stzg rt, rn, imm = nil
      if imm
        if imm == :!
          # Pre index
          a STZG.new(rt, rn.first, (rn[1] || 0) / 16, 0b11)
        else
          a STZG.new(rt, rn.first, imm / 16, 0b01)
        end
      else
        # Signed offset
        a STZG.new(rt, rn.first, (rn[1] || 0) / 16, 0b10)
      end
    end

    def stzgm rt, rn
      a STZGM.new(rt, rn.first)
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
        extend = if m.x?
                   Utils.sub_decode_extend64(extend)
                 else
                   Utils.sub_decode_extend32(extend)
                 end
        a SUBS_addsub_ext.new(d, n, m, extend, amount, d.sf)
      else
        if m.integer?
          a SUBS_addsub_imm.new(d, n, m, lsl / 12, d.sf)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          a SUBS_addsub_shift.new(d, n, m, shift, amount, d.sf)
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
        extend = if m.x?
                   Utils.sub_decode_extend64(extend)
                 else
                   Utils.sub_decode_extend32(extend)
                 end
        a SUB_addsub_ext.new(d, n, m, extend, amount, d.sf)
      else
        if m.integer?
          a SUB_addsub_imm.new(d, n, m, (lsl || 0) / 12, d.sf)
        else
          shift = [:lsl, :lsr, :asr].index(shift) || raise(NotImplementedError)
          a SUB_addsub_shift.new(d, n, m, shift, amount, d.sf)
        end
      end
    end

    def subg xd, xn, uimm6, uimm4
      raise NotImplementedError unless xd.x?
      a SUBG.new(xd, xn, uimm6, uimm4)
    end

    def subp xd, xn, xm
      raise NotImplementedError unless xd.x?
      a SUBP.new(xd, xn, xm)
    end

    def subps xd, xn, xm
      raise NotImplementedError unless xd.x?
      a SUBPS.new(xd, xn, xm)
    end

    def svc imm
      a SVC.new(imm)
    end

    def swp rs, rt, rn
      a SWP.new(rs, rt, rn.first, rs.opc2, 0, 0)
    end

    def swpal rs, rt, rn
      a SWP.new(rs, rt, rn.first, rs.opc2, 1, 1)
    end

    def swpl rs, rt, rn
      a SWP.new(rs, rt, rn.first, rs.opc2, 0, 1)
    end

    def swpa rs, rt, rn
      a SWP.new(rs, rt, rn.first, rs.opc2, 1, 0)
    end

    def swpab rs, rt, rn
      a SWPB.new(rs, rt, rn.first, 1, 0)
    end

    def swpalb rs, rt, rn
      a SWPB.new(rs, rt, rn.first, 1, 1)
    end

    def swpb rs, rt, rn
      a SWPB.new(rs, rt, rn.first, 0, 0)
    end

    def swplb rs, rt, rn
      a SWPB.new(rs, rt, rn.first, 0, 1)
    end

    def swpah rs, rt, rn
      a SWPH.new(rs, rt, rn.first, 1, 0)
    end

    def swpalh rs, rt, rn
      a SWPH.new(rs, rt, rn.first, 1, 1)
    end

    def swph rs, rt, rn
      a SWPH.new(rs, rt, rn.first, 0, 0)
    end

    def swplh rs, rt, rn
      a SWPH.new(rs, rt, rn.first, 0, 1)
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
      a SYS.new(op1, cn, cm, op2, xt)
    end

    def sysl xt, op1, cn, cm, op2
      a SYSL.new(xt, op1, cn, cm, op2)
    end

    def tbnz rt, imm, label
      if label.integer?
        label = wrap_offset_with_label label
      end

      sf = 0
      if imm > 31
        sf = 1
        imm -= 32
      end
      a TBNZ.new(rt, imm, label, sf)
    end

    def tbz rt, imm, label
      if label.integer?
        label = wrap_offset_with_label label
      end

      sf = 0
      if imm > 31
        sf = 1
        imm -= 32
      end
      a TBZ.new(rt, imm, label, sf)
    end

    def tlbi tlbi_op, xt = XZR
      op1, crm, op2 = Utils.tlbi_op(tlbi_op)
      sys op1, Names::C8, crm, op2, xt
    end

    def tsb _
      a TSB.new
    end

    def tst rn, rm, option = nil, shift: :lsl, amount: 0
      if option
        shift = option.name
        amount = option.amount
      end

      ands rn.zr, rn, rm, shift: shift, amount: amount
    end

    def ubfm rd, rn, immr, imms
      a UBFM.new(rd, rn, immr, imms, rd.sf)
    end

    def ubfiz rd, rn, lsb, width
      ubfm rd, rn, (-lsb) % rd.size, width - 1
    end

    def ubfx rd, rn, lsb, width
      ubfm rd, rn, lsb, lsb + width - 1
    end

    def udf imm
      a UDF_perm_undef.new(imm)
    end

    def udiv rd, rn, rm
      a UDIV.new(rd, rn, rm, rd.sf)
    end

    def umaddl xd, wn, wm, xa
      a UMADDL.new(xd, wn, wm, xa)
    end

    def umnegl xd, wn, wm
      umsubl xd, wn, wm, XZR
    end

    def umsubl xd, wn, wm, xa
      a UMSUBL.new(xd, wn, wm, xa)
    end

    def umulh rd, rn, rm
      a UMULH.new(rd, rn, rm)
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
      a WFE.new
    end

    def wfet rd
      a WFET.new(rd)
    end

    def wfi
      a WFI.new
    end

    def wfit rd
      a WFIT.new(rd)
    end

    def xaflag
      a XAFLAG.new
    end

    def xpacd rd
      a XPAC.new(rd, 1)
    end

    def xpaci rd
      a XPAC.new(rd, 0)
    end

    def xpaclri
      a XPACLRI.new
    end

    def yield
      a YIELD.new
    end

    ##
    # Yields the offset in the instructions
    def patch_location
      yield @insns.length * 4
    end

    def write_to io
      io.write to_binary
    end

    def to_binary
      @insns.map.with_index { _1.encode(_2) }.pack("L<*")
    end

    private

    def a insn
      @insns = @insns << insn
      self
    end

    def wrap_offset_with_label offset
      Immediate.new(offset / 4)
    end
  end
end
