module AArch64
  module Instructions
    autoload :ADC, "aarch64/instructions/adc"
    autoload :ADCS, "aarch64/instructions/adcs"
    autoload :ADD_addsub_ext, "aarch64/instructions/add_addsub_ext"
    autoload :ADD_addsub_imm, "aarch64/instructions/add_addsub_imm"
    autoload :ADD_addsub_shift, "aarch64/instructions/add_addsub_shift"
    autoload :ADDG, "aarch64/instructions/addg"
    autoload :ADDS_addsub_ext, "aarch64/instructions/adds_addsub_ext"
    autoload :ADDS_addsub_imm, "aarch64/instructions/adds_addsub_imm"
    autoload :ADDS_addsub_shift, "aarch64/instructions/adds_addsub_shift"
    autoload :ADR, "aarch64/instructions/adr"
    autoload :ADRP, "aarch64/instructions/adrp"
    autoload :AND_log_imm, "aarch64/instructions/and_log_imm"
    autoload :AND_log_shift, "aarch64/instructions/and_log_shift"
    autoload :ANDS_log_imm, "aarch64/instructions/ands_log_imm"
    autoload :ANDS_log_shift, "aarch64/instructions/ands_log_shift"
    autoload :ASR_SBFM, "aarch64/instructions/asr_sbfm"
    autoload :ASR_ASRV, "aarch64/instructions/asr_asrv"
    autoload :ASRV, "aarch64/instructions/asrv"
    autoload :AT_SYS, "aarch64/instructions/at_sys"
    autoload :AUTDA, "aarch64/instructions/autda"
    autoload :AUTDB, "aarch64/instructions/autdb"
    autoload :AUTIA, "aarch64/instructions/autia"
    autoload :AUTIB, "aarch64/instructions/autib"
    autoload :AXFLAG, "aarch64/instructions/axflag"
    autoload :B_uncond, "aarch64/instructions/b_uncond"
    autoload :B_cond, "aarch64/instructions/b_cond"
    autoload :BC_cond, "aarch64/instructions/bc_cond"
    autoload :BFC_BFM, "aarch64/instructions/bfc_bfm"
    autoload :BFI_BFM, "aarch64/instructions/bfi_bfm"
    autoload :BFM, "aarch64/instructions/bfm"
    autoload :BFXIL_BFM, "aarch64/instructions/bfxil_bfm"
    autoload :BIC_log_shift, "aarch64/instructions/bic_log_shift"
    autoload :BICS, "aarch64/instructions/bics"
    autoload :BL, "aarch64/instructions/bl"
    autoload :BLR, "aarch64/instructions/blr"
    autoload :BLRA, "aarch64/instructions/blra"
    autoload :BR, "aarch64/instructions/br"
    autoload :BRA, "aarch64/instructions/bra"
    autoload :BRK, "aarch64/instructions/brk"
    autoload :BTI, "aarch64/instructions/bti"
    autoload :CAS, "aarch64/instructions/cas"
    autoload :CASB, "aarch64/instructions/casb"
    autoload :CASH, "aarch64/instructions/cash"
    autoload :CASP, "aarch64/instructions/casp"
    autoload :CBNZ, "aarch64/instructions/cbnz"
    autoload :CBZ, "aarch64/instructions/cbz"
    autoload :CCMN_imm, "aarch64/instructions/ccmn_imm"
    autoload :CCMN_reg, "aarch64/instructions/ccmn_reg"
    autoload :CCMP_imm, "aarch64/instructions/ccmp_imm"
    autoload :CCMP_reg, "aarch64/instructions/ccmp_reg"
    autoload :CFINV, "aarch64/instructions/cfinv"
    autoload :CFP_SYS, "aarch64/instructions/cfp_sys"
    autoload :CLREX, "aarch64/instructions/clrex"
    autoload :CLS_int, "aarch64/instructions/cls_int"
    autoload :CLZ_int, "aarch64/instructions/clz_int"
    autoload :CRC32, "aarch64/instructions/crc32"
    autoload :CRC32C, "aarch64/instructions/crc32c"
    autoload :CSDB, "aarch64/instructions/csdb"
    autoload :CSEL, "aarch64/instructions/csel"
    autoload :CSINC, "aarch64/instructions/csinc"
    autoload :CSINV, "aarch64/instructions/csinv"
    autoload :CSNEG, "aarch64/instructions/csneg"
    autoload :DCPS, "aarch64/instructions/dcps"
    autoload :DGH, "aarch64/instructions/dgh"
    autoload :DMB, "aarch64/instructions/dmb"
    autoload :DRPS, "aarch64/instructions/drps"
    autoload :DSB, "aarch64/instructions/dsb"
    autoload :DVP_SYS, "aarch64/instructions/dvp_sys"
    autoload :EON, "aarch64/instructions/eon"
    autoload :EOR_log_imm, "aarch64/instructions/eor_log_imm"
    autoload :EOR_log_shift, "aarch64/instructions/eor_log_shift"
    autoload :ERET, "aarch64/instructions/eret"
    autoload :ERETA, "aarch64/instructions/ereta"
    autoload :ESB, "aarch64/instructions/esb"
    autoload :EXTR, "aarch64/instructions/extr"
    autoload :GMI, "aarch64/instructions/gmi"
    autoload :HINT, "aarch64/instructions/hint"
    autoload :HLT, "aarch64/instructions/hlt"
    autoload :HVC, "aarch64/instructions/hvc"
    autoload :IRG, "aarch64/instructions/irg"
    autoload :ISB, "aarch64/instructions/isb"
    autoload :LD64B, "aarch64/instructions/ld64b"
    autoload :LDADD, "aarch64/instructions/ldadd"
    autoload :LDADDB, "aarch64/instructions/ldaddb"
    autoload :LDADDH, "aarch64/instructions/ldaddh"
    autoload :LDAPR, "aarch64/instructions/ldapr"
    autoload :LDAPRB, "aarch64/instructions/ldaprb"
    autoload :LDAPRH, "aarch64/instructions/ldaprh"
    autoload :LDAPUR_gen, "aarch64/instructions/ldapur_gen"
    autoload :LDAPURB, "aarch64/instructions/ldapurb"
    autoload :LDAPURH, "aarch64/instructions/ldapurh"
    autoload :LDAPURSB, "aarch64/instructions/ldapursb"
    autoload :LDAPURSH, "aarch64/instructions/ldapursh"
    autoload :LDAPURSW, "aarch64/instructions/ldapursw"
    autoload :LDAR, "aarch64/instructions/ldar"
    autoload :LDARB, "aarch64/instructions/ldarb"
    autoload :LDARH, "aarch64/instructions/ldarh"
    autoload :LDAXP, "aarch64/instructions/ldaxp"
    autoload :LDAXR, "aarch64/instructions/ldaxr"
    autoload :LDAXRB, "aarch64/instructions/ldaxrb"
    autoload :LDAXRH, "aarch64/instructions/ldaxrh"
    autoload :LDCLR, "aarch64/instructions/ldclr"
    autoload :LDCLRB, "aarch64/instructions/ldclrb"
    autoload :LDCLRH, "aarch64/instructions/ldclrh"
    autoload :LDEOR, "aarch64/instructions/ldeor"
    autoload :LDEORB, "aarch64/instructions/ldeorb"
    autoload :LDEORH, "aarch64/instructions/ldeorh"
    autoload :LDG, "aarch64/instructions/ldg"
    autoload :LDGM, "aarch64/instructions/ldgm"
    autoload :LDLAR, "aarch64/instructions/ldlar"
    autoload :LDLARB, "aarch64/instructions/ldlarb"
    autoload :LDLARH, "aarch64/instructions/ldlarh"
    autoload :LDNP_gen, "aarch64/instructions/ldnp_gen"
    autoload :LDP_gen, "aarch64/instructions/ldp_gen"
    autoload :LDPSW, "aarch64/instructions/ldpsw"
    autoload :LDR_imm_gen, "aarch64/instructions/ldr_imm_gen"
    autoload :LDR_lit_gen, "aarch64/instructions/ldr_lit_gen"
    autoload :LDR_reg_gen, "aarch64/instructions/ldr_reg_gen"
    autoload :LDRA, "aarch64/instructions/ldra"
    autoload :LDRB_imm, "aarch64/instructions/ldrb_imm"
    autoload :LDRB_reg, "aarch64/instructions/ldrb_reg"
    autoload :LDRH_imm, "aarch64/instructions/ldrh_imm"
    autoload :LDRH_reg, "aarch64/instructions/ldrh_reg"
    autoload :LDRSB_imm, "aarch64/instructions/ldrsb_imm"
    autoload :LDRSB_reg, "aarch64/instructions/ldrsb_reg"
    autoload :LDRSH_imm, "aarch64/instructions/ldrsh_imm"
    autoload :LDRSH_reg, "aarch64/instructions/ldrsh_reg"
    autoload :LDRSW_imm, "aarch64/instructions/ldrsw_imm"
    autoload :LDRSW_lit, "aarch64/instructions/ldrsw_lit"
    autoload :LDRSW_reg, "aarch64/instructions/ldrsw_reg"
    autoload :LDSET, "aarch64/instructions/ldset"
    autoload :LDSETB, "aarch64/instructions/ldsetb"
    autoload :LDSETH, "aarch64/instructions/ldseth"
    autoload :LDSMAX, "aarch64/instructions/ldsmax"
    autoload :LDSMAXB, "aarch64/instructions/ldsmaxb"
    autoload :LDSMAXH, "aarch64/instructions/ldsmaxh"
    autoload :LDSMIN, "aarch64/instructions/ldsmin"
    autoload :LDSMINB, "aarch64/instructions/ldsminb"
    autoload :LDSMINH, "aarch64/instructions/ldsminh"
    autoload :LDTR, "aarch64/instructions/ldtr"
    autoload :LDTRB, "aarch64/instructions/ldtrb"
    autoload :LDTRH, "aarch64/instructions/ldtrh"
    autoload :LDTRSB, "aarch64/instructions/ldtrsb"
    autoload :LDTRSH, "aarch64/instructions/ldtrsh"
    autoload :LDTRSW, "aarch64/instructions/ldtrsw"
    autoload :LDUMAX, "aarch64/instructions/ldumax"
    autoload :LDUMAXB, "aarch64/instructions/ldumaxb"
    autoload :LDUMAXH, "aarch64/instructions/ldumaxh"
    autoload :LDUMIN, "aarch64/instructions/ldumin"
    autoload :LDUMINB, "aarch64/instructions/lduminb"
    autoload :LDUMINH, "aarch64/instructions/lduminh"
    autoload :LDUR_gen, "aarch64/instructions/ldur_gen"
    autoload :LDURB, "aarch64/instructions/ldurb"
    autoload :LDURH, "aarch64/instructions/ldurh"
    autoload :LDURSB, "aarch64/instructions/ldursb"
    autoload :LDURSH, "aarch64/instructions/ldursh"
    autoload :LDURSW, "aarch64/instructions/ldursw"
    autoload :LDXP, "aarch64/instructions/ldxp"
    autoload :LDXR, "aarch64/instructions/ldxr"
    autoload :LDXRB, "aarch64/instructions/ldxrb"
    autoload :LDXRH, "aarch64/instructions/ldxrh"
    autoload :LSL_UBFM, "aarch64/instructions/lsl_ubfm"
    autoload :LSL_LSLV, "aarch64/instructions/lsl_lslv"
    autoload :LSLV, "aarch64/instructions/lslv"
    autoload :LSR_UBFM, "aarch64/instructions/lsr_ubfm"
    autoload :LSR_LSRV, "aarch64/instructions/lsr_lsrv"
    autoload :LSRV, "aarch64/instructions/lsrv"
    autoload :MADD, "aarch64/instructions/madd"
    autoload :MNEG_MSUB, "aarch64/instructions/mneg_msub"
    autoload :MOV_ORR_log_imm, "aarch64/instructions/mov_orr_log_imm"
    autoload :MOV_MOVN, "aarch64/instructions/mov_movn"
    autoload :MOV_ORR_log_shift, "aarch64/instructions/mov_orr_log_shift"
    autoload :MOV_ADD_addsub_imm, "aarch64/instructions/mov_add_addsub_imm"
    autoload :MOV_MOVZ, "aarch64/instructions/mov_movz"
    autoload :MOVK, "aarch64/instructions/movk"
    autoload :MOVN, "aarch64/instructions/movn"
    autoload :MOVZ, "aarch64/instructions/movz"
    autoload :MRS, "aarch64/instructions/mrs"
    autoload :MSR_imm, "aarch64/instructions/msr_imm"
    autoload :MSR_reg, "aarch64/instructions/msr_reg"
    autoload :MSUB, "aarch64/instructions/msub"
    autoload :MUL_MADD, "aarch64/instructions/mul_madd"
    autoload :MVN_ORN_log_shift, "aarch64/instructions/mvn_orn_log_shift"
    autoload :NEG_SUB_addsub_shift, "aarch64/instructions/neg_sub_addsub_shift"
    autoload :NEGS_SUBS_addsub_shift, "aarch64/instructions/negs_subs_addsub_shift"
    autoload :NGC_SBC, "aarch64/instructions/ngc_sbc"
    autoload :NGCS_SBCS, "aarch64/instructions/ngcs_sbcs"
    autoload :NOP, "aarch64/instructions/nop"
    autoload :ORN_log_shift, "aarch64/instructions/orn_log_shift"
    autoload :ORR_log_imm, "aarch64/instructions/orr_log_imm"
    autoload :ORR_log_shift, "aarch64/instructions/orr_log_shift"
    autoload :PACDA, "aarch64/instructions/pacda"
    autoload :PACDB, "aarch64/instructions/pacdb"
    autoload :PACGA, "aarch64/instructions/pacga"
    autoload :PACIA, "aarch64/instructions/pacia"
    autoload :PACIB, "aarch64/instructions/pacib"
    autoload :PRFM_imm, "aarch64/instructions/prfm_imm"
    autoload :PRFM_lit, "aarch64/instructions/prfm_lit"
    autoload :PRFM_reg, "aarch64/instructions/prfm_reg"
    autoload :PRFUM, "aarch64/instructions/prfum"
    autoload :PSB, "aarch64/instructions/psb"
    autoload :PSSBB_DSB, "aarch64/instructions/pssbb_dsb"
    autoload :RBIT_int, "aarch64/instructions/rbit_int"
    autoload :RET, "aarch64/instructions/ret"
    autoload :RETA, "aarch64/instructions/reta"
    autoload :REV, "aarch64/instructions/rev"
    autoload :REV16_int, "aarch64/instructions/rev16_int"
    autoload :REV32_int, "aarch64/instructions/rev32_int"
    autoload :REV64_REV, "aarch64/instructions/rev64_rev"
    autoload :RMIF, "aarch64/instructions/rmif"
    autoload :ROR_EXTR, "aarch64/instructions/ror_extr"
    autoload :ROR_RORV, "aarch64/instructions/ror_rorv"
    autoload :RORV, "aarch64/instructions/rorv"
    autoload :SB, "aarch64/instructions/sb"
    autoload :SBC, "aarch64/instructions/sbc"
    autoload :SBCS, "aarch64/instructions/sbcs"
    autoload :SBFIZ_SBFM, "aarch64/instructions/sbfiz_sbfm"
    autoload :SBFM, "aarch64/instructions/sbfm"
    autoload :SBFX_SBFM, "aarch64/instructions/sbfx_sbfm"
    autoload :SDIV, "aarch64/instructions/sdiv"
    autoload :SETF, "aarch64/instructions/setf"
    autoload :SETGP, "aarch64/instructions/setgp"
    autoload :SETGPN, "aarch64/instructions/setgpn"
    autoload :SETGPT, "aarch64/instructions/setgpt"
    autoload :SETGPTN, "aarch64/instructions/setgptn"
    autoload :SETP, "aarch64/instructions/setp"
    autoload :SETPN, "aarch64/instructions/setpn"
    autoload :SETPT, "aarch64/instructions/setpt"
    autoload :SETPTN, "aarch64/instructions/setptn"
    autoload :SEV, "aarch64/instructions/sev"
    autoload :SEVL, "aarch64/instructions/sevl"
    autoload :SMADDL, "aarch64/instructions/smaddl"
    autoload :SMC, "aarch64/instructions/smc"
    autoload :SMNEGL_SMSUBL, "aarch64/instructions/smnegl_smsubl"
    autoload :SMSUBL, "aarch64/instructions/smsubl"
    autoload :SMULH, "aarch64/instructions/smulh"
    autoload :SMULL_SMADDL, "aarch64/instructions/smull_smaddl"
    autoload :SSBB_DSB, "aarch64/instructions/ssbb_dsb"
    autoload :ST2G, "aarch64/instructions/st2g"
    autoload :ST64B, "aarch64/instructions/st64b"
    autoload :ST64BV, "aarch64/instructions/st64bv"
    autoload :ST64BV0, "aarch64/instructions/st64bv0"
    autoload :STADD_LDADD, "aarch64/instructions/stadd_ldadd"
    autoload :STADDB_LDADDB, "aarch64/instructions/staddb_ldaddb"
    autoload :STADDH_LDADDH, "aarch64/instructions/staddh_ldaddh"
    autoload :STCLR_LDCLR, "aarch64/instructions/stclr_ldclr"
    autoload :STCLRB_LDCLRB, "aarch64/instructions/stclrb_ldclrb"
    autoload :STCLRH_LDCLRH, "aarch64/instructions/stclrh_ldclrh"
    autoload :STEOR_LDEOR, "aarch64/instructions/steor_ldeor"
    autoload :STEORB_LDEORB, "aarch64/instructions/steorb_ldeorb"
    autoload :STEORH_LDEORH, "aarch64/instructions/steorh_ldeorh"
    autoload :STG, "aarch64/instructions/stg"
    autoload :STGM, "aarch64/instructions/stgm"
    autoload :STGP, "aarch64/instructions/stgp"
    autoload :STLLR, "aarch64/instructions/stllr"
    autoload :STLLRB, "aarch64/instructions/stllrb"
    autoload :STLLRH, "aarch64/instructions/stllrh"
    autoload :STLR, "aarch64/instructions/stlr"
    autoload :STLRB, "aarch64/instructions/stlrb"
    autoload :STLRH, "aarch64/instructions/stlrh"
    autoload :STLUR_gen, "aarch64/instructions/stlur_gen"
    autoload :STLURB, "aarch64/instructions/stlurb"
    autoload :STLURH, "aarch64/instructions/stlurh"
    autoload :STLXP, "aarch64/instructions/stlxp"
    autoload :STLXR, "aarch64/instructions/stlxr"
    autoload :STLXRB, "aarch64/instructions/stlxrb"
    autoload :STLXRH, "aarch64/instructions/stlxrh"
    autoload :STNP_gen, "aarch64/instructions/stnp_gen"
    autoload :STP_gen, "aarch64/instructions/stp_gen"
    autoload :STR_imm_gen, "aarch64/instructions/str_imm_gen"
    autoload :STR_reg_gen, "aarch64/instructions/str_reg_gen"
    autoload :STRB_imm, "aarch64/instructions/strb_imm"
    autoload :STRB_reg, "aarch64/instructions/strb_reg"
    autoload :STRH_imm, "aarch64/instructions/strh_imm"
    autoload :STRH_reg, "aarch64/instructions/strh_reg"
    autoload :STSET_LDSET, "aarch64/instructions/stset_ldset"
    autoload :STSETB_LDSETB, "aarch64/instructions/stsetb_ldsetb"
    autoload :STSETH_LDSETH, "aarch64/instructions/stseth_ldseth"
    autoload :STSMAX_LDSMAX, "aarch64/instructions/stsmax_ldsmax"
    autoload :STSMAXB_LDSMAXB, "aarch64/instructions/stsmaxb_ldsmaxb"
    autoload :STSMAXH_LDSMAXH, "aarch64/instructions/stsmaxh_ldsmaxh"
    autoload :STSMIN_LDSMIN, "aarch64/instructions/stsmin_ldsmin"
    autoload :STSMINB_LDSMINB, "aarch64/instructions/stsminb_ldsminb"
    autoload :STSMINH_LDSMINH, "aarch64/instructions/stsminh_ldsminh"
    autoload :STTR, "aarch64/instructions/sttr"
    autoload :STTRB, "aarch64/instructions/sttrb"
    autoload :STTRH, "aarch64/instructions/sttrh"
    autoload :STUMAX_LDUMAX, "aarch64/instructions/stumax_ldumax"
    autoload :STUMAXB_LDUMAXB, "aarch64/instructions/stumaxb_ldumaxb"
    autoload :STUMAXH_LDUMAXH, "aarch64/instructions/stumaxh_ldumaxh"
    autoload :STUMIN_LDUMIN, "aarch64/instructions/stumin_ldumin"
    autoload :STUMINB_LDUMINB, "aarch64/instructions/stuminb_lduminb"
    autoload :STUMINH_LDUMINH, "aarch64/instructions/stuminh_lduminh"
    autoload :STUR_gen, "aarch64/instructions/stur_gen"
    autoload :STURB, "aarch64/instructions/sturb"
    autoload :STURH, "aarch64/instructions/sturh"
    autoload :STXP, "aarch64/instructions/stxp"
    autoload :STXR, "aarch64/instructions/stxr"
    autoload :STXRB, "aarch64/instructions/stxrb"
    autoload :STXRH, "aarch64/instructions/stxrh"
    autoload :STZ2G, "aarch64/instructions/stz2g"
    autoload :STZG, "aarch64/instructions/stzg"
    autoload :STZGM, "aarch64/instructions/stzgm"
    autoload :SUB_addsub_ext, "aarch64/instructions/sub_addsub_ext"
    autoload :SUB_addsub_imm, "aarch64/instructions/sub_addsub_imm"
    autoload :SUB_addsub_shift, "aarch64/instructions/sub_addsub_shift"
    autoload :SUBG, "aarch64/instructions/subg"
    autoload :SUBP, "aarch64/instructions/subp"
    autoload :SUBPS, "aarch64/instructions/subps"
    autoload :SUBS_addsub_ext, "aarch64/instructions/subs_addsub_ext"
    autoload :SUBS_addsub_imm, "aarch64/instructions/subs_addsub_imm"
    autoload :SUBS_addsub_shift, "aarch64/instructions/subs_addsub_shift"
    autoload :SVC, "aarch64/instructions/svc"
    autoload :SWP, "aarch64/instructions/swp"
    autoload :SWPB, "aarch64/instructions/swpb"
    autoload :SWPH, "aarch64/instructions/swph"
    autoload :SXTB_SBFM, "aarch64/instructions/sxtb_sbfm"
    autoload :SXTH_SBFM, "aarch64/instructions/sxth_sbfm"
    autoload :SXTW_SBFM, "aarch64/instructions/sxtw_sbfm"
    autoload :SYS, "aarch64/instructions/sys"
    autoload :SYSL, "aarch64/instructions/sysl"
    autoload :TBNZ, "aarch64/instructions/tbnz"
    autoload :TBZ, "aarch64/instructions/tbz"
    autoload :TLBI_SYS, "aarch64/instructions/tlbi_sys"
    autoload :TSB, "aarch64/instructions/tsb"
    autoload :TST_ANDS_log_imm, "aarch64/instructions/tst_ands_log_imm"
    autoload :TST_ANDS_log_shift, "aarch64/instructions/tst_ands_log_shift"
    autoload :UBFIZ_UBFM, "aarch64/instructions/ubfiz_ubfm"
    autoload :UBFM, "aarch64/instructions/ubfm"
    autoload :UBFX_UBFM, "aarch64/instructions/ubfx_ubfm"
    autoload :UDF_perm_undef, "aarch64/instructions/udf_perm_undef"
    autoload :UDIV, "aarch64/instructions/udiv"
    autoload :UMADDL, "aarch64/instructions/umaddl"
    autoload :UMNEGL_UMSUBL, "aarch64/instructions/umnegl_umsubl"
    autoload :UMSUBL, "aarch64/instructions/umsubl"
    autoload :UMULH, "aarch64/instructions/umulh"
    autoload :UMULL_UMADDL, "aarch64/instructions/umull_umaddl"
    autoload :UXTB_UBFM, "aarch64/instructions/uxtb_ubfm"
    autoload :UXTH_UBFM, "aarch64/instructions/uxth_ubfm"
    autoload :WFE, "aarch64/instructions/wfe"
    autoload :WFET, "aarch64/instructions/wfet"
    autoload :WFI, "aarch64/instructions/wfi"
    autoload :WFIT, "aarch64/instructions/wfit"
    autoload :XAFLAG, "aarch64/instructions/xaflag"
    autoload :XPAC, "aarch64/instructions/xpac"
    autoload :YIELD, "aarch64/instructions/yield"
  end
end
