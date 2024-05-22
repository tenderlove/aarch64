module AArch64
  module Instructions
    module SUBS
      autoload :ADDSUB_ext, "aarch64/instructions/subs/addsub_ext"
      autoload :ADDSUB_imm, "aarch64/instructions/subs/addsub_imm"
      autoload :ADDSUB_shift, "aarch64/instructions/subs/addsub_shift"
    end
  end
end
