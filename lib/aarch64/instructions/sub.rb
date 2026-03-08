module AArch64
  module Instructions
    module SUB
      autoload :ADDSUB_ext, "aarch64/instructions/sub/addsub_ext"
      autoload :ADDSUB_imm, "aarch64/instructions/sub/addsub_imm"
      autoload :ADDSUB_shift, "aarch64/instructions/sub/addsub_shift"
    end
  end
end
