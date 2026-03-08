module AArch64
  class Rec
    include Instructions

    def initialize scan, asm
      @scan = scan
      @asm = asm
      @labels = {}
      @defined_labels = {}
    end

    def instructions
      while !@scan.eof?
        tok = @scan.peek
        name = tok.first.to_s

        if respond_to?("parse_#{name}")
          if tok.first != :LABEL_CREATE
            expect tok.first
          end
          if node = send("parse_#{name}")
            @asm << node
          end
          expect :EOL
        else
          string = @scan.string
          line_number = string.byteslice(0, @scan.pos).count("\n") + 1
          val = tok.last
          raise AArch64::ParseError, "parse error on value #{val.inspect} (#{name}) on line #{line_number} at pos #{@scan.pos}/#{string.bytesize}"
        end
      end

      @labels.each do |name, label|
        unless @defined_labels[name]
          raise "Label #{name.inspect} not defined"
        end
      end

      @asm
    end

    def parse_LABEL_CREATE
      label_name = next_token
      label = if @defined_labels[label_name]
        raise "symbol '#{label_name}' is already defined"
      else
        @defined_labels[label_name] = (@labels[label_name] ||= @asm.make_label(label_name))
      end
      @asm.put_label(label)
      false
    end

    def parse_ADC
      if @scan.peek.last.x?
        xd_xd_xd Instructions::ADC
      else
        wd_wd_wd Instructions::ADC
      end
    end

    def parse_ADCS
      if @scan.peek.last.x?
        xd_xd_xd ADCS
      else
        wd_wd_wd ADCS
      end
    end

    def parse_ADD
      add_body ADD
    end

    def parse_ADDG
      d = next_token
      expect(:COMMA)
      n = next_token
      expect(:COMMA)
      imm6 = expect(:NUMBER)
      expect(:COMMA)
      imm4 = expect(:NUMBER)
      ADDG.new(d, n, imm6 / 16, imm4)
    end

    def parse_ADDS
      add_body ADDS
    end

    def parse_ADR
      adr_body ADR
    end

    def parse_ADRP
      adr_body ADRP
    end

    def parse_AND
      and_body AND
    end

    def parse_ANDS
      and_body ANDS
    end

    def parse_ASR
      d = next_token
      expect(:COMMA)
      n = d.x? ? expect_x : expect_w
      expect(:COMMA)

      m = if at(:NUMBER)
        next_token
      else
        d.x? ? expect_x : expect_w
      end
      @asm.asr d, n, m
      false
    end

    def parse_AT
      op = next_token.to_sym
      comma
      d = next_token
      @asm.at op, d
      false
    end

    def parse_B

      cond = nil
      if at(:DOT)
        expect :DOT
        cond = next_token.to_sym
        label = if at(:NUMBER)
          next_token
        else
          label_name = next_token
          @labels[label_name] ||= @asm.make_label(label_name)
        end
      else
        label = if at(:NUMBER)
          next_token
        else
          label_name = next_token
          @labels[label_name] ||= @asm.make_label(label_name)
        end
      end

      @asm.b label, cond: cond
      false
    end

    def parse_BFI
      bfi_body { |d, n, lsb, width| @asm.bfi d, n, lsb, width }
      false
    end

    def parse_BFXIL
      bfi_body { |d, n, lsb, width| @asm.bfxil d, n, lsb, width }
      false
    end

    def parse_BIC
      shifted BIC_log_shift
    end

    def parse_BICS
      shifted BICS
    end

    def parse_BL
      val = if at(:NUMBER)
        next_token
      else
        label_name = next_token
        @labels[label_name] ||= @asm.make_label(label_name)
      end

      @asm.bl val
      false
    end

    def parse_BLR
      @asm.blr(next_token)
      false
    end

    def parse_BR
      @asm.br(next_token)
      false
    end

    def parse_BRK
      @asm.brk(expect(:NUMBER))
      false
    end

    def parse_CBNZ
      reg_imm_or_label { |rt, where| @asm.cbnz rt, where }
    end

    def parse_CBZ
      reg_imm_or_label { |rt, where| @asm.cbz rt, where }
    end

    def parse_CINC
      cond_three { |d, n, cond| @asm.cinc d, n, cond }
    end

    def parse_CINV
      cond_three { |d, n, cond| @asm.cinv d, n, cond }
    end

    def parse_CLREX
      if at(:NUMBER)
        @asm.clrex(next_token)
      else
        @asm.clrex(15)
      end
      false
    end

    def parse_CLS
      reg_reg { |d, n| @asm.cls d, n }
    end

    def parse_CLZ
      reg_reg { |d, n| @asm.clz d, n }
    end

    def parse_CMN
      cmn_body ADDS
    end

    def parse_CMP
      cmn_body SUBS
    end

    def parse_CNEG
      cond_three { |d, n, cond| @asm.cneg d, n, cond }
    end

    class_eval %w{ CSEL CSINV CSINC CCMN CCMP CSNEG }.map { |n|
      <<-eorb
    def parse_#{n}
      cond_four { |d, n, m, cond| @asm.#{n.downcase} d, n, m, cond }
    end
      eorb
    }.join("\n")

    def parse_CSET
      cond_two { |d, cond| @asm.cset d, cond }
    end

    def parse_CSETM
      cond_two { |d, cond| @asm.csetm d, cond }
    end

    class_eval %w{ CRC32B CRC32H CRC32W CRC32CB CRC32CH CRC32CW }.map { |n|
      <<-eorb
    def parse_#{n}
      wd_wd_wd { |d, n, m| @asm.#{n.downcase} d, n, m }
    end
      eorb
    }.join("\n")

    def parse_CRC32X
      rd = expect_w
      comma
      rn = expect_w
      comma
      rm = expect_x
      @asm.crc32x rd, rn, rm
      false
    end

    def parse_CRC32CX
      rd = expect_w
      comma
      rn = expect_w
      comma
      rm = expect_x
      @asm.crc32cx rd, rn, rm
      false
    end

    def parse_DC
      op = expect_any([:IVAC, :ISW, :IGVAC, :IGSW, :IGDVAC, :IGDSW, :CSW, :CGSW,
        :CGDSW, :CISW, :CIGSW, :CIGDSW, :ZVA, :GVA, :GZVA, :CVAC, :CGVAC,
        :CGDVAC, :CVAU, :CVAP, :CGVAP, :CGDVAP, :CVADP, :CGVADP, :CGDVADP,
        :CIVAC, :CIGVAC, :CIGDVAC]).to_sym
      comma
      xt = expect_x
      @asm.dc op, xt
      false
    end

    class_eval 3.times.map { |i|
      "def parse_DCPS#{i + 1}; DCPS.new(0, #{i + 1}); end"
    }.join("\n")

    def parse_DMB
      dmb_body DMB
    end

    def parse_DSB
      dmb_body DSB
    end

    def parse_EOR
      and_body EOR
    end

    def parse_EON
      shifted EON
    end

    def parse_EXTR
      reg_reg_reg { |d, n, m|
        comma
        EXTR.new(d, n, m, expect(:NUMBER), d.sf)
      }
    end

    def parse_AUTDA
      xd = expect_x
      comma
      xn = next_token # can be Xd or SP
      @asm.autda(xd, xn)
      false
    end

    def parse_DRPS
      @asm.drps
      false
    end

    def parse_ERET
      @asm.eret
      false
    end

    def parse_HINT
      @asm.hint(expect(:NUMBER))
      false
    end

    def parse_HLT
      @asm.hlt(expect(:NUMBER))
      false
    end

    def parse_HVC
      @asm.hvc(expect(:NUMBER))
      false
    end

    def parse_LDAR
      wd = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldar(wd, [xn])
      false
    end

    def parse_LDARB
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldarb(wd, [xn])
      false
    end

    def parse_LDARH
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldarh(wd, [xn])
      false
    end

    def parse_LDAXR
      rd = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldaxr(rd, [xn])
      false
    end

    def parse_LDAXRB
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldaxrb(wd, [xn])
      false
    end

    def parse_LDAXRH
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldaxrh(wd, [xn])
      false
    end

    def parse_LDR
      ldr_body { |rt, addr, imm| @asm.ldr(rt, addr, imm) }
    end

    def parse_LDRB
      ldr_body { |rt, addr, imm| @asm.ldrb(rt, addr, imm) }
    end

    def parse_LDRH
      ldr_body { |rt, addr, imm| @asm.ldrh(rt, addr, imm) }
    end

    def parse_LDRSB
      ldr_body { |rt, addr, imm| @asm.ldrsb(rt, addr, imm) }
    end

    def parse_LDRSH
      ldr_body { |rt, addr, imm| @asm.ldrsh(rt, addr, imm) }
    end

    def parse_LDRSW
      ldr_body { |rt, addr, imm| @asm.ldrsw(rt, addr, imm) }
    end

    def parse_LDTR
      ldtr_body { |rt, addr| @asm.ldtr(rt, addr) }
    end

    def parse_LDTRB
      ldtr_body { |rt, addr| @asm.ldtrb(rt, addr) }
    end

    def parse_LDTRH
      ldtr_body { |rt, addr| @asm.ldtrh(rt, addr) }
    end

    def parse_LDTRSB
      ldtr_body { |rt, addr| @asm.ldtrsb(rt, addr) }
    end

    def parse_LDTRSH
      ldtr_body { |rt, addr| @asm.ldtrsh(rt, addr) }
    end

    def parse_LDTRSW
      ldtr_body { |rt, addr| @asm.ldtrsw(rt, addr) }
    end

    def parse_LDUR
      ldtr_body { |rt, addr| @asm.ldur(rt, addr) }
    end

    def parse_LDURB
      ldtr_body { |rt, addr| @asm.ldurb(rt, addr) }
    end

    def parse_LDURH
      ldtr_body { |rt, addr| @asm.ldurh(rt, addr) }
    end

    def parse_LDURSB
      ldtr_body { |rt, addr| @asm.ldursb(rt, addr) }
    end

    def parse_LDURSH
      ldtr_body { |rt, addr| @asm.ldursh(rt, addr) }
    end

    def parse_LDURSW
      ldtr_body { |rt, addr| @asm.ldursw(rt, addr) }
    end

    def parse_LDXP
      rt1 = expect_reg
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldxp(rt1, rt2, [xn])
      false
    end

    def parse_LDXR
      rd = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldxr(rd, [xn])
      false
    end

    def parse_LDXRB
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldxrb(wd, [xn])
      false
    end

    def parse_LDXRH
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.ldxrh(wd, [xn])
      false
    end

    def parse_LSL
      d = next_token
      comma
      n = srt d
      comma
      m = if at(:NUMBER)
        next_token
      else
        srt d
      end
      @asm.lsl d, n, m
      false
    end

    def parse_LSR
      d = next_token
      comma
      n = srt d
      comma
      m = if at(:NUMBER)
        next_token
      else
        srt d
      end
      @asm.lsr d, n, m
      false
    end

    def parse_MADD
      reg_reg_reg { |d, n, m|
        comma
        ra = srt d
        @asm.madd d, n, m, ra
      }
      false
    end

    def parse_MNEG
      reg_reg_reg { |d, n, m| @asm.mneg d, n, m }
      false
    end

    def parse_MOV
      d = next_token
      comma
      if at(:NUMBER)
        imm = next_token
        @asm.mov d, imm
      else
        n = next_token
        @asm.mov d, n
      end
      false
    end

    def parse_MOVK
      movz_body { |d, imm, opts| @asm.movk(d, imm, **opts) }
    end

    def parse_MOVN
      movz_body { |d, imm, opts| @asm.movn(d, imm, **opts) }
    end

    def parse_MOVZ
      movz_body { |d, imm, opts| @asm.movz(d, imm, **opts) }
    end

    def parse_MRS
      xd = expect_x
      comma
      sysreg = next_token
      @asm.mrs(xd, sysreg)
      false
    end

    def parse_MSR
      sysreg = next_token
      comma
      xd = expect_x
      @asm.msr(sysreg, xd)
      false
    end

    def parse_MSUB
      reg_reg_reg { |d, n, m|
        comma
        ra = srt d
        @asm.msub d, n, m, ra
      }
      false
    end

    def parse_MUL
      reg_reg_reg { |d, n, m| @asm.mul d, n, m }
      false
    end

    def parse_MVN
      d = next_token
      comma
      n = srt d
      if at(:COMMA)
        comma
        shift = expect_any([:LSL, :LSR, :ASR, :ROR]).to_sym
        amount = expect(:NUMBER)
        @asm.mvn d, n, shift: shift, amount: amount
      else
        @asm.mvn d, n
      end
      false
    end

    def parse_NEG
      d = next_token
      comma
      n = srt d
      if at(:COMMA)
        comma
        shift = expect_any([:LSL, :LSR, :ASR]).to_sym
        amount = expect(:NUMBER)
        @asm.neg d, n, shift: shift, amount: amount
      else
        @asm.neg d, n
      end
      false
    end

    def parse_NEGS
      d = next_token
      comma
      n = srt d
      if at(:COMMA)
        comma
        shift = expect_any([:LSL, :LSR, :ASR]).to_sym
        amount = expect(:NUMBER)
        @asm.negs d, n, shift: shift, amount: amount
      else
        @asm.negs d, n
      end
      false
    end

    def parse_NGC
      reg_reg { |d, n| @asm.ngc d, n }
    end

    def parse_NGCS
      reg_reg { |d, n| @asm.ngcs d, n }
    end

    def parse_NOP
      @asm.nop
      false
    end

    def parse_ORN
      shifted Instructions::ORN::LOG_shift
    end

    def parse_ORR
      and_body Instructions::ORR
    end

    def parse_PRFM
      op = if at(:PRFOP)
        next_token.to_sym
      else
        expect(:NUMBER)
      end
      comma
      if at(:LSQ)
        expect :LSQ
        xn = expect_reg
        if at(:COMMA)
          comma
          if at(:NUMBER)
            imm = next_token
            expect :RSQ
            @asm.prfm(op, [xn, imm])
          else
            # reg offset with optional extend
            rm = next_token
            if at(:COMMA)
              comma
              ext = expect_any([:LSL, :UXTW, :SXTW, :SXTX]).to_sym
              amount = at(:NUMBER) ? next_token : nil
              expect :RSQ
              @asm.prfm(op, [xn, rm, Shifts::Shift.new(amount, 0, ext)])
            else
              expect :RSQ
              @asm.prfm(op, [xn, rm])
            end
          end
        else
          expect :RSQ
          @asm.prfm(op, [xn])
        end
      else
        imm = expect(:NUMBER)
        @asm.prfm(op, imm)
      end
      false
    end

    def parse_PRFUM
      op = if at(:PRFOP)
        next_token.to_sym
      else
        expect(:NUMBER)
      end
      comma
      expect :LSQ
      xn = expect_reg
      if at(:COMMA)
        comma
        imm = expect(:NUMBER)
        expect :RSQ
        @asm.prfum(op, [xn, imm])
      else
        expect :RSQ
        @asm.prfum(op, [xn])
      end
      false
    end

    def parse_PSSBB
      @asm.pssbb
      false
    end

    def parse_RBIT
      reg_reg { |d, n| @asm.rbit d, n }
    end

    def parse_RET
      if at(:EOL)
        @asm.ret
      else
        @asm.ret(next_token)
      end
      false
    end

    def parse_REV
      reg_reg { |d, n| @asm.rev d, n }
    end

    def parse_REV16
      reg_reg { |d, n| @asm.rev16 d, n }
    end

    def parse_REV32
      d = expect_x
      comma
      n = expect_x
      @asm.rev32 d, n
      false
    end

    def parse_ROR
      d = next_token
      comma
      n = srt d
      comma
      m = if at(:NUMBER)
        next_token
      else
        srt d
      end
      @asm.ror d, n, m
      false
    end

    def parse_SBC
      reg_reg_reg { |d, n, m| @asm.sbc d, n, m }
      false
    end

    def parse_SBCS
      reg_reg_reg { |d, n, m| @asm.sbcs d, n, m }
      false
    end

    def parse_SBFIZ
      bfi_body { |d, n, lsb, width| @asm.sbfiz d, n, lsb, width }
      false
    end

    def parse_SBFX
      bfi_body { |d, n, lsb, width| @asm.sbfx d, n, lsb, width }
      false
    end

    def parse_SDIV
      reg_reg_reg { |d, n, m| @asm.sdiv d, n, m }
      false
    end

    def parse_SEV
      @asm.sev
      false
    end

    def parse_SEVL
      @asm.sevl
      false
    end

    def parse_SMADDL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      comma
      xa = expect_x
      @asm.smaddl xd, wn, wm, xa
      false
    end

    def parse_SMC
      @asm.smc(expect(:NUMBER))
      false
    end

    def parse_SMNEGL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      @asm.smnegl xd, wn, wm
      false
    end

    def parse_SMSUBL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      comma
      xa = expect_x
      @asm.smsubl xd, wn, wm, xa
      false
    end

    def parse_SMULH
      xd = expect_x
      comma
      xn = expect_x
      comma
      xm = expect_x
      @asm.smulh xd, xn, xm
      false
    end

    def parse_SMULL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      @asm.smull xd, wn, wm
      false
    end

    def parse_SSBB
      @asm.ssbb
      false
    end

    def parse_STLR
      rt = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlr(rt, [xn])
      false
    end

    def parse_STLRB
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlrb(wd, [xn])
      false
    end

    def parse_STLRH
      wd = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlrh(wd, [xn])
      false
    end

    def parse_STLXP
      ws = expect_w
      comma
      rt1 = next_token
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlxp(ws, rt1, rt2, [xn])
      false
    end

    def parse_STLXR
      ws = expect_w
      comma
      rt = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlxr(ws, rt, [xn])
      false
    end

    def parse_STLXRB
      ws = expect_w
      comma
      wt = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlxrb(ws, wt, [xn])
      false
    end

    def parse_STLXRH
      ws = expect_w
      comma
      wt = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stlxrh(ws, wt, [xn])
      false
    end

    def parse_STNP
      rt1 = expect_reg
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      xn = expect_reg
      val = if at(:COMMA)
        comma
        expect(:NUMBER)
      else
        0
      end
      expect :RSQ
      @asm.stnp rt1, rt2, [xn, val]
      false
    end

    def parse_STP
      stp_body { |rt1, rt2, rn, imm| @asm.stp(rt1, rt2, rn, imm) }
    end

    def parse_STR
      str_body { |rt, addr, imm| @asm.str(rt, addr, imm) }
    end

    def parse_STRB
      str_body { |rt, addr, imm| @asm.strb(rt, addr, imm) }
    end

    def parse_STRH
      str_body { |rt, addr, imm| @asm.strh(rt, addr, imm) }
    end

    def parse_STTR
      ldtr_body { |rt, addr| @asm.sttr(rt, addr) }
    end

    def parse_STTRB
      ldtr_body { |rt, addr| @asm.sttrb(rt, addr) }
    end

    def parse_STTRH
      ldtr_body { |rt, addr| @asm.sttrh(rt, addr) }
    end

    def parse_STUR
      ldtr_body { |rt, addr| @asm.stur(rt, addr) }
    end

    def parse_STURB
      ldtr_body { |rt, addr| @asm.sturb(rt, addr) }
    end

    def parse_STURH
      ldtr_body { |rt, addr| @asm.sturh(rt, addr) }
    end

    def parse_STXP
      ws = expect_w
      comma
      rt1 = next_token
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stxp(ws, rt1, rt2, [xn])
      false
    end

    def parse_STXR
      ws = expect_w
      comma
      rt = next_token
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stxr(ws, rt, [xn])
      false
    end

    def parse_STXRB
      ws = expect_w
      comma
      wt = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stxrb(ws, wt, [xn])
      false
    end

    def parse_STXRH
      ws = expect_w
      comma
      wt = expect_w
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      @asm.stxrh(ws, wt, [xn])
      false
    end

    def parse_SUB
      add_body Instructions::SUB
    end

    def parse_SUBS
      add_body Instructions::SUBS
    end

    def parse_SVC
      @asm.svc(expect(:NUMBER))
      false
    end

    def parse_SXTB
      d = next_token
      comma
      n = expect_w
      @asm.sxtb d, n
      false
    end

    def parse_SXTH
      d = next_token
      comma
      n = expect_w
      @asm.sxth d, n
      false
    end

    def parse_SXTW
      d = expect_x
      comma
      n = expect_w
      @asm.sxtw d, n
      false
    end

    def parse_SYS
      op1 = expect(:NUMBER)
      comma
      cn = next_token
      comma
      cm = next_token
      comma
      op2 = expect(:NUMBER)
      if at(:COMMA)
        comma
        xt = expect_x
        @asm.sys(op1, cn, cm, op2, xt)
      else
        @asm.sys(op1, cn, cm, op2)
      end
      false
    end

    def parse_SYSL
      xd = expect_x
      comma
      op1 = expect(:NUMBER)
      comma
      cn = next_token
      comma
      cm = next_token
      comma
      op2 = expect(:NUMBER)
      @asm.sysl(xd, op1, cn, cm, op2)
      false
    end

    def parse_TBZ
      rt = next_token
      comma
      imm = expect(:NUMBER)
      comma
      label = if at(:NUMBER)
        next_token
      else
        get_label next_token
      end
      @asm.tbz rt, imm, label
      false
    end

    def parse_TBNZ
      rt = next_token
      comma
      imm = expect(:NUMBER)
      comma
      label = if at(:NUMBER)
        next_token
      else
        get_label next_token
      end
      @asm.tbnz rt, imm, label
      false
    end

    def parse_TLBI
      op = next_token.to_sym
      if at(:COMMA)
        comma
        xt = next_token
        @asm.tlbi(op, xt)
      else
        @asm.tlbi(op)
      end
      false
    end

    def parse_TST
      rn = next_token
      comma
      if at(:NUMBER)
        imm = next_token
        @asm.tst rn, imm
      else
        rm = srt rn
        if at(:COMMA)
          comma
          shift = expect_any([:LSL, :LSR, :ASR, :ROR]).to_sym
          amount = expect(:NUMBER)
          @asm.tst rn, rm, shift: shift, amount: amount
        else
          @asm.tst rn, rm
        end
      end
      false
    end

    def parse_UBFIZ
      bfi_body { |d, n, lsb, width| @asm.ubfiz d, n, lsb, width }
      false
    end

    def parse_UBFX
      bfi_body { |d, n, lsb, width| @asm.ubfx d, n, lsb, width }
      false
    end

    def parse_UDIV
      reg_reg_reg { |d, n, m| @asm.udiv d, n, m }
      false
    end

    def parse_UMADDL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      comma
      xa = expect_x
      @asm.umaddl xd, wn, wm, xa
      false
    end

    def parse_UMNEGL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      @asm.umnegl xd, wn, wm
      false
    end

    def parse_UMSUBL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      comma
      xa = expect_x
      @asm.umsubl xd, wn, wm, xa
      false
    end

    def parse_UMULH
      xd = expect_x
      comma
      xn = expect_x
      comma
      xm = expect_x
      @asm.umulh xd, xn, xm
      false
    end

    def parse_UMULL
      xd = expect_x
      comma
      wn = expect_w
      comma
      wm = expect_w
      @asm.umull xd, wn, wm
      false
    end

    def parse_UXTB
      wd = expect_w
      comma
      wn = expect_w
      @asm.uxtb wd, wn
      false
    end

    def parse_UXTH
      wd = expect_w
      comma
      wn = expect_w
      @asm.uxth wd, wn
      false
    end

    def parse_WFE
      @asm.wfe
      false
    end

    def parse_WFI
      @asm.wfi
      false
    end

    def parse_YIELD
      @asm.yield
      false
    end

    def parse_IC
      op = expect_any([:IALLUIS, :IALLU, :IVAU]).to_sym
      xt = Registers::SP
      if at(:COMMA)
        comma
        xt = next_token
      end
      @asm.ic(op, xt)
      false
    end

    def parse_ISB
      if at(:NUMBER)
        @asm.isb(next_token)
      else
        @asm.isb
      end
      false
    end

    def parse_LDAXP
      d = expect_reg
      comma
      n = srt d
      comma
      expect :LSQ
      xn = expect_reg
      expect :RSQ
      LDAXP.new d, n, xn, d.sf
    end

    def parse_LDNP
      rt1 = expect_reg
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      rt3 = expect_reg
      val = if at(:COMMA)
        comma
        expect(:NUMBER)
      else
        0
      end
      expect :RSQ
      @asm.ldnp rt1, rt2, [rt3, val]
      false
    end

    def parse_LDP
      ldp_body { |rt1, rt2, rn, imm| @asm.ldp(rt1, rt2, rn, imm) }
    end

    def parse_LDPSW
      ldp_body { |rt1, rt2, rn, imm| @asm.ldpsw(rt1, rt2, rn, imm) }
    end

    def ldp_body
      rt1 = expect_reg
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      rt3 = expect_reg
      if at(:COMMA)
        comma
        rt3 = [rt3, expect(:NUMBER)]
      else
        rt3 = [rt3]
      end
      expect :RSQ

      imm = if at(:COMMA)
        comma
        expect(:NUMBER)
      else
        if at(:BANG)
          expect :BANG
          :!
        else
          nil
        end
      end

      yield rt1, rt2, rt3, imm

      false
    end

    def movz_body
      d = next_token
      comma
      imm = expect(:NUMBER)
      opts = {}
      if at(:COMMA)
        comma
        expect :LSL
        opts[:lsl] = expect(:NUMBER)
      end
      yield d, imm, opts
      false
    end

    def ldr_body
      rt = next_token
      comma
      if at(:LSQ)
        expect :LSQ
        xn = expect_reg
        if at(:COMMA)
          comma
          if at(:NUMBER)
            imm = next_token
            expect :RSQ
            if at(:BANG)
              expect :BANG
              # pre-index: ldr rt, [xn, imm]!
              yield rt, [xn, imm], :!
            else
              # signed/unsigned offset: ldr rt, [xn, imm]
              yield rt, [xn, imm]
            end
          else
            # register offset
            rm = next_token
            if at(:COMMA)
              comma
              ext = expect_any([:LSL, :UXTW, :SXTW, :SXTX]).to_sym
              amount = at(:NUMBER) ? next_token : nil
              expect :RSQ
              yield rt, [xn, rm, Shifts::Shift.new(amount, 0, ext)]
            else
              expect :RSQ
              yield rt, [xn, rm]
            end
          end
        else
          expect :RSQ
          if at(:COMMA)
            comma
            imm = expect(:NUMBER)
            # post-index: ldr rt, [xn], imm
            yield rt, [xn], imm
          else
            yield rt, [xn]
          end
        end
      else
        # literal
        imm = expect(:NUMBER)
        yield rt, imm
      end
      false
    end

    def ldtr_body
      rt = next_token
      comma
      expect :LSQ
      xn = expect_reg
      if at(:COMMA)
        comma
        imm = expect(:NUMBER)
        expect :RSQ
        yield rt, [xn, imm]
      else
        expect :RSQ
        yield rt, [xn]
      end
      false
    end

    def str_body
      rt = next_token
      comma
      expect :LSQ
      xn = expect_reg
      if at(:COMMA)
        comma
        if at(:NUMBER)
          imm = next_token
          expect :RSQ
          if at(:BANG)
            expect :BANG
            # pre-index
            yield rt, [xn, imm], :!
          else
            yield rt, [xn, imm]
          end
        else
          # register offset
          rm = next_token
          if at(:COMMA)
            comma
            ext = expect_any([:LSL, :UXTW, :SXTW, :SXTX]).to_sym
            amount = at(:NUMBER) ? next_token : nil
            expect :RSQ
            yield rt, [xn, rm, Shifts::Shift.new(amount, 0, ext)]
          else
            expect :RSQ
            yield rt, [xn, rm]
          end
        end
      else
        expect :RSQ
        if at(:COMMA)
          comma
          imm = expect(:NUMBER)
          # post-index
          yield rt, [xn], imm
        else
          yield rt, [xn]
        end
      end
      false
    end

    def stp_body
      rt1 = expect_reg
      comma
      rt2 = srt rt1
      comma
      expect :LSQ
      rt3 = expect_reg
      if at(:COMMA)
        comma
        rt3 = [rt3, expect(:NUMBER)]
      else
        rt3 = [rt3]
      end
      expect :RSQ

      imm = if at(:COMMA)
        comma
        expect(:NUMBER)
      else
        if at(:BANG)
          expect :BANG
          :!
        else
          nil
        end
      end

      yield rt1, rt2, rt3, imm

      false
    end

    def dmb_body nm
      if at(:NUMBER)
        nm.new(next_token)
      else
        nm.new(Utils.dmb2imm(next_token))
      end
    end

    def cmn_body nm
      rn = next_token
      comma
      if at(:NUMBER)
        imm = next_token
        shift = 0

        if at(:COMMA)
          comma
          expect :LSL
          shift = expect(:NUMBER)
        end

        nm::ADDSUB_imm.new(rn.zr, rn, imm, shift / 12, rn.zr.sf)
      else
        rm = expect_reg

        if rm.x? != rn.x? || rn.sp?
          # extended
          amount = 0
          ext = rn.x? ? :uxtx : :uxtw

          if at(:COMMA)
            comma

            if at_extend
              ext = self.extend
              if at(:NUMBER)
                amount = next_token
              end
            else
              shift = expect_any([:LSL, :LSR, :ASR]).to_sym
              amount = 0

              if at(:NUMBER)
                amount = next_token
              end
            end
          end

          extend = Utils.sub_decode_extend32(ext)
          nm::ADDSUB_ext.new(rn.zr, rn, rm, extend, amount, rn.zr.sf)
        else
          # shifted
          shift = :lsl
          amount = 0

          if at(:COMMA)
            comma
            if at_extend
              ext = self.extend

              if at(:NUMBER)
                amount = next_token
              end

              extend = Utils.sub_decode_extend32(ext)
              return nm::ADDSUB_ext.new(rn.zr, rn, rm, extend, amount, rn.zr.sf)
            else
              shift = expect_any([:LSL, :LSR, :ASR]).to_sym

              if at(:NUMBER)
                amount = next_token
              end
            end
          end

          shift = [:lsl, :lsr, :asr].index(shift)
          nm::ADDSUB_shift.new(rn.zr, rn, rm, shift, amount, rn.zr.sf)
        end
      end
    end

    def reg
      d = expect_reg
      yield d
    end

    def reg_reg
      d = next_token
      comma
      n = srt d
      yield d, n
      false
    end

    def reg_reg_reg
      reg { |d|
        comma
        reg { |n|
          comma
          reg { |m| yield d, n, m }
        }
      }
    end

    def cond_two
      d = next_token
      comma
      yield d, cond
      false
    end

    def cond_three
      d = next_token
      comma
      n = d.x? ? expect_x : expect_w
      comma
      yield d, n, cond
      false
    end

    def cond_four
      d = next_token
      comma
      n = if at(:NUMBER)
        next_token
      else
        srt d
      end
      comma
      m = if at(:NUMBER)
        next_token
      else
        srt d
      end
      comma
      yield d, n, m, cond
      false
    end

    def cond
      expect_any([:EQ, :LO, :LT, :HS, :GT, :LE, :NE, :MI, :GE, :PL, :LS,
        :HI, :VC, :VS]).to_sym
    end

    def reg_imm_or_label
      rt = next_token
      comma
      where = if at(:NUMBER)
        next_token
      else
        get_label next_token
      end
      yield rt, where
      false
    end

    def shifted nm
      d = next_token
      comma
      n = d.x? ? expect_x : expect_w
      comma
      m = d.x? ? expect_x : expect_w

      shift = :lsl
      amount = 0

      if at(:COMMA)
        comma
        shift = expect_any([:LSL, :LSR, :ASR, :ROR]).to_sym
        amount = expect :NUMBER
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift)
      nm.new(d, n, m, shift, amount, d.sf)
    end

    def bfi_body
      d = next_token
      comma
      n = d.x? ? expect_x : expect_w
      comma
      lsb = expect(:NUMBER)
      comma
      width = expect(:NUMBER)
      yield d, n, lsb, width
    end

    def and_body nm
      d = next_token
      expect(:COMMA)
      n = d.x? ? expect_x : expect_w
      expect(:COMMA)

      if at(:NUMBER)
        m = next_token
        enc = Utils.encode_mask(m, d.size) || raise("Can't encode mask #{m}")
        nm::LOG_imm.new(d, n, enc.immr, enc.imms, enc.n, d.sf)
      else
        m = d.x? ? expect_x : expect_w
        shift = :lsl
        amount = 0

        if at(:COMMA)
          expect(:COMMA)
          shift = next_token.to_sym
          if at(:NUMBER)
            amount = next_token
          end
        end
        shift = [:lsl, :lsr, :asr, :ror].index(shift) || raise(NotImplementedError)
        nm::LOG_shift.new(d, n, m, shift, amount, d.sf)
      end
    end

    def adr_body nm
      reg = next_token
      expect(:COMMA)
      label = if at(:NUMBER)
        Assembler::Immediate.new(next_token)
      else
        label_name = next_token
        @labels[label_name] ||= @asm.make_label(label_name)
      end
      nm.new(reg, label)
    end

    def add_body nm
      d = next_token
      expect(:COMMA)
      n = next_token
      expect(:COMMA)
      if at(:NUMBER)
        m = next_token
        if at(:COMMA)
          expect(:COMMA)
          expect(:LSL)
          lsl = expect(:NUMBER)
          nm::ADDSUB_imm.new(d, n, m, lsl / 12, d.sf)
        else
          nm::ADDSUB_imm.new(d, n, m, 0, d.sf)
        end
      else
        m = next_token
        if at(:COMMA)
          expect(:COMMA)
          amount = 0

          if d.sp? || n.sp? || m.sp?
            modifier = next_token.to_sym
            if at(:NUMBER)
              amount = next_token
            end
            extend = m.x? ? Utils.sub_decode_extend64(modifier) : Utils.sub_decode_extend32(modifier)
            nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
          else
            modifier = next_token.to_sym

            case modifier
            when :uxtb, :uxth, :uxtw, :uxtx, :sxtb, :sxth, :sxtw, :sxtx
              # extend
              if at(:NUMBER)
                amount = next_token
              end
              extend = Utils.sub_decode_extend32(modifier)
              nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
            when :lsl, :lsr, :asr
              shift = [:lsl, :lsr, :asr].index(modifier)

              amount = 0
              # shift
              if at(:NUMBER)
                amount = next_token
              end
              nm::ADDSUB_shift.new(d, n, m, shift, amount, d.sf)
            end
          end
        else
          nm::ADDSUB_shift.new(d, n, m, 0, 0, d.sf)
        end
      end
    end

    def wd_wd_wd nm = nil
      w1 = expect_w
      expect(:COMMA)
      w2 = expect_w
      expect(:COMMA)
      w3 = expect_w
      if block_given?
        yield w1, w2, w3
        false
      else
        nm.new(w1, w2, w3, w1.sf)
      end
    end

    def xd_xd_xd nm
      x1 = expect_x
      expect(:COMMA)
      x2 = expect_x
      expect(:COMMA)
      x3 = expect_x
      nm.new(x1, x2, x3, x1.sf)
    end

    def expect tok
      unless @scan.peek&.first == tok
        string = @scan.string
        line_number = string.byteslice(0, @scan.pos).count("\n") + 1
        val = @scan.peek&.last
        name = @scan.peek&.first
        raise AArch64::ParseError, "parse error on value #{val.inspect} (#{name}) on line #{line_number} at pos #{@scan.pos}/#{string.bytesize}"
      end
      next_token
    end

    def expect_any toks
      tok = @scan.peek.first
      unless toks.include?(tok)
        p @scan.peek
        raise
      end
      next_token
    end

    def at_any toks
      tok = @scan.peek.first
      toks.include?(tok)
    end

    def expect_w
      raise if @scan.peek.last.x?
      next_token
    end

    def expect_x
      raise unless @scan.peek.last.x?
      next_token
    end

    def expect_reg
      raise unless @scan.peek.last.register?
      next_token
    end

    def at tok
      @scan.peek.first == tok
    end

    def next_token
      @scan.next_token.last
    end

    def get_label name
      @labels[name] ||= @asm.make_label(name)
    end

    # "same reg type"
    def srt n
      n.x? ? expect_x : expect_w
    end

    def comma
      expect :COMMA
    end

    def extend
      expect_any([:UXTB, :UXTH, :UXTW, :UXTX, :SXTB, :SXTH, :SXTW, :SXTX]).to_sym
    end

    def at_extend
      at_any([:UXTB, :UXTH, :UXTW, :UXTX, :SXTB, :SXTH, :SXTW, :SXTX])
    end
  end
end
