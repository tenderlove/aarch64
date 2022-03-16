# AArch64

This is a pure Ruby ARM64 assembler.  Are you tired of writing Ruby in Ruby?
Now you can write ARM64 assembly in Ruby with this gem!

## Example

```ruby
require "aarch64"
require "jit_buffer"

# create a JIT buffer
jit_buffer = JITBuffer.new 4096

# Make some instructions
asm = AArch64::Assembler.new
asm.movz AArch64::Registers::X0, 42
asm.ret

# Write the instructions to a JIT buffer
jit_buffer.writable!
asm.write_to jit_buffer
jit_buffer.executable!

# Execute the JIT buffer
p jit_buffer.to_function([], Fiddle::TYPE_INT).call # => 42
```
