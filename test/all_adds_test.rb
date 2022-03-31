require "helper"

class AllADDSTest < AArch64::Test
  include AArch64
  include AArch64::Registers
  include AArch64::Conditions
  include AArch64::Extends
  include AArch64::Shifts

  def test_all_adds
    assert_bytes [0x82,0x08,0x25,0xab] do |asm|
      asm.adds     x2, x4, w5, uxtb(2)
    end
    assert_bytes [0xf4,0x33,0x33,0xab] do |asm|
      asm.adds     x20, sp, w19, uxth(4)
    end
    assert_bytes [0x2c,0x40,0x34,0xab] do |asm|
      asm.adds     x12, x1, w20, uxtw
    end
    assert_bytes [0x74,0x60,0x2d,0xab] do |asm|
      asm.adds     x20, x3, x13, uxtx
    end
    assert_bytes [0xf2,0xa3,0x33,0xab] do |asm|
      asm.adds     x18, sp, w19, sxth
    end
    assert_bytes [0xa3,0xe8,0x29,0xab] do |asm|
      asm.adds     x3, x5, x9, sxtx(2)
    end
    assert_bytes [0xa2,0x00,0x27,0x2b] do |asm|
      asm.adds     w2, w5, w7, uxtb
    end
    assert_bytes [0xf5,0x21,0x31,0x2b] do |asm|
      asm.adds     w21, w15, w17, uxth
    end
    assert_bytes [0xbe,0x43,0x3f,0x2b] do |asm|
      asm.adds     w30, w29, wzr, uxtw
    end
    assert_bytes [0x33,0x62,0x21,0x2b] do |asm|
      asm.adds     w19, w17, w1, uxtx
    end
    assert_bytes [0xa2,0x84,0x21,0x2b] do |asm|
      asm.adds     w2, w5, w1, sxtb(1)
    end
    assert_bytes [0xfa,0xa3,0x33,0x2b] do |asm|
      asm.adds     w26, wsp, w19, sxth
    end
    assert_bytes [0x62,0xe0,0x25,0x2b] do |asm|
      asm.adds     w2, w3, w5, sxtx
    end
    assert_bytes [0xed,0x8e,0x44,0x31] do |asm|
      asm.adds     w13, w23, 291, lsl(12)
    end
    assert_bytes [0xf4,0x03,0x00,0x31] do |asm|
      asm.adds     w20, wsp, 0
    end
    assert_bytes [0xa3,0x00,0x07,0x2b] do |asm|
      asm.adds     w3, w5, w7
    end
    assert_bytes [0xf4,0x03,0x04,0x2b] do |asm|
      asm.adds     w20, wzr, w4
    end
    assert_bytes [0xc4,0x00,0x1f,0x2b] do |asm|
      asm.adds     w4, w6, wzr
    end
    assert_bytes [0xab,0x01,0x0f,0x2b] do |asm|
      asm.adds     w11, w13, w15
    end
    assert_bytes [0x69,0x28,0x1f,0x2b] do |asm|
      asm.adds     w9, w3, wzr, lsl(10)
    end
    assert_bytes [0xb1,0x7f,0x14,0x2b] do |asm|
      asm.adds     w17, w29, w20, lsl(31)
    end
    assert_bytes [0xd5,0x02,0x57,0x2b] do |asm|
      asm.adds     w21, w22, w23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0x2b] do |asm|
      asm.adds     w24, w25, w26, lsr(18)
    end
    assert_bytes [0x9b,0x7f,0x5d,0x2b] do |asm|
      asm.adds     w27, w28, w29, lsr(31)
    end
    assert_bytes [0x62,0x00,0x84,0x2b] do |asm|
      asm.adds     w2, w3, w4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0x2b] do |asm|
      asm.adds     w5, w6, w7, asr(21)
    end
    assert_bytes [0x28,0x7d,0x8a,0x2b] do |asm|
      asm.adds     w8, w9, w10, asr(31)
    end
    assert_bytes [0xa3,0x00,0x07,0xab] do |asm|
      asm.adds     x3, x5, x7
    end
    assert_bytes [0xf4,0x03,0x04,0xab] do |asm|
      asm.adds     x20, xzr, x4
    end
    assert_bytes [0xc4,0x00,0x1f,0xab] do |asm|
      asm.adds     x4, x6, xzr
    end
    assert_bytes [0xab,0x01,0x0f,0xab] do |asm|
      asm.adds     x11, x13, x15
    end
    assert_bytes [0x69,0x28,0x1f,0xab] do |asm|
      asm.adds     x9, x3, xzr, lsl(10)
    end
    assert_bytes [0xb1,0xff,0x14,0xab] do |asm|
      asm.adds     x17, x29, x20, lsl(63)
    end
    assert_bytes [0xd5,0x02,0x57,0xab] do |asm|
      asm.adds     x21, x22, x23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0xab] do |asm|
      asm.adds     x24, x25, x26, lsr(18)
    end
    assert_bytes [0x9b,0xff,0x5d,0xab] do |asm|
      asm.adds     x27, x28, x29, lsr(63)
    end
    assert_bytes [0x62,0x00,0x84,0xab] do |asm|
      asm.adds     x2, x3, x4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0xab] do |asm|
      asm.adds     x5, x6, x7, asr(21)
    end
    assert_bytes [0x28,0xfd,0x8a,0xab] do |asm|
      asm.adds     x8, x9, x10, asr(63)
    end
  end
end
