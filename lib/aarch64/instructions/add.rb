module AArch64
  module Instructions
    module ADD
      autoload :ADDSUB_ext, "aarch64/instructions/add/addsub_ext"
      autoload :ADDSUB_imm, "aarch64/instructions/add/addsub_imm"
      autoload :ADDSUB_shift, "aarch64/instructions/add/addsub_shift"
    end
  end
end
