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
          raise NotImplementedError
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
      expect("#")
      imm6 = next_token
      expect(:COMMA)
      expect("#")
      imm4 = next_token
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

      m = if at("#")
        expect("#")
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
        label = if at("#")
          expect "#"
          next_token
        else
          label_name = next_token
          @labels[label_name] ||= @asm.make_label(label_name)
        end
      else
        label = if at("#")
          expect "#"
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
      val = if at("#")
        expect "#"
        next_token
      else
        raise NotImplementedError
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
      expect "#"
      @asm.brk(next_token)
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
      if at("#")
        expect "#"
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

    def reg_reg
      d = next_token
      comma
      n = srt d
      yield d, n
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

    def cond
      expect_any([:EQ, :LO, :LT, :HS, :GT, :LE, :NE, :MI, :GE, :PL, :LS,
        :HI, :VC, :VS]).to_sym
    end

    def reg_imm_or_label
      rt = next_token
      comma
      where = if at("#")
        expect "#"
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
        expect "#"
        amount = next_token
      end

      shift = [:lsl, :lsr, :asr, :ror].index(shift)
      nm.new(d, n, m, shift, amount, d.sf)
    end

    def bfi_body
      d = next_token
      comma
      n = d.x? ? expect_x : expect_w
      comma
      expect '#'
      lsb = next_token
      comma
      expect '#'
      width = next_token
      yield d, n, lsb, width
    end

    def and_body nm
      d = next_token
      expect(:COMMA)
      n = d.x? ? expect_x : expect_w
      expect(:COMMA)

      if at("#")
        expect("#")
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
          if at("#")
            expect("#")
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
      label = if at("#")
        expect("#")
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
      if at("#")
        next_token
        m = next_token
        if at(:COMMA)
          expect(:COMMA)
          expect(:LSL)
          expect("#")
          lsl = next_token
          nm::ADDSUB_imm.new(d, n, m, lsl / 12, d.sf)
        else
          nm::ADDSUB_imm.new(d, n, m, 0, d.sf)
        end
      else
        m = next_token
        if at(:COMMA)
          expect(:COMMA)
          amount = 0

          if n.sp? || m.sp?
            modifier = next_token.to_sym
            if at("#")
              expect("#")
              amount = next_token
            end
            extend = Utils.sub_decode_extend32(modifier)
            nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
          else
            modifier = next_token.to_sym

            case modifier
            when :uxtb, :uxth, :uxtw, :uxtx, :sxtb, :sxth, :sxtw, :sxtx
              # extend
              if at("#")
                expect('#')
                amount = next_token
              end
              extend = Utils.sub_decode_extend32(modifier)
              nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
            when :lsl, :lsr, :asr
              shift = [:lsl, :lsr, :asr].index(modifier)

              amount = 0
              # shift
              if at("#")
                expect("#")
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

    def wd_wd_wd nm
      w1 = expect_w
      expect(:COMMA)
      w2 = expect_w
      expect(:COMMA)
      w3 = expect_w
      nm.new(w1, w2, w3, w1.sf)
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
      unless @scan.peek.first == tok
        p @scan.peek
        raise
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

    def expect_w
      raise if @scan.peek.last.x?
      next_token
    end

    def expect_x
      raise unless @scan.peek.last.x?
      next_token
    end

    def at tok
      @scan.peek.first == tok
    end

    def next_token
      @scan.next_token.last
    end

    def get_label name
      @labels[label_name] ||= @asm.make_label(label_name)
    end

    # "same reg type"
    def srt n
      n.x? ? expect_x : expect_w
    end

    def comma
      expect :COMMA
    end
  end
end
