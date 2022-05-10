# AArch64

This is a pure Ruby ARM64 assembler.  Are you tired of writing Ruby in Ruby?
Now you can write ARM64 assembly in Ruby with this gem!

## Example

This example uses the DSL methods.  The DSL methods make accessing the
registers, shifts, and options a little more easy.

```ruby
require "aarch64"
require "jit_buffer"

# create a JIT buffer
jit_buffer = JITBuffer.new 4096

asm = AArch64::Assembler.new

# Make some instructions
asm.pretty do
  asm.movz x0, 0xCAFE
  asm.movk x0, 0xF00D, lsl(16)
  asm.ret
end

# Write the instructions to a JIT buffer
jit_buffer.writeable!
asm.write_to jit_buffer
jit_buffer.executable!

# Execute the JIT buffer
p jit_buffer.to_function([], -Fiddle::TYPE_INT).call.to_s(16) # => f00dcafe
```

The following is the same example, but without the DSL.  The main difference is
that you must access registers via the constant names.

```ruby
require "aarch64"
require "jit_buffer"

# create a JIT buffer
jit_buffer = JITBuffer.new 4096
asm = AArch64::Assembler.new

# Make some instructions
asm.movz AArch64::Registers::X0, 0xCAFE
asm.movk AArch64::Registers::X0, 0xF00D, lsl: 16
asm.ret

# Write the instructions to a JIT buffer
jit_buffer.writable!
asm.write_to jit_buffer
jit_buffer.executable!

# Execute the JIT buffer
p jit_buffer.to_function([], -Fiddle::TYPE_INT).call.to_s(16) # => f00dcafe
```

You can include `AArch64::Registers` if you don't want to use the DSL, but
want easier access to the registers.  For example:

```ruby
include AArch64::Registers

asm = AArch64::Assembler.new
asm.movz X0, 0xCAFE
asm.movk X0, 0xF00D, lsl: 16
asm.ret
```

## Hacking / Contributing

Hacking on this gem should be similar to most.  Just do:

```
$ gel install
$ gel exec rake test
```
