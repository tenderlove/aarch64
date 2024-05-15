module AArch64
  module Instructions
    module ADDS
      autoload :ADDSUB_ext, "aarch64/instructions/adds/addsub_ext"
      autoload :ADDSUB_imm, "aarch64/instructions/adds/addsub_imm"
      autoload :ADDSUB_shift, "aarch64/instructions/adds/addsub_shift"
    end
  end
end
