# frozen_string_literal: true

module AArch64
  module Utils
    EncodedMask = Struct.new(:n, :immr, :imms)

    MAX_INT_64 = 0xFFFFFFFFFFFFFFFF

    COND_TABLE = {
      "EQ"  => 0b0000,
      "NE"  => 0b0001,
      "CS"  => 0b0010,
      "HS"  => 0b0010,
      "CC"  => 0b0011,
      "LO"  => 0b0011,
      "MI"  => 0b0100,
      "PL"  => 0b0101,
      "VS"  => 0b0110,
      "VC"  => 0b0111,
      "HI"  => 0b1000,
      "LS"  => 0b1001,
      "GE"  => 0b1010,
      "LT"  => 0b1011,
      "GT"  => 0b1100,
      "LE"  => 0b1101,
      "AL"  => 0b1110,
      "NVb" => 0b1111,
    }

    def cond2bin cond
      COND_TABLE.fetch(cond.to_s.upcase)
    end
    module_function :cond2bin

    def mask? num
      ((num + 1) & num) == 0
    end
    module_function :mask?

    def shifted_mask? num
      mask?((num - 1) | num)
    end
    module_function :shifted_mask?

    def count_trailing_zeros num
      count = 0
      loop do
        break if num & 1 == 1
        count += 1
        num >>= 1
      end

      count
    end
    module_function :count_trailing_zeros

    def count_trailing_ones num
      count = 0
      loop do
        break if num & 1 == 0
        count += 1
        num >>= 1
      end

      count
    end
    module_function :count_trailing_ones

    def count_leading_ones num
      count = 0
      top_bit = 1 << 63
      loop do
        break if num & top_bit != top_bit
        count += 1
        (num <<= 1) & MAX_INT_64
      end
      count
    end
    module_function :count_leading_ones

    def encode_mask imm, regsize
      size = regsize
      loop do
        size >>= 1
        mask = (1 << size) - 1
        if (imm & mask) != ((imm >> size) & mask)
          size <<= 1
          break
        end

        break unless size > 2
      end

      mask = (-1 & MAX_INT_64) >> (64 - size)
      imm &= mask

      if shifted_mask?(imm)
        i = count_trailing_zeros imm
        cto = count_trailing_ones(imm >> i)
      else
        imm |= ((~mask) & MAX_INT_64)
        unless shifted_mask?((~imm) & MAX_INT_64)
          return nil
        end

        clo = count_leading_ones(imm & MAX_INT_64)
        i = 64 - clo
        cto = clo + count_trailing_ones(imm) - (64 - size)
      end

      immr = (size - i) & (size - 1)
      imms = (~(size - 1) << 1) | (cto - 1)
      n    = ((imms >> 6) & 1) ^ 1

      EncodedMask.new(n, immr & 0x3F, imms & 0x3F)
    end
    module_function :encode_mask

    DC_OP = {
      # dc_op          op1,    CRm,    op2
      "IVAC"    => [0b0000, 0b0110, 0b0001],
      "ISW"     => [0b0000, 0b0110, 0b0010],
      "IGVAC"   => [0b0000, 0b0110, 0b0011],
      "IGSW"    => [0b0000, 0b0110, 0b0100],
      "IGDVAC"  => [0b0000, 0b0110, 0b0101],
      "IGDSW"   => [0b0000, 0b0110, 0b0110],
      "CSW"     => [0b0000, 0b1010, 0b0010],
      "CGSW"    => [0b0000, 0b1010, 0b0100],
      "CGDSW"   => [0b0000, 0b1010, 0b0110],
      "CISW"    => [0b0000, 0b1110, 0b0010],
      "CIGSW"   => [0b0000, 0b1110, 0b0100],
      "CIGDSW"  => [0b0000, 0b1110, 0b0110],
      "ZVA"     => [0b0011, 0b0100, 0b0001],
      "GVA"     => [0b0011, 0b0100, 0b0011],
      "GZVA"    => [0b0011, 0b0100, 0b0100],
      "CVAC"    => [0b0011, 0b1010, 0b0001],
      "CGVAC"   => [0b0011, 0b1010, 0b0011],
      "CGDVAC"  => [0b0011, 0b1010, 0b0101],
      "CVAU"    => [0b0011, 0b1011, 0b0001],
      "CVAP"    => [0b0011, 0b1100, 0b0001],
      "CGVAP"   => [0b0011, 0b1100, 0b0011],
      "CGDVAP"  => [0b0011, 0b1100, 0b0101],
      "CVADP"   => [0b0011, 0b1101, 0b0001],
      "CGVADP"  => [0b0011, 0b1101, 0b0011],
      "CGDVADP" => [0b0011, 0b1101, 0b0101],
      "CIVAC"   => [0b0011, 0b1110, 0b0001],
      "CIGVAC"  => [0b0011, 0b1110, 0b0011],
      "CIGDVAC" => [0b0011, 0b1110, 0b0101],
    }

    def dc_op v
      DC_OP.fetch(v.to_s.upcase)
    end
    module_function :dc_op

    DMB_OPTIONS = {
      "oshld" => 0b0001,
      "oshst" => 0b0010,
      "osh"   => 0b0011,
      "nshld" => 0b0101,
      "nshst" => 0b0110,
      "nsh"   => 0b0111,
      "ishld" => 0b1001,
      "ishst" => 0b1010,
      "ish"   => 0b1011,
      "ld"    => 0b1101,
      "st"    => 0b1110,
      "sy"    => 0b1111,
    }

    def dmb2imm option
      DMB_OPTIONS.fetch(option.to_s.downcase)
    end
    module_function :dmb2imm

    IC_OPTIONS = {
      #               op1,    CRm,  op2
      "ialluis" => [0b000, 0b0001, 0b00],
      "iallu"   => [0b000, 0b0101, 0b00],
      "ivau"    => [0b011, 0b0101, 0b01],
    }

    def ic_op name
      IC_OPTIONS.fetch(name.to_s.downcase)
    end
    module_function :ic_op

    TLBI_OPTIONS = {
      #                     op1,    CRm,    op2,
      "VMALLE1OS"    => [0b0000, 0b0001, 0b0000],
      "VAE1OS"       => [0b0000, 0b0001, 0b0001],
      "ASIDE1OS"     => [0b0000, 0b0001, 0b0010],
      "VAAE1OS"      => [0b0000, 0b0001, 0b0011],
      "VALE1OS"      => [0b0000, 0b0001, 0b0101],
      "VAALE1OS"     => [0b0000, 0b0001, 0b0111],
      "RVAE1IS"      => [0b0000, 0b0010, 0b0001],
      "RVAAE1IS"     => [0b0000, 0b0010, 0b0011],
      "RVALE1IS"     => [0b0000, 0b0010, 0b0101],
      "RVAALE1IS"    => [0b0000, 0b0010, 0b0111],
      "VMALLE1IS"    => [0b0000, 0b0011, 0b0000],
      "VAE1IS"       => [0b0000, 0b0011, 0b0001],
      "ASIDE1IS"     => [0b0000, 0b0011, 0b0010],
      "VAAE1IS"      => [0b0000, 0b0011, 0b0011],
      "VALE1IS"      => [0b0000, 0b0011, 0b0101],
      "VAALE1IS"     => [0b0000, 0b0011, 0b0111],
      "RVAE1OS"      => [0b0000, 0b0101, 0b0001],
      "RVAAE1OS"     => [0b0000, 0b0101, 0b0011],
      "RVALE1OS"     => [0b0000, 0b0101, 0b0101],
      "RVAALE1OS"    => [0b0000, 0b0101, 0b0111],
      "RVAE1"        => [0b0000, 0b0110, 0b0001],
      "RVAAE1"       => [0b0000, 0b0110, 0b0011],
      "RVALE1"       => [0b0000, 0b0110, 0b0101],
      "RVAALE1"      => [0b0000, 0b0110, 0b0111],
      "VMALLE1"      => [0b0000, 0b0111, 0b0000],
      "VAE1"         => [0b0000, 0b0111, 0b0001],
      "ASIDE1"       => [0b0000, 0b0111, 0b0010],
      "VAAE1"        => [0b0000, 0b0111, 0b0011],
      "VALE1"        => [0b0000, 0b0111, 0b0101],
      "VAALE1"       => [0b0000, 0b0111, 0b0111],
      "IPAS2E1IS"    => [0b0100, 0b0000, 0b0001],
      "RIPAS2E1IS"   => [0b0100, 0b0000, 0b0010],
      "IPAS2LE1IS"   => [0b0100, 0b0000, 0b0101],
      "RIPAS2LE1IS"  => [0b0100, 0b0000, 0b0110],
      "ALLE2OS"      => [0b0100, 0b0001, 0b0000],
      "VAE2OS"       => [0b0100, 0b0001, 0b0001],
      "ALLE1OS"      => [0b0100, 0b0001, 0b0100],
      "VALE2OS"      => [0b0100, 0b0001, 0b0101],
      "VMALLS12E1OS" => [0b0100, 0b0001, 0b0110],
      "RVAE2IS"      => [0b0100, 0b0010, 0b0001],
      "RVALE2IS"     => [0b0100, 0b0010, 0b0101],
      "ALLE2IS"      => [0b0100, 0b0011, 0b0000],
      "VAE2IS"       => [0b0100, 0b0011, 0b0001],
      "ALLE1IS"      => [0b0100, 0b0011, 0b0100],
      "VALE2IS"      => [0b0100, 0b0011, 0b0101],
      "VMALLS12E1IS" => [0b0100, 0b0011, 0b0110],
      "IPAS2E1OS"    => [0b0100, 0b0100, 0b0000],
      "IPAS2E1"      => [0b0100, 0b0100, 0b0001],
      "RIPAS2E1"     => [0b0100, 0b0100, 0b0010],
      "RIPAS2E1OS"   => [0b0100, 0b0100, 0b0011],
      "IPAS2LE1OS"   => [0b0100, 0b0100, 0b0100],
      "IPAS2LE1"     => [0b0100, 0b0100, 0b0101],
      "RIPAS2LE1"    => [0b0100, 0b0100, 0b0110],
      "RIPAS2LE1OS"  => [0b0100, 0b0100, 0b0111],
      "RVAE2OS"      => [0b0100, 0b0101, 0b0001],
      "RVALE2OS"     => [0b0100, 0b0101, 0b0101],
      "RVAE2"        => [0b0100, 0b0110, 0b0001],
      "RVALE2"       => [0b0100, 0b0110, 0b0101],
      "ALLE2"        => [0b0100, 0b0111, 0b0000],
      "VAE2"         => [0b0100, 0b0111, 0b0001],
      "ALLE1"        => [0b0100, 0b0111, 0b0100],
      "VALE2"        => [0b0100, 0b0111, 0b0101],
      "VMALLS12E1"   => [0b0100, 0b0111, 0b0110],
      "ALLE3OS"      => [0b0110, 0b0001, 0b0000],
      "VAE3OS"       => [0b0110, 0b0001, 0b0001],
      "VALE3OS"      => [0b0110, 0b0001, 0b0101],
      "RVAE3IS"      => [0b0110, 0b0010, 0b0001],
      "RVALE3IS"     => [0b0110, 0b0010, 0b0101],
      "ALLE3IS"      => [0b0110, 0b0011, 0b0000],
      "VAE3IS"       => [0b0110, 0b0011, 0b0001],
      "VALE3IS"      => [0b0110, 0b0011, 0b0101],
      "RVAE3OS"      => [0b0110, 0b0101, 0b0001],
      "RVALE3OS"     => [0b0110, 0b0101, 0b0101],
      "RVAE3"        => [0b0110, 0b0110, 0b0001],
      "RVALE3"       => [0b0110, 0b0110, 0b0101],
      "ALLE3"        => [0b0110, 0b0111, 0b0000],
      "VAE3"         => [0b0110, 0b0111, 0b0001],
      "VALE3"        => [0b0110, 0b0111, 0b0101],
    }
    def tlbi_op name
      TLBI_OPTIONS.fetch(name.to_s.upcase)
    end
    module_function :tlbi_op

    def prfop sym
      if sym.to_s =~ /^(\w{3})(\w\w)(\w{4})$/
        x = case $1
            when "pld" then (0b00 << 3)
            when "pli" then (0b01 << 3)
            when "pst" then (0b10 << 3)
            else
              raise "unknown key #{$1}"
            end
        y = case $2
            when "l1" then (0b00 << 1)
            when "l2" then (0b01 << 1)
            when "l3" then (0b10 << 1)
            else
              raise "unknown key #{$2}"
            end
        z = case $3
            when "keep" then 0b0
            when "strm" then 0b1
            else
              raise "unknown key #{$3}"
            end
        x | y | z
      else
        raise ArgumentError, sym.to_s
      end
    end
    module_function :prfop

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

    def at_op at_op
      AT_TABLE.fetch at_op
    end
    module_function :at_op
  end
end
