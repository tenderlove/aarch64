# frozen_string_literal: true

require "strscan"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64/parser.tab"
require "aarch64"

module AArch64
  class Parser < Racc::Parser
    class RegsWithShift
      attr_reader :d, :n, :m, :shift, :amount

      def initialize d, n, m, shift: :lsl, amount: 0
        @d      = d
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, n, m, shift: shift, amount: amount)
      end
    end

    class RegRegShift
      attr_reader :d, :m, :shift, :amount

      def initialize d, m, shift: :lsl, amount: 0
        @d      = d
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, m, shift: shift, amount: amount)
      end
    end

    class TwoWithExtend
      attr_reader :n, :m, :extend, :amount

      def initialize n, m, extend:, amount:
        @n      = n
        @m      = m
        @extend = extend
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, n, m, extend: extend, amount: amount)
      end
    end

    class TwoWithShift
      attr_reader :n, :m, :shift, :amount

      def initialize n, m, shift:, amount:
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, n, m, shift: shift, amount: amount)
      end
    end

    class TwoWithLsl
      attr_reader :n, :m, :lsl

      def initialize n, m, lsl:
        @n   = n
        @m   = m
        @lsl = lsl
      end

      def apply asm, name
        asm.public_send(name, n, m, lsl: lsl)
      end
    end

    class ThreeWithLsl
      attr_reader :d, :n, :m, :lsl

      def initialize d, n, m, lsl:
        @d   = d
        @n   = n
        @m   = m
        @lsl = lsl
      end

      def apply asm, name
        asm.public_send(name, d, n, m, lsl: lsl)
      end
    end

    class TwoArg
      attr_reader :n, :m

      def initialize n, m
        @n = n
        @m = m
      end

      def apply asm, name
        asm.public_send(name, n, m)
      end

      def to_a; [n, m]; end
    end

    class ThreeArg
      attr_reader :d, :n, :m

      def initialize d, n, m
        @d = d
        @n = n
        @m = m
      end

      def apply asm, name
        asm.public_send(name, d, n, m)
      end

      def to_a; [d, n, m]; end
    end

    class ThreeWithExtend
      attr_reader :d, :n, :m, :extend, :amount

      def initialize d, n, m, extend:, amount:
        @d      = d
        @n      = n
        @m      = m
        @extend = extend
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, n, m, extend: extend, amount: amount)
      end
    end

    class FourArg < ClassGen.pos(:a, :b, :c, :d)
      def apply asm, name
        asm.public_send(name, a, b, c, d)
      end
    end

    def parse str
      str += "\n" unless str.end_with?("\n")
      parse_states = [
        # First pass: Label parsing
        :first_pass,
        # Second pass: Code generation
        :second_pass
      ]
      @labels = {}
      parse_states.each do |state|
        @scan = StringScanner.new str
        @asm  = AArch64::Assembler.new
        @state = state
        do_parse
      end

      @asm
    end

    def next_token
      _next_token
    end

    SYS_REG_SCAN = Regexp.new(AArch64::SystemRegisters.constants.join("|"), true)
    SYS_REG_MAP = Hash[AArch64::SystemRegisters.constants.map { |k|
      [k.to_s.downcase, AArch64::SystemRegisters.const_get(k)]
    }]
    # Created with: puts File.read('./lib/aarch64/parser.y').scan(/\b[A-Z][A-Z\d]+\b/).sort.uniq - ['LABEL', 'LABEL_CREATE']
    KEYWORDS = %w[
      ADC
      ADCS
      ADD
      ADDS
      ADR
      ADRP
      ALLE1
      ALLE1IS
      ALLE1OS
      ALLE2
      ALLE2IS
      ALLE2OS
      ALLE3
      ALLE3IS
      ALLE3OS
      AND
      ANDS
      ASIDE1
      ASIDE1IS
      ASIDE1OS
      ASR
      AT
      AUTDA
      B
      BANG
      BFI
      BFXIL
      BIC
      BICS
      BL
      BLR
      BR
      BRK
      CBNZ
      CBZ
      CCMN
      CCMP
      CGDSW
      CGDVAC
      CGDVADP
      CGDVAP
      CGSW
      CGVAC
      CGVADP
      CGVAP
      CIGDSW
      CIGDVAC
      CIGSW
      CIGVAC
      CINC
      CINV
      CISW
      CIVAC
      CLREX
      CLS
      CLZ
      CMN
      CMP
      CNEG
      COMMA
      CRC32B
      CRC32CB
      CRC32CH
      CRC32CW
      CRC32CX
      CRC32H
      CRC32W
      CRC32X
      CSEL
      CSET
      CSETM
      CSINC
      CSINV
      CSNEG
      CSW
      CVAC
      CVADP
      CVAP
      CVAU
      DC
      DCPS1
      DCPS2
      DCPS3
      DMB
      DOT
      DRPS
      DSB
      EOL
      EON
      EOR
      EQ
      ERET
      EXTR
      GE
      GT
      GVA
      GZVA
      HI
      HINT
      HLT
      HS
      HVC
      IALLU
      IALLUIS
      IC
      IGDSW
      IGDVAC
      IGSW
      IGVAC
      IPAS2E1
      IPAS2E1IS
      IPAS2E1OS
      IPAS2LE1
      IPAS2LE1IS
      IPAS2LE1OS
      ISB
      ISH
      ISHLD
      ISHST
      ISW
      IVAC
      IVAU
      LD
      LDAR
      LDARB
      LDARH
      LDAXP
      LDAXR
      LDAXRB
      LDAXRH
      LDNP
      LDP
      LDPSW
      LDR
      LDRB
      LDRH
      LDRSB
      LDRSH
      LDRSW
      LDTR
      LDTRB
      LDTRH
      LDTRSB
      LDTRSH
      LDTRSW
      LDUR
      LDURB
      LDURH
      LDURSB
      LDURSH
      LDURSW
      LDXP
      LDXR
      LDXRB
      LDXRH
      LE
      LO
      LS
      LSL
      LSQ
      LSR
      LT
      MADD
      MI
      MNEG
      MOV
      MOVK
      MOVN
      MOVZ
      MRS
      MSR
      MSUB
      MUL
      MVN
      NE
      NEG
      NEGS
      NGC
      NGCS
      NOP
      NSH
      NSHLD
      NSHST
      NUMBER
      ORN
      ORR
      OSH
      OSHLD
      OSHST
      PL
      PRFM
      PRFOP
      PRFUM
      PSSBB
      RBIT
      RET
      REV
      REV16
      REV32
      RIPAS2E1
      RIPAS2E1IS
      RIPAS2E1OS
      RIPAS2LE1
      RIPAS2LE1IS
      RIPAS2LE1OS
      ROR
      RSQ
      RVAAE1
      RVAAE1IS
      RVAAE1OS
      RVAALE1
      RVAALE1IS
      RVAALE1OS
      RVAE1
      RVAE1IS
      RVAE1OS
      RVAE2
      RVAE2IS
      RVAE2OS
      RVAE3
      RVAE3IS
      RVAE3OS
      RVALE1
      RVALE1IS
      RVALE1OS
      RVALE2
      RVALE2IS
      RVALE2OS
      RVALE3
      RVALE3IS
      RVALE3OS
      S12E0R
      S12E0W
      S12E1R
      S12E1W
      S1E0R
      S1E0W
      S1E1R
      S1E1RP
      S1E1W
      S1E1WP
      S1E2R
      S1E2W
      S1E3R
      S1E3W
      SBC
      SBCS
      SBFIZ
      SBFX
      SDIV
      SEV
      SEVL
      SMADDL
      SMC
      SMNEGL
      SMSUBL
      SMULH
      SMULL
      SP
      SSBB
      ST
      STLR
      STLRB
      STLRH
      STLXP
      STLXR
      STLXRB
      STLXRH
      STNP
      STP
      STR
      STRB
      STRH
      STTR
      STTRB
      STTRH
      STUR
      STURB
      STURH
      STXP
      STXR
      STXRB
      STXRH
      SUB
      SUBS
      SVC
      SXTB
      SXTH
      SXTW
      SXTX
      SY
      SYS
      SYSL
      SYSTEMREG
      TBNZ
      TBZ
      TLBI
      TST
      UBFIZ
      UBFX
      UDIV
      UMADDL
      UMNEGL
      UMSUBL
      UMULH
      UMULL
      UXTB
      UXTH
      UXTW
      UXTX
      VAAE1
      VAAE1IS
      VAAE1OS
      VAALE1
      VAALE1IS
      VAALE1OS
      VAE1
      VAE1IS
      VAE1OS
      VAE2
      VAE2IS
      VAE2OS
      VAE3
      VAE3IS
      VAE3OS
      VALE1
      VALE1IS
      VALE1OS
      VALE2
      VALE2IS
      VALE2OS
      VALE3
      VALE3IS
      VALE3OS
      VC
      VMALLE1
      VMALLE1IS
      VMALLE1OS
      VMALLS12E1
      VMALLS12E1IS
      VMALLS12E1OS
      VS
      WFE
      WFI
      WSP
      XZR
      YIELD
      ZVA
    ].freeze
    KEYWORDS_SCAN = /(#{Regexp.union(KEYWORDS.sort).source})\b/i
    LABEL_SCAN = /[a-zA-Z_]\w+/
    LABEL_CREATE_SCAN = /#{LABEL_SCAN}:/

    def register_label str
      return unless @state == :first_pass

      if @labels.include?(str)
        raise "symbol '#{str}' is already defined"
      end

      label = @asm.make_label(str)
      @asm.put_label(label)
      @labels[str] = label

      nil
    end

    def label_for str
      # In the first pass, all valid labels are not known yet i.e. forward references
      # Return a placeholder value instead.
      if @state == :first_pass
        @asm.make_label(str)
      else
        raise("Label #{str.inspect} not defined") unless @labels.key?(str)
        @labels[str]
      end
    end

    def _next_token
      return _next_token if @scan.scan(/[\t ]+/) # skip whitespace
      return if @scan.eos?

      if str = @scan.scan(/\n/)
        return [:EOL, :EOL]
      elsif str = @scan.scan(LABEL_CREATE_SCAN)
        [:LABEL_CREATE, str[0...-1]]
      elsif str = @scan.scan(/x\d+/i)
        [:Xd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/w\d+/i)
        [:Wd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/c\d+/i)
        [:Cd, AArch64::Names.const_get(str.upcase)]
      elsif str = @scan.scan(/sp/i)
        [:SP, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/xzr/i)
        [:Xd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/wzr/i)
        [:Wd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/wsp/i)
        [:WSP, AArch64::Registers.const_get(str.upcase)]
      elsif @scan.scan(/,/)
        [:COMMA, ","]
      elsif @scan.scan(/\./)
        [:DOT, "."]
      elsif @scan.scan(/\[/)
        [:LSQ, "["]
      elsif @scan.scan(/\]/)
        [:RSQ, "]"]
      elsif @scan.scan(/!/)
        [:BANG, "!"]
      elsif str = @scan.scan(/(?:pld|pli|pst)(?:l1|l2|l3)(?:keep|strm)/)
        [:PRFOP, str]
      elsif str = @scan.scan(/-?0x[0-9A-F]+/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/-?(?:0|[1-9][0-9]*)/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/LSL/i)
        [:LSL, str]
      elsif str = @scan.scan(/#/)
        ["#", "#"]
      elsif str = @scan.scan(/s\d_\d_c\d+_c\d+_\d/i)
        if str =~ /s(\d)_(\d)_(c\d+)_(c\d+)_(\d)/i
          [:SYSTEMREG, SystemRegisters::MRS_MSR_64.new($1.to_i,
                                                       $2.to_i,
                                                       Names.const_get($3.upcase),
                                                       Names.const_get($4.upcase),
                                                       $5.to_i)]
        else
          raise
        end
      elsif str = @scan.scan(SYS_REG_SCAN)
        [:SYSTEMREG, SYS_REG_MAP[str.downcase]]
      elsif str = @scan.scan(KEYWORDS_SCAN)
        [str.upcase.to_sym, str]
      elsif str = @scan.scan(LABEL_SCAN)
        [:LABEL, str]
      else
        [:UNKNOWN_CHAR, @scan.getch]
      end
    end

    def on_error(token_id, val, vstack)
      token_str = token_to_str(token_id) || '?'
      string = @scan.string
      line_number = string.byteslice(0, @scan.pos).count("\n") + 1
      raise ParseError, "parse error on value #{val.inspect} (#{token_str}) on line #{line_number} at pos #{@scan.pos}/#{string.bytesize}"
    end
  end
end
