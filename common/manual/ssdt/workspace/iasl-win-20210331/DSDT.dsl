/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20210331 (32-bit version)
 * Copyright (c) 2000 - 2021 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ./DSDT.dat, Sat May  8 04:20:30 2021
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x0000A6C7 (42695)
 *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
 *     Checksum         0xEB
 *     OEM ID           "DELL  "
 *     OEM Table ID     "E2     "
 *     OEM Revision     0x00001001 (4097)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20080729 (537397033)
 */
DefinitionBlock ("", "DSDT", 1, "DELL  ", "E2     ", 0x00001001)
{
    /*
     * iASL Warning: There was 1 external control method found during
     * disassembly, but only 0 were resolved (1 unresolved). Additional
     * ACPI tables may be required to properly disassemble the code. This
     * resulting disassembler output file may not compile because the
     * disassembler did not know how many arguments to assign to the
     * unresolved methods. Note: SSDTs can be dynamically loaded at
     * runtime and may or may not be available via the host OS.
     *
     * To specify the tables needed to resolve external control method
     * references, the -e option can be used to specify the filenames.
     * Example iASL invocations:
     *     iasl -e ssdt1.aml ssdt2.aml ssdt3.aml -d dsdt.aml
     *     iasl -e dsdt.aml ssdt2.aml -d ssdt1.aml
     *     iasl -e ssdt*.aml -d dsdt.aml
     *
     * In addition, the -fe option can be used to specify a file containing
     * control method external declarations with the associated method
     * argument counts. Each line of the file must be of the form:
     *     External (<method pathname>, MethodObj, <argument count>)
     * Invocation:
     *     iasl -fe refs.txt -d dsdt.aml
     *
     * The following methods were unresolved and many not compile properly
     * because the disassembler had to guess at the number of arguments
     * required for each:
     */
    External (_PR_.CPU0._PPC, UnknownObj)
    External (HNOT, MethodObj)    // Warning: Unknown method, guessing 1 arguments

    Method (BCLR, 1, NotSerialized)
    {
        Local0 = 0x00
        While ((Local0 < SizeOf (Arg0)))
        {
            BBWR (Arg0, Local0, 0x00)
            Local0++
        }
    }

    Method (BBWR, 3, NotSerialized)
    {
        CreateByteField (Arg0, Arg1, VAL)
        VAL = Arg2
    }

    Method (BBRD, 2, NotSerialized)
    {
        CreateByteField (Arg0, Arg1, VAL)
        Return (VAL) /* \BBRD.VAL_ */
    }

    Method (BWWR, 3, NotSerialized)
    {
        CreateWordField (Arg0, Arg1, VAL)
        VAL = Arg2
    }

    Method (BWRD, 2, NotSerialized)
    {
        CreateWordField (Arg0, Arg1, VAL)
        Return (VAL) /* \BWRD.VAL_ */
    }

    Method (BDWR, 3, NotSerialized)
    {
        CreateDWordField (Arg0, Arg1, VAL)
        VAL = Arg2
    }

    Method (BDRD, 2, NotSerialized)
    {
        CreateDWordField (Arg0, Arg1, VAL)
        Return (VAL) /* \BDRD.VAL_ */
    }

    Method (STRE, 2, NotSerialized)
    {
        Name (STR1, Buffer (0x50){})
        Name (STR2, Buffer (0x50){})
        STR1 = Arg0
        STR2 = Arg1
        Local0 = Zero
        Local1 = One
        While (Local1)
        {
            Local1 = BBRD (STR1, Local0)
            Local2 = BBRD (STR2, Local0)
            If ((Local1 != Local2))
            {
                Return (Zero)
            }

            Local0++
        }

        Return (One)
    }

    Method (XPTB, 1, NotSerialized)
    {
        Local0 = SizeOf (Arg0)
        If ((ObjectType (Arg0) == 0x02))
        {
            Local0++
        }

        Name (OBUF, Buffer (Local0){})
        OBUF = Arg0
        If ((ObjectType (Arg0) == 0x02))
        {
            Local0--
            OBUF [Local0] = 0x00
        }

        Return (OBUF) /* \XPTB.OBUF */
    }

    Method (STDG, 3, NotSerialized)
    {
        Local0 = Arg0
        If ((Arg0 >= 0x0A))
        {
            Divide (Arg0, 0x0A, Local0, Local1)
            Arg2 = STDG (Local1, Arg1, Arg2)
        }

        Local0 += 0x30
        Arg1 [Arg2] = Local0
        Arg2++
        Return (Arg2)
    }

    Method (XPTS, 1, NotSerialized)
    {
        Name (LBUF, Buffer (0x20){})
        Local0 = STDG (Arg0, LBUF, 0x00)
        LBUF [Local0] = 0x00
        Local0++
        Name (OBUF, Buffer (Local0){})
        OBUF = LBUF /* \XPTS.LBUF */
        Return (OBUF) /* \XPTS.OBUF */
    }

    Name (W98S, "Microsoft Windows")
    Name (NT5S, "Microsoft Windows NT")
    Name (WINM, "Microsoft WindowsME: Millennium Edition")
    Name (WXP, "Windows 2001")
    Name (WLG, "Windows 2006")
    Name (WIN7, "Windows 2009")
    Name (LINX, "Linux")
    Scope (\_SB)
    {
        Name (ACOS, 0x00)
        Method (OSID, 0, NotSerialized)
        {
            If ((ACOS == 0x00))
            {
                ACOS = 0x01
                If (CondRefOf (\_OSI, Local0))
                {
                    If (\_OSI (WXP))
                    {
                        ACOS = 0x10
                    }

                    If (\_OSI (WLG))
                    {
                        ACOS = 0x20
                    }

                    If (\_OSI (WIN7))
                    {
                        ACOS = 0x80
                    }

                    If (\_OSI (LINX))
                    {
                        ACOS = 0x40
                    }
                }
                Else
                {
                    If (STRE (\_OS, W98S))
                    {
                        ACOS = 0x02
                    }

                    If (STRE (\_OS, WINM))
                    {
                        ACOS = 0x04
                    }

                    If (STRE (\_OS, NT5S))
                    {
                        ACOS = 0x08
                    }
                }
            }

            Return (ACOS) /* \_SB_.ACOS */
        }

        Method (STOS, 0, NotSerialized)
        {
            OSID ()
            GENS (0x06, ACOS, 0x00)
        }

        Method (SOS0, 2, NotSerialized)
        {
            STOS ()
        }

        Method (SOS4, 2, NotSerialized)
        {
            If ((Arg0 == 0x04))
            {
                STOS ()
            }
        }
    }

    Name (SS1, 0x00)
    Name (SS2, 0x00)
    Name (SS3, 0x00)
    Name (SS4, 0x00)
    Name (IOST, 0x4400)
    Name (TOPM, 0xCFFFFFFF)
    Name (ROMS, 0xFFE00000)
    Name (MG1B, 0x00000000)
    Name (MG1L, 0x00000000)
    Name (MG2B, 0xD0000000)
    Name (MG2L, 0x2C807000)
    Name (MCHB, 0xFED10000)
    Name (MCHL, 0x4000)
    Name (EGPB, 0xFED19000)
    Name (EGPL, 0x1000)
    Name (DMIB, 0xFED18000)
    Name (DMIL, 0x1000)
    Name (IFPB, 0xFED14000)
    Name (IFPL, 0x1000)
    Name (PEBS, 0xF8000000)
    Name (PELN, 0x04000000)
    Name (TTTB, 0xFED20000)
    Name (TTTL, 0x00020000)
    Name (PBLK, 0x0410)
    Name (SMIP, 0xB2)
    Name (PM30, 0x0430)
    Name (SRCB, 0xFED1C000)
    Name (SRCL, 0x4000)
    Name (SUSW, 0xFF)
    Name (FMBL, 0x01)
    Name (FDTP, 0x02)
    Name (BRF, 0x01)
    Name (BPH, 0x02)
    Name (BLC, 0x03)
    Name (BRFS, 0x04)
    Name (BPHS, 0x05)
    Name (BLCT, 0x06)
    Name (BRF4, 0x07)
    Name (BEP, 0x08)
    Name (BBF, 0x09)
    Name (BOF, 0x0A)
    Name (BPT, 0x0B)
    Name (SRAF, 0x0C)
    Name (WWP, 0x0D)
    Name (SDOE, 0x0E)
    Name (ACPH, 0xDE)
    Name (ASSB, 0x00)
    Name (AOTB, 0x00)
    Name (AAXB, 0x00)
    Name (PEHP, 0x00)
    Name (SHPC, 0x01)
    Name (PEPM, 0x00)
    Name (PEER, 0x00)
    Name (PECS, 0x00)
    Name (ITKE, 0x00)
    Name (TRTP, 0x01)
    Name (TRTD, 0x02)
    Name (TRTI, 0x03)
    Name (GCDD, 0x01)
    Name (DSTA, 0x0A)
    Name (DSLO, 0x0C)
    Name (DSLC, 0x0E)
    Name (PITS, 0x10)
    Name (SBCS, 0x12)
    Name (SALS, 0x13)
    Name (LSSS, 0x2A)
    Name (SOOT, 0x35)
    Name (PDBR, 0x4D)
    Name (SP3O, 0x2E)
    Name (SP1O, 0x094E)
    Name (IO2B, 0x0680)
    Name (SP2O, 0x4E)
    Name (TCGM, 0x01)
    OperationRegion (GNVS, SystemMemory, 0xCBF66C18, 0x0173)
    Field (GNVS, AnyAcc, Lock, Preserve)
    {
        OSYS,   16, 
        SMIF,   8, 
        PRM0,   8, 
        PRM1,   8, 
        SCIF,   8, 
        PRM2,   8, 
        PRM3,   8, 
        LCKF,   8, 
        PRM4,   8, 
        PRM5,   8, 
        P80D,   32, 
        LIDS,   8, 
        PWRS,   8, 
        DBGS,   8, 
        THOF,   8, 
        ACT1,   8, 
        ACTT,   8, 
        PSVT,   8, 
        TC1V,   8, 
        TC2V,   8, 
        TSPV,   8, 
        CRTT,   8, 
        DTSE,   8, 
        DTS1,   8, 
        DTS2,   8, 
        DTSF,   8, 
        Offset (0x25), 
        REVN,   8, 
        Offset (0x28), 
        APIC,   8, 
        TCNT,   8, 
        PCP0,   8, 
        PCP1,   8, 
        PPCM,   8, 
        PPMF,   32, 
        Offset (0x32), 
        NATP,   8, 
        CMAP,   8, 
        CMBP,   8, 
        LPTP,   8, 
        FDCP,   8, 
        CMCP,   8, 
        CIRP,   8, 
        SMSC,   8, 
        W381,   8, 
        SMC1,   8, 
        IGDS,   8, 
        TLST,   8, 
        CADL,   8, 
        PADL,   8, 
        CSTE,   16, 
        NSTE,   16, 
        SSTE,   16, 
        NDID,   8, 
        DID1,   32, 
        DID2,   32, 
        DID3,   32, 
        DID4,   32, 
        DID5,   32, 
        KSV0,   32, 
        KSV1,   8, 
        Offset (0x67), 
        BLCS,   8, 
        BRTL,   8, 
        ALSE,   8, 
        ALAF,   8, 
        LLOW,   8, 
        LHIH,   8, 
        Offset (0x6E), 
        EMAE,   8, 
        EMAP,   16, 
        EMAL,   16, 
        Offset (0x74), 
        MEFE,   8, 
        DSTS,   8, 
        Offset (0x78), 
        TPMP,   8, 
        TPME,   8, 
        MORD,   8, 
        TCGP,   8, 
        PPRP,   32, 
        PPRQ,   8, 
        LPPR,   8, 
        GTF0,   56, 
        GTF2,   56, 
        IDEM,   8, 
        GTF1,   56, 
        BID,    8, 
        Offset (0xA0), 
        TCMP,   8, 
        TCME,   8, 
        Offset (0xAA), 
        ASLB,   32, 
        IBTT,   8, 
        IPAT,   8, 
        ITVF,   8, 
        ITVM,   8, 
        IPSC,   8, 
        IBLC,   8, 
        IBIA,   8, 
        ISSC,   8, 
        I409,   8, 
        I509,   8, 
        I609,   8, 
        I709,   8, 
        IPCF,   8, 
        IDMS,   8, 
        IF1E,   8, 
        HVCO,   8, 
        NXD1,   32, 
        NXD2,   32, 
        NXD3,   32, 
        NXD4,   32, 
        NXD5,   32, 
        NXD6,   32, 
        NXD7,   32, 
        NXD8,   32, 
        GSMI,   8, 
        PAVP,   8, 
        Offset (0xE1), 
        OSCC,   8, 
        NEXP,   8, 
        SDGV,   8, 
        SDDV,   8, 
        Offset (0xEB), 
        DSEN,   8, 
        ECON,   8, 
        GPIC,   8, 
        CTYP,   8, 
        L01C,   8, 
        VFN0,   8, 
        VFN1,   8, 
        Offset (0x100), 
        NVGA,   32, 
        NVHA,   32, 
        AMDA,   32, 
        DID6,   32, 
        DID7,   32, 
        DID8,   32, 
        EBAS,   32, 
        CPSP,   32, 
        EECP,   32, 
        EVCP,   32, 
        XBAS,   32, 
        OBS1,   32, 
        OBS2,   32, 
        OBS3,   32, 
        OBS4,   32, 
        OBS5,   32, 
        OBS6,   32, 
        OBS7,   32, 
        OBS8,   32, 
        Offset (0x157), 
        ATMC,   8, 
        PTMC,   8, 
        ATRA,   8, 
        PTRA,   8, 
        PNHM,   32, 
        TBAB,   32, 
        TBAH,   32, 
        RTIP,   8, 
        TSOD,   8, 
        ATPC,   8, 
        PTPC,   8, 
        PFLV,   8, 
        BREV,   8, 
        DPBM,   8, 
        DPCM,   8, 
        DPDM,   8, 
        ALFP,   8, 
        IMON,   8, 
        FFSN,   8
    }

    Scope (\_SB)
    {
        Name (PR00, Package (0x25)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                0x00, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x03, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR00, Package (0x25)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                0x00, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x03, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR05, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                0x00
            }
        })
        Name (AR05, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x10
            }
        })
        Name (PR06, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR06, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PR07, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                0x00
            }
        })
        Name (AR07, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x12
            }
        })
        Name (PR08, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR08, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR0E, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR0E, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PR0F, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                0x00
            }
        })
        Name (AR0F, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x12
            }
        })
        Name (PR01, Package (0x14)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                LNKF, 
                0x00
            }
        })
        Name (AR01, Package (0x14)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                0x00, 
                0x15
            }
        })
        Name (PR0A, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR0A, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR0C, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR0C, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR80, Package (0x2A)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x01, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                0x00, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR80, Package (0x2A)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x03, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x01, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                0x00, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PR82, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR82, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR8A, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR8A, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR8C, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR8C, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR84, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR84, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR85, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                0x00
            }
        })
        Name (AR85, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x10
            }
        })
        Name (PR86, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR86, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PR87, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                0x00
            }
        })
        Name (AR87, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x12
            }
        })
        Name (PR88, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR88, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR8E, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR8E, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PR8F, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                0x00
            }
        })
        Name (AR8F, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x12
            }
        })
        Name (PR81, Package (0x14)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKF, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                LNKG, 
                0x00
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                LNKF, 
                0x00
            }
        })
        Name (AR81, Package (0x14)
        {
            Package (0x04)
            {
                0x0003FFFF, 
                0x00, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x01, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x15
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x01, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x02, 
                0x00, 
                0x16
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                0x03, 
                0x00, 
                0x15
            }
        })
        Name (PR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PRSA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,7,10,11,12,14,15}
        })
        Alias (PRSA, PRSB)
        Alias (PRSA, PRSC)
        Alias (PRSA, PRSD)
        Alias (PRSA, PRSE)
        Alias (PRSA, PRSF)
        Alias (PRSA, PRSG)
        Alias (PRSA, PRSH)
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_ADR, 0x00)  // _ADR: Address
            Method (^BN00, 0, NotSerialized)
            {
                Return (0x00)
            }

            Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
            {
                Return (BN00 ())
            }

            Name (_UID, 0x00)  // _UID: Unique ID
            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                If (PICM)
                {
                    Return (AR00 ())
                }

                Return (PR00 ())
            }

            OperationRegion (HBUS, PCI_Config, 0x40, 0xC0)
            Field (HBUS, DWordAcc, NoLock, Preserve)
            {
                EPEN,   1, 
                    ,   11, 
                EPBR,   20, 
                Offset (0x08), 
                MHEN,   1, 
                    ,   13, 
                MHBR,   18, 
                Offset (0x10), 
                IIEN,   1, 
                    ,   11, 
                DIBI,   20, 
                Offset (0x28), 
                DIEN,   1, 
                    ,   11, 
                DIBR,   20, 
                Offset (0x30), 
                IPEN,   1, 
                    ,   11, 
                IPBR,   20, 
                Offset (0x62), 
                TUUD,   16, 
                Offset (0x70), 
                    ,   4, 
                TLUD,   12, 
                Offset (0x89), 
                    ,   3, 
                GTSE,   1, 
                Offset (0x8A)
            }

            OperationRegion (MCHT, SystemMemory, 0xFED10000, 0x1100)
            Field (MCHT, ByteAcc, NoLock, Preserve)
            {
                Offset (0xD40), 
                ADVE,   1, 
                    ,   11, 
                ADVT,   20, 
                Offset (0x101E), 
                T0IS,   16, 
                Offset (0x105E), 
                T1IS,   16, 
                Offset (0x10EF), 
                ESCS,   8
            }

            Name (BUF0, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x00FE,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x00FF,             // Length
                    ,, _Y00)
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000CF7,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000CF8,         // Length
                    ,, , TypeStatic, DenseTranslation)
                IO (Decode16,
                    0x0CF8,             // Range Minimum
                    0x0CF8,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000D00,         // Range Minimum
                    0x0000FFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x0000F300,         // Length
                    ,, , TypeStatic, DenseTranslation)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000A0000,         // Range Minimum
                    0x000BFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C0000,         // Range Minimum
                    0x000C3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y01, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C4000,         // Range Minimum
                    0x000C7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y02, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C8000,         // Range Minimum
                    0x000CBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y03, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000CC000,         // Range Minimum
                    0x000CFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y04, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D0000,         // Range Minimum
                    0x000D3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y05, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D4000,         // Range Minimum
                    0x000D7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y06, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D8000,         // Range Minimum
                    0x000DBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y07, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000DC000,         // Range Minimum
                    0x000DFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y08, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E0000,         // Range Minimum
                    0x000E3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y09, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E4000,         // Range Minimum
                    0x000E7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y0A, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E8000,         // Range Minimum
                    0x000EBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y0B, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000EC000,         // Range Minimum
                    0x000EFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y0C, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000F0000,         // Range Minimum
                    0x000FFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00010000,         // Length
                    ,, _Y0D, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0xFEAFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, _Y0E, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0xFED40000,         // Range Minimum
                    0xFED44FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateWordField (BUF0, \_SB.PCI0._Y00._MAX, PBMX)  // _MAX: Maximum Base Address
                PBMX = ((\PELN >> 0x14) - 0x02)
                CreateWordField (BUF0, \_SB.PCI0._Y00._LEN, PBLN)  // _LEN: Length
                PBLN = ((\PELN >> 0x14) - 0x01)
                If (\_SB.CPBG.IMCH.PM1L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y01._LEN, C0LN)  // _LEN: Length
                    C0LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM1L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y01._RW, C0RW)  // _RW_: Read-Write Status
                    C0RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM1H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y02._LEN, C4LN)  // _LEN: Length
                    C4LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM1H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y02._RW, C4RW)  // _RW_: Read-Write Status
                    C4RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM2L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y03._LEN, C8LN)  // _LEN: Length
                    C8LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM2L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y03._RW, C8RW)  // _RW_: Read-Write Status
                    C8RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM2H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y04._LEN, CCLN)  // _LEN: Length
                    CCLN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM2H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y04._RW, CCRW)  // _RW_: Read-Write Status
                    CCRW = Zero
                }

                If (\_SB.CPBG.IMCH.PM3L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y05._LEN, D0LN)  // _LEN: Length
                    D0LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM3L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y05._RW, D0RW)  // _RW_: Read-Write Status
                    D0RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM3H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y06._LEN, D4LN)  // _LEN: Length
                    D4LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM3H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y06._RW, D4RW)  // _RW_: Read-Write Status
                    D4RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM4L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y07._LEN, D8LN)  // _LEN: Length
                    D8LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM4L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y07._RW, D8RW)  // _RW_: Read-Write Status
                    D8RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM4H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y08._LEN, DCLN)  // _LEN: Length
                    DCLN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM4H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y08._RW, DCRW)  // _RW_: Read-Write Status
                    DCRW = Zero
                }

                If (\_SB.CPBG.IMCH.PM5L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y09._LEN, E0LN)  // _LEN: Length
                    E0LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM5L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y09._RW, E0RW)  // _RW_: Read-Write Status
                    E0RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM5H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0A._LEN, E4LN)  // _LEN: Length
                    E4LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM5H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0A._RW, E4RW)  // _RW_: Read-Write Status
                    E4RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM6L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0B._LEN, E8LN)  // _LEN: Length
                    E8LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM6L == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0B._RW, E8RW)  // _RW_: Read-Write Status
                    E8RW = Zero
                }

                If (\_SB.CPBG.IMCH.PM6H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0C._LEN, ECLN)  // _LEN: Length
                    ECLN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM6H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0C._RW, ECRW)  // _RW_: Read-Write Status
                    ECRW = Zero
                }

                If (\_SB.CPBG.IMCH.PM0H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0D._LEN, F0LN)  // _LEN: Length
                    F0LN = Zero
                }

                If ((\_SB.CPBG.IMCH.PM0H == 0x01))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0D._RW, F0RW)  // _RW_: Read-Write Status
                    F0RW = Zero
                }

                CreateDWordField (BUF0, \_SB.PCI0._Y0E._MIN, M1MN)  // _MIN: Minimum Base Address
                CreateDWordField (BUF0, \_SB.PCI0._Y0E._MAX, M1MX)  // _MAX: Maximum Base Address
                CreateDWordField (BUF0, \_SB.PCI0._Y0E._LEN, M1LN)  // _LEN: Length
                If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                    ) == 0x000106A0)))
                {
                    If ((PNHM >= 0x000106E1))
                    {
                        Local0 = \_SB.PCI0.IO10.TOLM
                        M1MN = (Local0++ << 0x1A)
                    }
                    Else
                    {
                        Local0 = \_SB.PCI0.IIO0.TOLM
                        M1MN = (Local0++ << 0x1A)
                    }
                }
                Else
                {
                    M1MN = (TLUD << 0x14)
                }

                M1LN = ((M1MX - M1MN) + 0x01)
                Return (BUF0) /* \_SB_.PCI0.BUF0 */
            }

            Name (GUID, ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */)
            Name (SUPP, 0x00)
            Name (CTRL, 0x00)
            Method (_OSC, 4, Serialized)  // _OSC: Operating System Capabilities
            {
                Local0 = Arg3
                CreateDWordField (Local0, 0x00, CDW1)
                CreateDWordField (Local0, 0x04, CDW2)
                CreateDWordField (Local0, 0x08, CDW3)
                If (((Arg0 == GUID) && NEXP))
                {
                    SUPP = CDW2 /* \_SB_.PCI0._OSC.CDW2 */
                    CTRL = CDW3 /* \_SB_.PCI0._OSC.CDW3 */
                    If (~(CDW1 & 0x01))
                    {
                        If ((CTRL & 0x02))
                        {
                            NHPG ()
                        }

                        If ((CTRL & 0x04))
                        {
                            NPME ()
                        }
                    }

                    If ((Arg1 != One))
                    {
                        CDW1 |= 0x08
                    }

                    If ((CDW3 != CTRL))
                    {
                        CDW1 |= 0x10
                    }

                    CDW3 = CTRL /* \_SB_.PCI0.CTRL */
                    OSCC = CTRL /* \_SB_.PCI0.CTRL */
                    Return (Local0)
                }
                Else
                {
                    CDW1 |= 0x04
                    Return (Local0)
                }
            }

            Scope (\_SB.PCI0)
            {
                Method (AR00, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR80)
                    }
                    Else
                    {
                        Return (\_SB.AR00)
                    }
                }

                Method (PR00, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR80)
                    }
                    Else
                    {
                        Return (\_SB.PR00)
                    }
                }

                Method (AR01, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR81)
                    }
                    Else
                    {
                        Return (\_SB.AR01)
                    }
                }

                Method (PR01, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR81)
                    }
                    Else
                    {
                        Return (\_SB.PR01)
                    }
                }

                Method (AR02, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR82)
                    }
                    Else
                    {
                        Return (\_SB.AR02)
                    }
                }

                Method (PR02, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR82)
                    }
                    Else
                    {
                        Return (\_SB.PR02)
                    }
                }

                Method (AR04, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR84)
                    }
                    Else
                    {
                        Return (\_SB.AR04)
                    }
                }

                Method (PR04, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR84)
                    }
                    Else
                    {
                        Return (\_SB.PR04)
                    }
                }

                Method (AR05, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR85)
                    }
                    Else
                    {
                        Return (\_SB.AR05)
                    }
                }

                Method (PR05, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR85)
                    }
                    Else
                    {
                        Return (\_SB.PR05)
                    }
                }

                Method (AR06, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR86)
                    }
                    Else
                    {
                        Return (\_SB.AR06)
                    }
                }

                Method (PR06, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR86)
                    }
                    Else
                    {
                        Return (\_SB.PR06)
                    }
                }

                Method (AR07, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR87)
                    }
                    Else
                    {
                        Return (\_SB.AR07)
                    }
                }

                Method (PR07, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR87)
                    }
                    Else
                    {
                        Return (\_SB.PR07)
                    }
                }

                Method (AR08, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR88)
                    }
                    Else
                    {
                        Return (\_SB.AR08)
                    }
                }

                Method (PR08, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR88)
                    }
                    Else
                    {
                        Return (\_SB.PR08)
                    }
                }

                Method (AR0A, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.AR8A)
                    }
                    Else
                    {
                        Return (\_SB.AR0A)
                    }
                }

                Method (PR0A, 0, NotSerialized)
                {
                    If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                        ) == 0x000106A0)))
                    {
                        Return (\_SB.PR8A)
                    }
                    Else
                    {
                        Return (\_SB.PR0A)
                    }
                }
            }

            Device (AGP)
            {
                Name (_ADR, 0x00010000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR02 ())
                    }

                    Return (PR02 ())
                }

                Device (VID)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                }
            }

            Device (P0P1)
            {
                Name (_ADR, 0x001E0000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0B, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR01 ())
                    }

                    Return (PR01 ())
                }
            }

            Device (LPCB)
            {
                Name (_ADR, 0x001F0000)  // _ADR: Address
                Scope (\_SB)
                {
                    OperationRegion (\_SB.PCI0.LPCB.LPC1, PCI_Config, 0x40, 0xC0)
                    Field (\_SB.PCI0.LPCB.LPC1, AnyAcc, NoLock, Preserve)
                    {
                        Offset (0x20), 
                        PARC,   8, 
                        PBRC,   8, 
                        PCRC,   8, 
                        PDRC,   8, 
                        Offset (0x28), 
                        PERC,   8, 
                        PFRC,   8, 
                        PGRC,   8, 
                        PHRC,   8
                    }

                    Device (LNKA)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x01)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PARC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLA, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y0F)
                                    {}
                            })
                            CreateWordField (RTLA, \_SB.LNKA._CRS._Y0F._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PARC & 0x0F))
                            Return (RTLA) /* \_SB_.LNKA._CRS.RTLA */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PARC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PARC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKB)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x02)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PBRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLB, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y10)
                                    {}
                            })
                            CreateWordField (RTLB, \_SB.LNKB._CRS._Y10._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PBRC & 0x0F))
                            Return (RTLB) /* \_SB_.LNKB._CRS.RTLB */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PBRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PBRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKC)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x03)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PCRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLC, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y11)
                                    {}
                            })
                            CreateWordField (RTLC, \_SB.LNKC._CRS._Y11._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PCRC & 0x0F))
                            Return (RTLC) /* \_SB_.LNKC._CRS.RTLC */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PCRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PCRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKD)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x04)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PDRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLD, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y12)
                                    {}
                            })
                            CreateWordField (RTLD, \_SB.LNKD._CRS._Y12._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PDRC & 0x0F))
                            Return (RTLD) /* \_SB_.LNKD._CRS.RTLD */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PDRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PDRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKE)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x05)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PERC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLE, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y13)
                                    {}
                            })
                            CreateWordField (RTLE, \_SB.LNKE._CRS._Y13._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PERC & 0x0F))
                            Return (RTLE) /* \_SB_.LNKE._CRS.RTLE */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PERC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PERC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKF)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x06)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PFRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLF, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y14)
                                    {}
                            })
                            CreateWordField (RTLF, \_SB.LNKF._CRS._Y14._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PFRC & 0x0F))
                            Return (RTLF) /* \_SB_.LNKF._CRS.RTLF */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PFRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PFRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKG)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x07)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PGRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,10,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLG, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y15)
                                    {}
                            })
                            CreateWordField (RTLG, \_SB.LNKG._CRS._Y15._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PGRC & 0x0F))
                            Return (RTLG) /* \_SB_.LNKG._CRS.RTLG */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PGRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PGRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }

                    Device (LNKH)
                    {
                        Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                        Name (_UID, 0x08)  // _UID: Unique ID
                        Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                        {
                            PHRC |= 0x80
                        }

                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {1,3,4,5,6,7,11,12,14,15}
                        })
                        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                        {
                            Name (RTLH, ResourceTemplate ()
                            {
                                IRQ (Level, ActiveLow, Shared, _Y16)
                                    {}
                            })
                            CreateWordField (RTLH, \_SB.LNKH._CRS._Y16._INT, IRQ0)  // _INT: Interrupts
                            IRQ0 = Zero
                            IRQ0 = (0x01 << (PHRC & 0x0F))
                            Return (RTLH) /* \_SB_.LNKH._CRS.RTLH */
                        }

                        Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                        {
                            CreateWordField (Arg0, 0x01, IRQ0)
                            FindSetRightBit (IRQ0, Local0)
                            Local0--
                            PHRC = Local0
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If ((PHRC & 0x80))
                            {
                                Return (0x09)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }
                    }
                }

                OperationRegion (LPC0, PCI_Config, 0x40, 0xC0)
                Field (LPC0, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x40), 
                    IOD0,   8, 
                    IOD1,   8, 
                    Offset (0xB0), 
                    RAEN,   1, 
                        ,   13, 
                    RCBA,   18
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x11,               // Length
                            )
                        IO (Decode16,
                            0x0093,             // Range Minimum
                            0x0093,             // Range Maximum
                            0x01,               // Alignment
                            0x0D,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }

                Device (FWHD)
                {
                    Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadOnly,
                            0xFF000000,         // Address Base
                            0x01000000,         // Address Length
                            )
                    })
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
                    Name (_UID, 0x00)  // _UID: Unique ID
                    Name (BUF0, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0xFED00000,         // Address Base
                            0x00000400,         // Address Length
                            _Y17)
                    })
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If ((OSYS >= 0x07D1))
                        {
                            If (HPAE)
                            {
                                Return (0x0F)
                            }
                        }
                        ElseIf (HPAE)
                        {
                            Return (0x0B)
                        }

                        Return (0x00)
                    }

                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        If (HPAE)
                        {
                            CreateDWordField (BUF0, \_SB.PCI0.LPCB.HPET._Y17._BAS, HPT0)  // _BAS: Base Address
                            If ((HPAS == 0x01))
                            {
                                HPT0 = 0xFED01000
                            }

                            If ((HPAS == 0x02))
                            {
                                HPT0 = 0xFED02000
                            }

                            If ((HPAS == 0x03))
                            {
                                HPT0 = 0xFED03000
                            }
                        }

                        Return (BUF0) /* \_SB_.PCI0.LPCB.HPET.BUF0 */
                    }
                }

                Device (IPIC)
                {
                    Name (_HID, EisaId ("PNP0000") /* 8259-compatible Programmable Interrupt Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0024,             // Range Minimum
                            0x0024,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0028,             // Range Minimum
                            0x0028,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x002C,             // Range Minimum
                            0x002C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0030,             // Range Minimum
                            0x0030,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0034,             // Range Minimum
                            0x0034,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0038,             // Range Minimum
                            0x0038,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x003C,             // Range Minimum
                            0x003C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A4,             // Range Minimum
                            0x00A4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A8,             // Range Minimum
                            0x00A8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00AC,             // Range Minimum
                            0x00AC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B4,             // Range Minimum
                            0x00B4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B8,             // Range Minimum
                            0x00B8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00BC,             // Range Minimum
                            0x00BC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }

                Device (LDRC)
                {
                    Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                    Name (_UID, 0x02)  // _UID: Unique ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x002E,             // Range Minimum
                            0x002E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x004E,             // Range Minimum
                            0x004E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0092,             // Range Minimum
                            0x0092,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00B2,             // Range Minimum
                            0x00B2,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0680,             // Range Minimum
                            0x0680,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x1000,             // Range Minimum
                            0x1000,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x1004,             // Range Minimum
                            0x1004,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0xFFFF,             // Range Minimum
                            0xFFFF,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0400,             // Range Minimum
                            0x0400,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x0500,             // Range Minimum
                            0x0500,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x164E,             // Range Minimum
                            0x164E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x08,               // Length
                            )
                        IRQNoFlags ()
                            {8}
                    })
                }

                Device (TIMR)
                {
                    Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0050,             // Range Minimum
                            0x0050,             // Range Maximum
                            0x10,               // Alignment
                            0x04,               // Length
                            )
                        IRQNoFlags ()
                            {0}
                    })
                }

                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303") /* IBM Enhanced Keyboard (101/102-key, PS/2 Mouse) */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {1}
                    })
                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        StartDependentFn (0x00, 0x00)
                        {
                            FixedIO (
                                0x0060,             // Address
                                0x01,               // Length
                                )
                            FixedIO (
                                0x0064,             // Address
                                0x01,               // Length
                                )
                            IRQNoFlags ()
                                {1}
                        }
                        EndDependentFn ()
                    })
                }
            }

            Device (HDEF)
            {
                Name (_ADR, 0x001B0000)  // _ADR: Address
                OperationRegion (HDAR, PCI_Config, 0x4C, 0x10)
                Field (HDAR, WordAcc, NoLock, Preserve)
                {
                    DCKA,   1, 
                    Offset (0x01), 
                    DCKM,   1, 
                        ,   6, 
                    DCKS,   1, 
                    Offset (0x08), 
                        ,   15, 
                    PMES,   1
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0D, 0x04))
                }
            }

            Device (RP01)
            {
                Name (_ADR, 0x001C0000)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR04 ())
                    }

                    Return (PR04 ())
                }
            }

            Device (RP02)
            {
                Name (_ADR, 0x001C0001)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR05 ())
                    }

                    Return (PR05 ())
                }
            }

            Device (RP03)
            {
                Name (_ADR, 0x001C0002)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR06 ())
                    }

                    Return (PR06 ())
                }
            }

            Device (RP04)
            {
                Name (_ADR, 0x001C0003)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_EJD, "\\_SB.PCI0.EHC2.RHUB.PRT1.PRT3")  // _EJD: Ejection Dependent Device
                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (0x01)
                    }

                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR07 ())
                    }

                    Return (PR07 ())
                }
            }

            Device (RP05)
            {
                Name (_ADR, 0x001C0004)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR08 ())
                    }

                    Return (PR08 ())
                }
            }

            Device (RP07)
            {
                Name (_ADR, 0x001C0006)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR0E) /* \_SB_.AR0E */
                    }

                    Return (PR0E) /* \_SB_.PR0E */
                }
            }

            Device (RP08)
            {
                Name (_ADR, 0x001C0007)  // _ADR: Address
                OperationRegion (PXCS, PCI_Config, 0x40, 0xC0)
                Field (PXCS, AnyAcc, NoLock, WriteAsZeros)
                {
                    Offset (0x12), 
                        ,   13, 
                    LASX,   1, 
                    Offset (0x1A), 
                    ABPX,   1, 
                        ,   2, 
                    PDCX,   1, 
                        ,   2, 
                    PDSX,   1, 
                    Offset (0x1B), 
                    LSCX,   1, 
                    Offset (0x20), 
                    Offset (0x22), 
                    PSPX,   1, 
                    Offset (0x98), 
                        ,   30, 
                    HPEX,   1, 
                    PMEX,   1, 
                        ,   30, 
                    HPSX,   1, 
                    PMSX,   1
                }

                Device (PXSX)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR0F) /* \_SB_.AR0F */
                    }

                    Return (PR0F) /* \_SB_.PR0F */
                }
            }

            Device (GLAN)
            {
                Name (_ADR, 0x00190000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0D, 0x04))
                }
            }

            Device (IO10)
            {
                Name (_ADR, 0x00080000)  // _ADR: Address
                OperationRegion (IBUS, PCI_Config, 0xD0, 0xE0)
                Field (IBUS, DWordAcc, NoLock, Preserve)
                {
                        ,   26, 
                    TOLM,   6, 
                        ,   26, 
                    TOHM,   38, 
                    Offset (0xB0), 
                    VTEN,   1, 
                        ,   11, 
                    VTBA,   20
                }
            }

            Device (IO1X)
            {
                Name (_ADR, 0x00080001)  // _ADR: Address
                OperationRegion (PBIC, PCI_Config, 0x00, 0xF0)
                Field (PBIC, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x7C), 
                    SR0,    32, 
                    SR1,    32, 
                    SR2,    32, 
                    SR3,    32, 
                    SR4,    32, 
                    SR5,    32, 
                    SR6,    32, 
                    SR7,    32, 
                    SR8,    32, 
                    SR9,    32
                }
            }

            Device (IIO0)
            {
                Name (_ADR, 0x00140000)  // _ADR: Address
                OperationRegion (IBUS, PCI_Config, 0xD0, 0xE0)
                Field (IBUS, DWordAcc, NoLock, Preserve)
                {
                        ,   26, 
                    TOLM,   6, 
                        ,   26, 
                    TOHM,   38, 
                    Offset (0xB0), 
                    VTEN,   1, 
                        ,   11, 
                    VTBA,   20
                }
            }

            Device (IIOX)
            {
                Name (_ADR, 0x00140001)  // _ADR: Address
                OperationRegion (PBIC, PCI_Config, 0x00, 0xF0)
                Field (PBIC, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x7C), 
                    SR0,    32, 
                    SR1,    32, 
                    SR2,    32, 
                    SR3,    32, 
                    SR4,    32, 
                    SR5,    32, 
                    SR6,    32, 
                    SR7,    32, 
                    SR8,    32, 
                    SR9,    32
                }
            }

            Device (PEG3)
            {
                Name (_ADR, 0x00030000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR0A ())
                    }

                    Return (PR0A ())
                }

                Device (VID)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                }
            }

            Device (PEG4)
            {
                Name (_ADR, 0x00040000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
            }

            Device (PEG5)
            {
                Name (_ADR, 0x00050000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR0C) /* \_SB_.AR0C */
                    }

                    Return (PR0C) /* \_SB_.PR0C */
                }
            }

            Device (PEG6)
            {
                Name (_ADR, 0x00060000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
            }
        }

        Scope (\_GPE)
        {
            Method (_L09, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
            {
                Notify (\_SB.PCI0.AGP, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP01, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP02, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP03, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP04, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP05, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP07, 0x02) // Device Wake
                Notify (\_SB.PCI0.RP08, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEG3, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEG4, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEG5, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEG6, 0x02) // Device Wake
            }

            Method (_L0B, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
            {
                Notify (\_SB.PCI0.P0P1, 0x02) // Device Wake
            }

            Method (_L0D, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
            {
                Notify (\_SB.PCI0.HDEF, 0x02) // Device Wake
                Notify (\_SB.PCI0.GLAN, 0x02) // Device Wake
            }
        }
    }

    Scope (\_PR)
    {
        Processor (CPU0, 0x01, 0x00000410, 0x06){}
        Processor (CPU1, 0x02, 0x00000410, 0x06){}
        Processor (CPU2, 0x03, 0x00000410, 0x06){}
        Processor (CPU3, 0x04, 0x00000410, 0x06){}
        Processor (CPU4, 0x05, 0x00000410, 0x06){}
        Processor (CPU5, 0x06, 0x00000410, 0x06){}
        Processor (CPU6, 0x07, 0x00000410, 0x06){}
        Processor (CPU7, 0x08, 0x00000410, 0x06){}
    }

    Mutex (MUTX, 0x00)
    OperationRegion (PRT0, SystemIO, 0x80, 0x04)
    Field (PRT0, DWordAcc, Lock, Preserve)
    {
        P80H,   32
    }

    Method (P8XH, 2, Serialized)
    {
        If ((Arg0 == 0x00))
        {
            P80D = ((P80D & 0xFFFFFF00) | Arg1)
        }

        If ((Arg0 == 0x01))
        {
            P80D = ((P80D & 0xFFFF00FF) | (Arg1 << 0x08))
        }

        If ((Arg0 == 0x02))
        {
            P80D = ((P80D & 0xFF00FFFF) | (Arg1 << 0x10))
        }

        If ((Arg0 == 0x03))
        {
            P80D = ((P80D & 0x00FFFFFF) | (Arg1 << 0x18))
        }

        P80H = P80D /* \P80D */
    }

    OperationRegion (SPRT, SystemIO, 0xB2, 0x02)
    Field (SPRT, ByteAcc, Lock, Preserve)
    {
        SSMP,   8
    }

    Method (\_PIC, 1, NotSerialized)  // _PIC: Interrupt Model
    {
        GPIC = Arg0
        PICM = Arg0
    }

    Method (GETB, 3, Serialized)
    {
        Local0 = (Arg0 * 0x08)
        Local1 = (Arg1 * 0x08)
        CreateField (Arg2, Local0, Local1, TBF3)
        Return (TBF3) /* \GETB.TBF3 */
    }

    Method (TRAP, 2, Serialized)
    {
        Return (0x00)
    }

    Scope (\_SB.PCI0)
    {
        Method (IINI, 2, NotSerialized)
        {
            If ((Arg0 != 0x02))
            {
                Return (Zero)
            }

            OSYS = 0x07D0
            If (CondRefOf (\_OSI, Local0))
            {
                If (\_OSI ("Linux"))
                {
                    OSYS = 0x03E8
                }

                If (\_OSI ("Windows 2001"))
                {
                    OSYS = 0x07D1
                }

                If (\_OSI ("Windows 2001 SP1"))
                {
                    OSYS = 0x07D1
                }

                If (\_OSI ("Windows 2001 SP2"))
                {
                    OSYS = 0x07D2
                }

                If (\_OSI ("Windows 2006"))
                {
                    OSYS = 0x07D6
                }

                If (\_OSI ("Windows 2009"))
                {
                    OSYS = 0x07D9
                }
            }

            Return (Zero)
        }

        Method (NHPG, 0, Serialized)
        {
            ^RP01.HPEX = 0x00
            ^RP02.HPEX = 0x00
            ^RP03.HPEX = 0x00
            ^RP04.HPEX = 0x00
            ^RP01.HPSX = 0x01
            ^RP02.HPSX = 0x01
            ^RP03.HPSX = 0x01
            ^RP04.HPSX = 0x01
        }

        Method (NPME, 0, Serialized)
        {
            ^RP01.PMEX = 0x00
            ^RP02.PMEX = 0x00
            ^RP03.PMEX = 0x00
            ^RP04.PMEX = 0x00
            ^RP05.PMEX = 0x00
            ^RP07.PMEX = 0x00
            ^RP08.PMEX = 0x00
            ^RP01.PMSX = 0x01
            ^RP02.PMSX = 0x01
            ^RP03.PMSX = 0x01
            ^RP04.PMSX = 0x01
            ^RP05.PMSX = 0x01
            ^RP07.PMSX = 0x01
            ^RP08.PMSX = 0x01
        }
    }

    Scope (\)
    {
        Name (PICM, 0x00)
        Name (PRWP, Package (0x02)
        {
            Zero, 
            Zero
        })
        Method (GPRW, 2, NotSerialized)
        {
            PRWP [0x00] = Arg0
            PRWP [0x01] = Arg1
            Return (PRWP) /* \PRWP */
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (PDRC)
        {
            Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
            Name (_UID, 0x01)  // _UID: Unique ID
            Name (BUF0, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00004000,         // Address Length
                    _Y18)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00004000,         // Address Length
                    _Y1A)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y1B)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y1C)
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00000000,         // Address Length
                    _Y1D)
                Memory32Fixed (ReadWrite,
                    0xFED20000,         // Address Base
                    0x00020000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFED90000,         // Address Base
                    0x00004000,         // Address Length
                    _Y1E)
                Memory32Fixed (ReadWrite,
                    0xFED45000,         // Address Base
                    0x0004B000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFF000000,         // Address Base
                    0x01000000,         // Address Length
                    )
                Memory32Fixed (ReadOnly,
                    0xFEE00000,         // Address Base
                    0x00100000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y19)
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y18._BAS, RBR0)  // _BAS: Base Address
                RBR0 = (\_SB.PCI0.LPCB.RCBA << 0x0E)
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y19._BAS, TBR0)  // _BAS: Base Address
                TBR0 = TBAB /* \TBAB */
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y19._LEN, TBLN)  // _LEN: Length
                If ((TBAB == 0x00))
                {
                    TBLN = 0x00
                }

                If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                    ) == 0x000106A0)))
                {
                    CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1A._LEN, MBLN)  // _LEN: Length
                    MBLN = Zero
                }
                Else
                {
                    CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1A._BAS, MBR0)  // _BAS: Base Address
                    MBR0 = (\_SB.PCI0.MHBR << 0x0E)
                }

                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1B._BAS, DBR0)  // _BAS: Base Address
                DBR0 = (\_SB.PCI0.DIBR << 0x0C)
                If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                    ) == 0x000106A0)))
                {
                    DBR0 = (\_SB.PCI0.DIBI << 0x0C)
                }

                If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                    ) == 0x000106A0)))
                {
                    CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1C._LEN, EBLN)  // _LEN: Length
                    EBLN = Zero
                }
                Else
                {
                    CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1C._BAS, EBR0)  // _BAS: Base Address
                    EBR0 = (\_SB.PCI0.EPBR << 0x0C)
                }

                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1D._BAS, XBR0)  // _BAS: Base Address
                XBR0 = (\_SB.CPBG.IMCH.PXBR << 0x14)
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1D._LEN, XSZ0)  // _LEN: Length
                XSZ0 = (0x10000000 >> \_SB.CPBG.IMCH.PXSZ)
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1E._BAS, VTB0)  // _BAS: Base Address
                CreateDWordField (BUF0, \_SB.PCI0.PDRC._Y1E._LEN, VTLN)  // _LEN: Length
                If ((((PNHM & 0x000FFFF0) == 0x000106E0) | ((PNHM & 0x000FFFF0
                    ) == 0x000106A0)))
                {
                    If ((PNHM >= 0x000106E1))
                    {
                        If (\_SB.PCI0.IO10.VTEN)
                        {
                            VTB0 = (\_SB.PCI0.IO10.VTBA << 0x0C)
                        }
                        Else
                        {
                            VTLN = Zero
                        }
                    }
                    ElseIf (\_SB.PCI0.IIO0.VTEN)
                    {
                        VTB0 = (\_SB.PCI0.IIO0.VTBA << 0x0C)
                    }
                    Else
                    {
                        VTLN = Zero
                    }
                }
                ElseIf (\_SB.PCI0.ADVE)
                {
                    VTB0 = (\_SB.PCI0.ADVT << 0x0C)
                }
                Else
                {
                    VTLN = Zero
                }

                Return (BUF0) /* \_SB_.PCI0.PDRC.BUF0 */
            }
        }
    }

    Scope (\)
    {
        OperationRegion (IO_T, SystemIO, 0x1004, 0x10)
        Field (IO_T, ByteAcc, NoLock, Preserve)
        {
            TRPI,   16, 
            Offset (0x04), 
            Offset (0x06), 
            Offset (0x08), 
            TRP0,   8, 
            Offset (0x0A), 
            Offset (0x0B), 
            Offset (0x0C), 
            Offset (0x0D), 
            Offset (0x0E), 
            Offset (0x0F), 
            Offset (0x10)
        }

        OperationRegion (IO_D, SystemIO, 0x1000, 0x04)
        Field (IO_D, ByteAcc, NoLock, Preserve)
        {
            TRPD,   8
        }

        OperationRegion (IO_H, SystemIO, 0x1000, 0x04)
        Field (IO_H, ByteAcc, NoLock, Preserve)
        {
            TRPH,   8
        }

        OperationRegion (PMIO, SystemIO, 0x0400, 0x80)
        Field (PMIO, ByteAcc, NoLock, Preserve)
        {
            Offset (0x20), 
                ,   2, 
            SPST,   1, 
            Offset (0x42), 
                ,   1, 
            GPEC,   1, 
            Offset (0x64), 
                ,   9, 
            SCIS,   1, 
            Offset (0x66)
        }

        OperationRegion (GPIO, SystemIO, 0x0500, 0x64)
        Field (GPIO, ByteAcc, NoLock, Preserve)
        {
            GU00,   8, 
            GU01,   8, 
            GU02,   8, 
            GU03,   8, 
            GIO0,   8, 
            GIO1,   8, 
            GIO2,   8, 
            GIO3,   8, 
            Offset (0x0C), 
            GL00,   8, 
            GL01,   8, 
            GL02,   8, 
                ,   3, 
            GP27,   1, 
            GP28,   1, 
            Offset (0x10), 
            Offset (0x18), 
            GB00,   8, 
            GB01,   8, 
            GB02,   8, 
            GB03,   8, 
            Offset (0x2C), 
            GIV0,   8, 
            GIV1,   8, 
            GIV2,   8, 
            GIV3,   8, 
            GU04,   8, 
            GU05,   8, 
            GU06,   8, 
            GU07,   8, 
            GIO4,   8, 
            GIO5,   8, 
            GIO6,   8, 
            GIO7,   8, 
                ,   5, 
                ,   1, 
            Offset (0x39), 
            GL05,   8, 
            GL06,   8, 
            GL07,   8, 
            Offset (0x40), 
            GU08,   8, 
            GU09,   8, 
            GU0A,   8, 
            GU0B,   8, 
            GIO8,   8, 
            GIO9,   8, 
            GIOA,   8, 
            GIOB,   8, 
            GL08,   8, 
            GL09,   8, 
            GL0A,   8, 
            GL0B,   8
        }

        OperationRegion (RCRB, SystemMemory, SRCB, 0x4000)
        Field (RCRB, DWordAcc, Lock, Preserve)
        {
            Offset (0x1000), 
            Offset (0x3000), 
            Offset (0x3404), 
            HPAS,   2, 
                ,   5, 
            HPAE,   1, 
            Offset (0x3418), 
                ,   1, 
                ,   1, 
            SATD,   1, 
            SMBD,   1, 
            HDAD,   1, 
            Offset (0x341A), 
            RP1D,   1, 
            RP2D,   1, 
            RP3D,   1, 
            RP4D,   1, 
            RP5D,   1, 
            RP6D,   1, 
            RP7D,   1, 
            RP8D,   1
        }

        Method (GETP, 1, Serialized)
        {
            If (((Arg0 & 0x09) == 0x00))
            {
                Return (0xFFFFFFFF)
            }

            If (((Arg0 & 0x09) == 0x08))
            {
                Return (0x0384)
            }

            Local0 = ((Arg0 & 0x0300) >> 0x08)
            Local1 = ((Arg0 & 0x3000) >> 0x0C)
            Return ((0x1E * (0x09 - (Local0 + Local1))))
        }

        Method (GDMA, 5, Serialized)
        {
            If (Arg0)
            {
                If ((Arg1 && Arg4))
                {
                    Return (0x14)
                }

                If ((Arg2 && Arg4))
                {
                    Return (((0x04 - Arg3) * 0x0F))
                }

                Return (((0x04 - Arg3) * 0x1E))
            }

            Return (0xFFFFFFFF)
        }

        Method (GETT, 1, Serialized)
        {
            Return ((0x1E * (0x09 - (((Arg0 >> 0x02) & 0x03
                ) + (Arg0 & 0x03)))))
        }

        Method (GETF, 3, Serialized)
        {
            Name (TMPF, 0x00)
            If (Arg0)
            {
                TMPF |= 0x01
            }

            If ((Arg2 & 0x02))
            {
                TMPF |= 0x02
            }

            If (Arg1)
            {
                TMPF |= 0x04
            }

            If ((Arg2 & 0x20))
            {
                TMPF |= 0x08
            }

            If ((Arg2 & 0x4000))
            {
                TMPF |= 0x10
            }

            Return (TMPF) /* \GETF.TMPF */
        }

        Method (SETP, 3, Serialized)
        {
            If ((Arg0 > 0xF0))
            {
                Return (0x08)
            }
            Else
            {
                If ((Arg1 & 0x02))
                {
                    If (((Arg0 <= 0x78) && (Arg2 & 0x02)))
                    {
                        Return (0x2301)
                    }

                    If (((Arg0 <= 0xB4) && (Arg2 & 0x01)))
                    {
                        Return (0x2101)
                    }
                }

                Return (0x1001)
            }
        }

        Method (SDMA, 1, Serialized)
        {
            If ((Arg0 <= 0x14))
            {
                Return (0x01)
            }

            If ((Arg0 <= 0x1E))
            {
                Return (0x02)
            }

            If ((Arg0 <= 0x2D))
            {
                Return (0x01)
            }

            If ((Arg0 <= 0x3C))
            {
                Return (0x02)
            }

            If ((Arg0 <= 0x5A))
            {
                Return (0x01)
            }

            Return (0x00)
        }

        Method (SETT, 3, Serialized)
        {
            If ((Arg1 & 0x02))
            {
                If (((Arg0 <= 0x78) && (Arg2 & 0x02)))
                {
                    Return (0x0B)
                }

                If (((Arg0 <= 0xB4) && (Arg2 & 0x01)))
                {
                    Return (0x09)
                }
            }

            Return (0x04)
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (SAT0)
        {
            Name (_ADR, 0x001F0002)  // _ADR: Address
            OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
            Field (SACS, DWordAcc, NoLock, Preserve)
            {
                PRIT,   16, 
                SECT,   16, 
                PSIT,   4, 
                SSIT,   4, 
                Offset (0x08), 
                SYNC,   4, 
                Offset (0x0A), 
                SDT0,   2, 
                    ,   2, 
                SDT1,   2, 
                Offset (0x0B), 
                SDT2,   2, 
                    ,   2, 
                SDT3,   2, 
                Offset (0x14), 
                ICR0,   4, 
                ICR1,   4, 
                ICR2,   4, 
                ICR3,   4, 
                ICR4,   4, 
                ICR5,   4, 
                Offset (0x50), 
                MAPV,   2, 
                    ,   4, 
                SAMS,   2
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Device (PRT0)
            {
                Name (_ADR, 0xFFFF)  // _ADR: Address
                Name (GTF0, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                })
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((SAMS != 0x00))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

                Method (_SDD, 1, NotSerialized)  // _SDD: Set Device Data
                {
                    Name (FFS0, Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    })
                    CreateByteField (FFS0, 0x00, FF00)
                    CreateByteField (FFS0, 0x06, FF06)
                    If ((SizeOf (Arg0) == 0x0200))
                    {
                        If ((FFSN != 0x00))
                        {
                            CreateWordField (Arg0, 0x0134, W154)
                            CreateWordField (Arg0, 0x0138, W156)
                            If (((W154 == 0x1028) & ((W156 & 0x4000) == 0x4000)))
                            {
                                If (((W156 & 0x8000) == 0x00))
                                {
                                    FF00 = 0x5A
                                    FF06 = 0xEF
                                }
                            }
                        }
                    }

                    GTF0 = FFS0 /* \_SB_.PCI0.SAT0.PRT0._SDD.FFS0 */
                }

                Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                {
                    Return (GTF0) /* \_SB_.PCI0.SAT0.PRT0.GTF0 */
                }
            }

            Device (PRI)
            {
                Name (_ADR, 0x00)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((SAMS == 0x00))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }
            }

            Device (SEC0)
            {
                Name (_ADR, 0x01)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((SAMS == 0x00))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

                Device (MAST)
                {
                    Name (_ADR, 0x00)  // _ADR: Address
                    Method (_EJ0, 1, NotSerialized)  // _EJx: Eject Device, x=0-9
                    {
                        GENS (0x17, 0x02, 0x00)
                        Return (0x00)
                    }

                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Local0 = GENS (0x17, 0x01, 0x00)
                        If (Local0)
                        {
                            Return (0x0F)
                        }

                        Return (0x00)
                    }
                }
            }

            Method (\_SB.PCI0.SAT0.SEC0.ODDE, 2, NotSerialized)
            {
                Notify (\_SB.PCI0.SAT0.SEC0.MAST, 0x01) // Device Check
                If ((OSID () >= 0x10))
                {
                    Notify (\_SB.PCI0.SAT0.SEC0, 0x01) // Device Check
                }
            }
        }

        Device (SAT1)
        {
            Name (_ADR, 0x001F0005)  // _ADR: Address
            OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
            Field (SACS, DWordAcc, NoLock, Preserve)
            {
                PRIT,   16, 
                SECT,   16, 
                PSIT,   4, 
                SSIT,   4, 
                Offset (0x08), 
                SYNC,   4, 
                Offset (0x0A), 
                SDT0,   2, 
                    ,   2, 
                SDT1,   2, 
                Offset (0x0B), 
                SDT2,   2, 
                    ,   2, 
                SDT3,   2, 
                Offset (0x14), 
                ICR0,   4, 
                ICR1,   4, 
                ICR2,   4, 
                ICR3,   4, 
                ICR4,   4, 
                ICR5,   4, 
                Offset (0x50), 
                MAPV,   2, 
                    ,   4, 
                SAMS,   2
            }
        }

        Device (SBUS)
        {
            Name (_ADR, 0x001F0003)  // _ADR: Address
            OperationRegion (SMBP, PCI_Config, 0x40, 0xC0)
            Field (SMBP, DWordAcc, NoLock, Preserve)
            {
                    ,   2, 
                I2CE,   1
            }

            OperationRegion (SMPB, PCI_Config, 0x20, 0x04)
            Field (SMPB, DWordAcc, NoLock, Preserve)
            {
                    ,   5, 
                SBAR,   11
            }

            OperationRegion (SMBI, SystemIO, (SBAR << 0x05), 0x10)
            Field (SMBI, ByteAcc, NoLock, Preserve)
            {
                HSTS,   8, 
                Offset (0x02), 
                HCON,   8, 
                HCOM,   8, 
                TXSA,   8, 
                DAT0,   8, 
                DAT1,   8, 
                HBDR,   8, 
                PECR,   8, 
                RXSA,   8, 
                SDAT,   16
            }

            Method (SSXB, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (0x00)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = Arg0
                HCOM = Arg1
                HCON = 0x48
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (0x01)
                }

                Return (0x00)
            }

            Method (SRXB, 1, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = (Arg0 | 0x01)
                HCON = 0x44
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (DAT0) /* \_SB_.PCI0.SBUS.DAT0 */
                }

                Return (0xFFFF)
            }

            Method (SWRB, 3, Serialized)
            {
                If (STRT ())
                {
                    Return (0x00)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = Arg0
                HCOM = Arg1
                DAT0 = Arg2
                HCON = 0x48
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (0x01)
                }

                Return (0x00)
            }

            Method (SRDB, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = (Arg0 | 0x01)
                HCOM = Arg1
                HCON = 0x48
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (DAT0) /* \_SB_.PCI0.SBUS.DAT0 */
                }

                Return (0xFFFF)
            }

            Method (SWRW, 3, Serialized)
            {
                If (STRT ())
                {
                    Return (0x00)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = Arg0
                HCOM = Arg1
                DAT1 = (Arg2 & 0xFF)
                DAT0 = ((Arg2 >> 0x08) & 0xFF)
                HCON = 0x4C
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (0x01)
                }

                Return (0x00)
            }

            Method (SRDW, 2, Serialized)
            {
                If (STRT ())
                {
                    Return (0xFFFF)
                }

                I2CE = 0x00
                HSTS = 0xBF
                TXSA = (Arg0 | 0x01)
                HCOM = Arg1
                HCON = 0x4C
                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (((DAT0 << 0x08) | DAT1))
                }

                Return (0xFFFFFFFF)
            }

            Method (SBLW, 4, Serialized)
            {
                If (STRT ())
                {
                    Return (0x00)
                }

                I2CE = Arg3
                HSTS = 0xBF
                TXSA = Arg0
                HCOM = Arg1
                DAT0 = SizeOf (Arg2)
                Local1 = 0x00
                HBDR = DerefOf (Arg2 [0x00])
                HCON = 0x54
                While ((SizeOf (Arg2) > Local1))
                {
                    Local0 = 0x0FA0
                    While ((!(HSTS & 0x80) && Local0))
                    {
                        Local0--
                        Stall (0x32)
                    }

                    If (!Local0)
                    {
                        KILL ()
                        Return (0x00)
                    }

                    HSTS = 0x80
                    Local1++
                    If ((SizeOf (Arg2) > Local1))
                    {
                        HBDR = DerefOf (Arg2 [Local1])
                    }
                }

                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (0x01)
                }

                Return (0x00)
            }

            Method (SBLR, 3, Serialized)
            {
                Name (TBUF, Buffer (0x0100){})
                If (STRT ())
                {
                    Return (0x00)
                }

                I2CE = Arg2
                HSTS = 0xBF
                TXSA = (Arg0 | 0x01)
                HCOM = Arg1
                HCON = 0x54
                Local0 = 0x0FA0
                While ((!(HSTS & 0x80) && Local0))
                {
                    Local0--
                    Stall (0x32)
                }

                If (!Local0)
                {
                    KILL ()
                    Return (0x00)
                }

                TBUF [0x00] = DAT0 /* \_SB_.PCI0.SBUS.DAT0 */
                HSTS = 0x80
                Local1 = 0x01
                While ((Local1 < DerefOf (TBUF [0x00])))
                {
                    Local0 = 0x0FA0
                    While ((!(HSTS & 0x80) && Local0))
                    {
                        Local0--
                        Stall (0x32)
                    }

                    If (!Local0)
                    {
                        KILL ()
                        Return (0x00)
                    }

                    TBUF [Local1] = HBDR /* \_SB_.PCI0.SBUS.HBDR */
                    HSTS = 0x80
                    Local1++
                }

                If (COMP ())
                {
                    HSTS |= 0xFF
                    Return (TBUF) /* \_SB_.PCI0.SBUS.SBLR.TBUF */
                }

                Return (0x00)
            }

            Method (STRT, 0, Serialized)
            {
                Local0 = 0xC8
                While (Local0)
                {
                    If ((HSTS & 0x40))
                    {
                        Local0--
                        Sleep (0x01)
                        If ((Local0 == 0x00))
                        {
                            Return (0x01)
                        }
                    }
                    Else
                    {
                        Local0 = 0x00
                    }
                }

                Local0 = 0x0FA0
                While (Local0)
                {
                    If ((HSTS & 0x01))
                    {
                        Local0--
                        Stall (0x32)
                        If ((Local0 == 0x00))
                        {
                            KILL ()
                        }
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

                Return (0x01)
            }

            Method (COMP, 0, Serialized)
            {
                Local0 = 0x0FA0
                While (Local0)
                {
                    If ((HSTS & 0x02))
                    {
                        Return (0x01)
                    }
                    Else
                    {
                        Local0--
                        Stall (0x32)
                        If ((Local0 == 0x00))
                        {
                            KILL ()
                        }
                    }
                }

                Return (0x00)
            }

            Method (KILL, 0, Serialized)
            {
                HCON |= 0x02
                HSTS |= 0xFF
            }
        }
    }

    Scope (\_SB)
    {
        Device (ALS)
        {
            Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Name (ABUF, Buffer (0x02){})
                CreateByteField (ABUF, 0x00, ACMD)
                CreateByteField (ABUF, 0x01, ADAT)
                ACMD = 0x04
                Local0 = GENS (0x09, ABUF, SizeOf (ABUF))
                If ((ADAT == Zero))
                {
                    Local0 = Zero
                }
                Else
                {
                    Local0 = 0x0F
                }

                Return (Local0)
            }

            Method (_ALI, 0, NotSerialized)  // _ALI: Ambient Light Illuminance
            {
                Name (ABUF, Buffer (0x02){})
                CreateByteField (ABUF, 0x00, ACMD)
                CreateByteField (ABUF, 0x01, ADAT)
                ACMD = 0x05
                Local0 = GENS (0x09, ABUF, SizeOf (ABUF))
                If ((ADAT == Zero))
                {
                    Local0 = Zero
                }
                Else
                {
                    Local0 = 0x0F
                }

                Return (Local0)
            }

            Name (_ALR, Package (0x05)  // _ALR: Ambient Light Response
            {
                Package (0x02)
                {
                    0x46, 
                    0x00
                }, 

                Package (0x02)
                {
                    0x49, 
                    0x0A
                }, 

                Package (0x02)
                {
                    0x55, 
                    0x50
                }, 

                Package (0x02)
                {
                    0x64, 
                    0x012C
                }, 

                Package (0x02)
                {
                    0x96, 
                    0x03E8
                }
            })
        }
    }

    Scope (\_SB)
    {
        Device (CPBG)
        {
            Name (_HID, EisaId ("PNP0A03") /* PCI Bus */)  // _HID: Hardware ID
            Name (_UID, 0xFF)  // _UID: Unique ID
            Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
            {
                Return (((\PELN >> 0x14) - 0x01))
            }

            Name (_ADR, 0x00)  // _ADR: Address
            Name (BUF0, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x00FF,             // Range Minimum
                    0x00FF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0001,             // Length
                    ,, _Y1F)
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateWordField (BUF0, \_SB.CPBG._Y1F._MIN, PBMN)  // _MIN: Minimum Base Address
                PBMN = ((\PELN >> 0x14) - 0x01)
                CreateWordField (BUF0, \_SB.CPBG._Y1F._MAX, PBMX)  // _MAX: Maximum Base Address
                PBMX = ((\PELN >> 0x14) - 0x01)
                Return (BUF0) /* \_SB_.CPBG.BUF0 */
            }

            Device (IMCH)
            {
                Name (_ADR, 0x01)  // _ADR: Address
                OperationRegion (PBUS, PCI_Config, 0x00, 0xC0)
                Field (PBUS, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x40), 
                        ,   4, 
                    PM0H,   2, 
                    Offset (0x41), 
                    PM1L,   2, 
                        ,   2, 
                    PM1H,   2, 
                    Offset (0x42), 
                    PM2L,   2, 
                        ,   2, 
                    PM2H,   2, 
                    Offset (0x43), 
                    PM3L,   2, 
                        ,   2, 
                    PM3H,   2, 
                    Offset (0x44), 
                    PM4L,   2, 
                        ,   2, 
                    PM4H,   2, 
                    Offset (0x45), 
                    PM5L,   2, 
                        ,   2, 
                    PM5H,   2, 
                    Offset (0x46), 
                    PM6L,   2, 
                        ,   2, 
                    PM6H,   2, 
                    Offset (0x47), 
                    Offset (0x48), 
                        ,   7, 
                    HENA,   1, 
                    Offset (0x50), 
                    PXEN,   1, 
                    PXSZ,   2, 
                        ,   17, 
                    PXBR,   12
                }
            }
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (A_CC)
        {
            Name (_HID, "SMO8800")  // _HID: Hardware ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_UID, One)  // _UID: Unique ID
            Name (BUF2, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                {
                    0x00000017,
                }
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Return (BUF2) /* \_SB_.PCI0.A_CC.BUF2 */
            }

            Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
            {
                Return (BUF2) /* \_SB_.PCI0.A_CC.BUF2 */
            }
        }
    }

    Device (\_SB.PCI0.LPCB.TPM)
    {
        Name (_HID, EisaId ("BCM0102"))  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0C31"))  // _CID: Compatible ID
        Name (_STR, Unicode ("TPM 1.2 Device"))  // _STR: Description String
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Memory32Fixed (ReadOnly,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })
        OperationRegion (SMIP, SystemIO, 0xB2, 0x01)
        Field (SMIP, ByteAcc, NoLock, Preserve)
        {
            IOB2,   8
        }

        OperationRegion (TPMR, SystemMemory, 0xFED40000, 0x5000)
        Field (TPMR, AnyAcc, NoLock, Preserve)
        {
            ACC0,   8
        }

        Method (PTS, 1, Serialized)
        {
            If (((Arg0 < 0x06) && (Arg0 > 0x03)))
            {
                If (!(MORD & 0x10))
                {
                    TCGP = 0x02
                    IOB2 = 0x5A
                }
            }

            Return (0x00)
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If ((TPME == 0x00))
            {
                Return (0x00)
            }

            If ((ACC0 != 0xFF))
            {
                Return (0x0F)
            }
            Else
            {
                Return (0x00)
            }
        }

        Method (HINF, 3, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
            _T_0 = ToInteger (Arg1)
            If ((_T_0 == 0x00))
            {
                Return (Buffer (0x01)
                {
                     0x01                                             // .
                })
            }
            ElseIf ((_T_0 == 0x01))
            {
                If ((_STA () == 0x00))
                {
                    Return (Package (0x01)
                    {
                        0x00
                    })
                }

                Return (Package (0x02)
                {
                    0x01, 
                    Package (0x02)
                    {
                        0x01, 
                        0x20
                    }
                })
            }
            Else
            {
                BreakPoint
            }

            Return (Buffer (0x00){})
        }

        Name (TPM2, Package (0x02)
        {
            Zero, 
            Zero
        })
        Name (TPM3, Package (0x03)
        {
            Zero, 
            Zero, 
            Zero
        })
        Method (TPPI, 3, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
            _T_0 = ToInteger (Arg1)
            If ((_T_0 == 0x00))
            {
                Return (Buffer (0x01)
                {
                     0x3F                                             // ?
                })
            }
            ElseIf ((_T_0 == 0x01))
            {
                Return ("1.0")
            }
            ElseIf ((_T_0 == 0x02))
            {
                PPRQ = ToInteger (Arg2)
                TCGP = 0x02
                IOB2 = 0x5B
                Return (0x00)
            }
            ElseIf ((_T_0 == 0x03))
            {
                TPM2 [0x01] = PPRQ /* \PPRQ */
                Return (TPM2) /* \_SB_.PCI0.LPCB.TPM_.TPM2 */
            }
            ElseIf ((_T_0 == 0x04))
            {
                Return (0x02)
            }
            ElseIf ((_T_0 == 0x05))
            {
                TCGP = 0x05
                IOB2 = 0x5B
                TPM3 [0x01] = LPPR /* \LPPR */
                TPM3 [0x02] = PPRP /* \PPRP */
                Return (TPM3) /* \_SB_.PCI0.LPCB.TPM_.TPM3 */
            }
            ElseIf ((_T_0 == 0x06))
            {
                Return (0x00)
            }
            Else
            {
                BreakPoint
            }

            Return (0x01)
        }

        Method (SMBS, 3, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
            _T_0 = ToInteger (Arg1)
            If ((_T_0 == 0x00))
            {
                Return (Buffer (0x01)
                {
                     0x01                                             // .
                })
            }
            ElseIf ((_T_0 == 0x01))
            {
                MORD = ToInteger (Arg2)
                TCGP = 0x01
                IOB2 = 0x5A
                Return (0x00)
            }
            Else
            {
                BreakPoint
            }

            Return (0x01)
        }

        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("cf8e16a5-c1e8-4e25-b712-4f54a96702c8") /* Unknown UUID */))
            {
                Return (HINF (Arg1, Arg2, Arg3))
            }

            If ((Arg0 == ToUUID ("3dddfaa6-361b-4eb4-a424-8d10089d1653") /* Physical Presence Interface */))
            {
                Return (TPPI (Arg1, Arg2, Arg3))
            }

            If ((Arg0 == ToUUID ("376054ed-cc13-4675-901c-4756d7f2d45d") /* Unknown UUID */))
            {
                Return (SMBS (Arg1, Arg2, Arg3))
            }

            Return (Buffer (0x01)
            {
                 0x00                                             // .
            })
        }
    }

    Scope (\_PR)
    {
        Method (PPCE, 2, NotSerialized)
        {
            Local0 = GENS (0x15, 0x00, 0x00)
            \_PR.CPU0._PPC = Local0
            Notify (CPU0, 0x80) // Performance Capability Change
            Sleep (0x64)
            If ((TCNT >= 0x02))
            {
                Notify (CPU1, 0x80) // Performance Capability Change
                Sleep (0x64)
                If ((TCNT >= 0x04))
                {
                    Notify (CPU2, 0x80) // Performance Capability Change
                    Sleep (0x64)
                    Notify (CPU3, 0x80) // Performance Capability Change
                    Sleep (0x64)
                    If ((TCNT >= 0x08))
                    {
                        Notify (CPU4, 0x80) // Performance Capability Change
                        Sleep (0x64)
                        Notify (CPU5, 0x80) // Performance Capability Change
                        Sleep (0x64)
                        Notify (CPU6, 0x80) // Performance Capability Change
                        Sleep (0x64)
                        Notify (CPU7, 0x80) // Performance Capability Change
                        Sleep (0x64)
                    }
                }
            }
        }
    }

    Device (\_SB.PCI0.LPCB.TCM)
    {
        Name (_HID, EisaId ("ZIC0101"))  // _HID: Hardware ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Memory32Fixed (ReadOnly,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })
        OperationRegion (TCMR, SystemMemory, 0xFED40000, 0x5000)
        Field (TCMR, AnyAcc, NoLock, Preserve)
        {
            ACC0,   8, 
            Offset (0xF00), 
            VID,    16
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If ((TCME == 0x00))
            {
                Return (0x00)
            }

            If ((VID == 0x1B4E))
            {
                Return (0x0F)
            }
            Else
            {
                Return (0x00)
            }
        }
    }

    Scope (\_SB.PCI0)
    {
        Method (UPRW, 0, NotSerialized)
        {
            Local0 = GENS (0x18, 0x01, 0x00)
            Return (Local0)
        }

        Device (EHC2)
        {
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Name (_S1D, 0x02)  // _S1D: S1 Device State
            Name (_S3D, 0x02)  // _S3D: S3 Device State
            Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
            {
                Local0 = UPRW ()
                If ((Local0 == 0x03))
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x03
                    })
                }

                If ((Local0 == 0x01))
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x01
                    })
                }

                Return (Package (0x02)
                {
                    0x0D, 
                    0x00
                })
            }

            Device (RHUB)
            {
                Name (_ADR, 0x00)  // _ADR: Address
                Device (PRT1)
                {
                    Name (_ADR, 0x01)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0x00, 
                        0xFF, 
                        0x00, 
                        0x00
                    })
                    Device (PRT1)
                    {
                        Name (_ADR, 0x01)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                        Name (_EJD, "\\_SB.PCI0.RP04.PXSX")  // _EJD: Ejection Dependent Device
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }
                }

                Device (PRT2)
                {
                    Name (_ADR, 0x02)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0x00, 
                        0xFF, 
                        0x00, 
                        0x00
                    })
                }
            }
        }

        Device (EHCI)
        {
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Name (_S1D, 0x02)  // _S1D: S1 Device State
            Name (_S3D, 0x02)  // _S3D: S3 Device State
            Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
            {
                Local0 = UPRW ()
                If ((Local0 == 0x03))
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x03
                    })
                }

                If ((Local0 == 0x01))
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x01
                    })
                }

                Return (Package (0x02)
                {
                    0x0D, 
                    0x00
                })
            }

            Device (RHUB)
            {
                Name (_ADR, 0x00)  // _ADR: Address
                Device (PRT1)
                {
                    Name (_ADR, 0x01)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0x00, 
                        0xFF, 
                        0x00, 
                        0x00
                    })
                    Device (PRT1)
                    {
                        Name (_ADR, 0x01)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x00, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x1,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "RIGHT",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "RIGHT",
                            PLD_Shape              = "HORIZONTALRECTANGLE",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x00, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x1,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "LEFT",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "CENTER",
                            PLD_Shape              = "HORIZONTALRECTANGLE",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x00, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x1,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "LEFT",
                            PLD_VerticalPosition   = "LOWER",
                            PLD_HorizontalPosition = "CENTER",
                            PLD_Shape              = "HORIZONTALRECTANGLE",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x00, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x1,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "RIGHT",
                            PLD_VerticalPosition   = "LOWER",
                            PLD_HorizontalPosition = "RIGHT",
                            PLD_Shape              = "HORIZONTALRECTANGLE",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x1,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x1,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT7)
                    {
                        Name (_ADR, 0x07)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0x02, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x1,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "RIGHT",
                            PLD_VerticalPosition   = "CENTER",
                            PLD_HorizontalPosition = "CENTER",
                            PLD_Shape              = "HORIZONTALRECTANGLE",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x1,
                            PLD_EjectRequired      = 0x1,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }

                    Device (PRT8)
                    {
                        Name (_ADR, 0x08)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            0xFF, 
                            0x00, 
                            0x00
                        })
                        Name (_PLD, ToPLD (
                            PLD_Revision           = 0x1,
                            PLD_IgnoreColor        = 0x1,
                            PLD_Red                = 0x0,
                            PLD_Green              = 0x0,
                            PLD_Blue               = 0x0,
                            PLD_Width              = 0x0,
                            PLD_Height             = 0x0,
                            PLD_UserVisible        = 0x0,
                            PLD_Dock               = 0x0,
                            PLD_Lid                = 0x0,
                            PLD_Panel              = "UNKNOWN",
                            PLD_VerticalPosition   = "UPPER",
                            PLD_HorizontalPosition = "LEFT",
                            PLD_Shape              = "UNKNOWN",
                            PLD_GroupOrientation   = 0x0,
                            PLD_GroupToken         = 0x0,
                            PLD_GroupPosition      = 0x0,
                            PLD_Bay                = 0x0,
                            PLD_Ejectable          = 0x0,
                            PLD_EjectRequired      = 0x0,
                            PLD_CabinetNumber      = 0x0,
                            PLD_CardCageNumber     = 0x0,
                            PLD_Reference          = 0x0,
                            PLD_Rotation           = 0x0,
                            PLD_Order              = 0x0)
)  // _PLD: Physical Location of Device
                    }
                }

                Device (PRT2)
                {
                    Name (_ADR, 0x02)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0x00, 
                        0xFF, 
                        0x00, 
                        0x00
                    })
                }
            }
        }
    }

    Scope (\_GPE)
    {
        Method (NWAK, 2, NotSerialized)
        {
            _L01 ()
        }

        Method (_L01, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            If (((RP1D == 0x00) && \_SB.PCI0.RP01.HPSX))
            {
                \_SB.PCI0.RP01.HPSX = 0x01
            }

            If (((RP1D == 0x00) && \_SB.PCI0.RP01.PDCX))
            {
                \_SB.PCI0.RP01.PDCX = 0x01
            }

            If (((RP2D == 0x00) && \_SB.PCI0.RP02.HPSX))
            {
                \_SB.PCI0.RP02.HPSX = 0x01
            }

            If (((RP2D == 0x00) && \_SB.PCI0.RP02.PDCX))
            {
                \_SB.PCI0.RP02.PDCX = 0x01
            }

            If (((RP3D == 0x00) && \_SB.PCI0.RP03.HPSX))
            {
                \_SB.PCI0.RP03.HPSX = 0x01
            }

            If (((RP3D == 0x00) && \_SB.PCI0.RP03.PDCX))
            {
                \_SB.PCI0.RP03.PDCX = 0x01
            }

            If (((RP4D == 0x00) && \_SB.PCI0.RP04.HPSX))
            {
                \_SB.PCI0.RP04.HPSX = 0x01
            }

            If (((RP4D == 0x00) && \_SB.PCI0.RP04.PDCX))
            {
                \_SB.PCI0.RP04.PDCX = 0x01
            }

            If (((RP5D == 0x00) && \_SB.PCI0.RP05.HPSX))
            {
                \_SB.PCI0.RP05.HPSX = 0x01
            }

            If (((RP5D == 0x00) && \_SB.PCI0.RP05.PDCX))
            {
                \_SB.PCI0.RP05.PDCX = 0x01
            }

            Notify (\_SB.PCI0, 0x00) // Bus Check
        }

        Method (_L18, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            Local0 = 0x00
        }
    }

    Name (APRE, 0x00)
    Scope (\_SB.PCI0.LPCB)
    {
        Device (ECDV)
        {
            Name (_HID, EisaId ("PNP0C09") /* Embedded Controller Device */)  // _HID: Hardware ID
            Name (_UID, 0x00)  // _UID: Unique ID
            Name (ECRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    _Y20)
                IO (Decode16,
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    _Y21)
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                CreateWordField (ECRS, \_SB.PCI0.LPCB.ECDV._Y20._MIN, DMIN)  // _MIN: Minimum Base Address
                CreateWordField (ECRS, \_SB.PCI0.LPCB.ECDV._Y20._MAX, DMAX)  // _MAX: Maximum Base Address
                CreateWordField (ECRS, \_SB.PCI0.LPCB.ECDV._Y21._MIN, CMIN)  // _MIN: Minimum Base Address
                CreateWordField (ECRS, \_SB.PCI0.LPCB.ECDV._Y21._MAX, CMAX)  // _MAX: Maximum Base Address
                Local0 = (0x0900 + 0x30)
                DMIN = Local0
                DMAX = Local0
                Local0 = (0x0900 + 0x34)
                CMIN = Local0
                CMAX = Local0
                Return (ECRS) /* \_SB_.PCI0.LPCB.ECDV.ECRS */
            }

            Name (_GPE, 0x10)  // _GPE: General Purpose Events
            Name (ECIB, Buffer (0xFF){})
            OperationRegion (ECOR, EmbeddedControl, 0x00, 0xFF)
            Field (ECOR, ByteAcc, Lock, Preserve)
            {
                EC00,   8, 
                EC01,   8, 
                EC02,   8, 
                EC03,   8, 
                EC04,   8, 
                EC05,   8, 
                EC06,   8, 
                EC07,   8, 
                EC08,   8, 
                EC09,   8, 
                EC10,   8, 
                EC11,   8, 
                EC12,   8, 
                EC13,   8, 
                EC14,   8, 
                EC15,   8, 
                EC16,   8, 
                EC17,   8, 
                EC18,   8, 
                EC19,   8, 
                EC20,   8, 
                EC21,   8, 
                EC22,   8, 
                EC23,   8, 
                EC24,   8, 
                EC25,   8, 
                EC26,   8, 
                EC27,   8, 
                EC28,   8, 
                EC29,   8, 
                EC30,   8, 
                EC31,   8, 
                EC32,   8, 
                EC33,   8, 
                EC34,   8, 
                EC35,   8, 
                EC36,   8, 
                EC37,   8, 
                EC38,   8, 
                EC39,   8, 
                EC40,   8, 
                EC41,   8, 
                EC42,   8, 
                EC43,   8, 
                EC44,   8, 
                EC45,   8, 
                EC46,   8, 
                EC47,   8, 
                EC48,   8, 
                EC49,   8
            }

            Method (ECIN, 0, NotSerialized)
            {
                ECS3 ()
                ECS2 (ACOS)
            }

            Method (_REG, 2, NotSerialized)  // _REG: Region Availability
            {
                If (((Arg0 == 0x03) && (Arg1 == 0x01)))
                {
                    ECIN ()
                    \ECRD = 0x01
                }
            }

            Method (ECM9, 2, NotSerialized)
            {
                ECIN ()
            }

            Method (_Q66, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
            {
                If ((\ECRD != 0x01))
                {
                    Return (Zero)
                }

                \NEVT ()
                Return (Zero)
            }

            Method (ECR1, 1, NotSerialized)
            {
                If ((\ECRD == 0x00))
                {
                    Local0 = EISC (0x80, Arg0, 0x00)
                    Return (Local0)
                }

                Acquire (\ECMX, 0xFFFF)
                Local0 = 0x00
                If ((Arg0 == 0x00))
                {
                    Local0 = EC00 /* \_SB_.PCI0.LPCB.ECDV.EC00 */
                }

                If ((Arg0 == 0x01))
                {
                    Local0 = EC01 /* \_SB_.PCI0.LPCB.ECDV.EC01 */
                }

                If ((Arg0 == 0x02))
                {
                    Local0 = EC02 /* \_SB_.PCI0.LPCB.ECDV.EC02 */
                }

                If ((Arg0 == 0x03))
                {
                    Local0 = EC03 /* \_SB_.PCI0.LPCB.ECDV.EC03 */
                }

                If ((Arg0 == 0x04))
                {
                    Local0 = EC04 /* \_SB_.PCI0.LPCB.ECDV.EC04 */
                }

                If ((Arg0 == 0x05))
                {
                    Local0 = EC05 /* \_SB_.PCI0.LPCB.ECDV.EC05 */
                }

                If ((Arg0 == 0x06))
                {
                    Local0 = EC06 /* \_SB_.PCI0.LPCB.ECDV.EC06 */
                }

                If ((Arg0 == 0x07))
                {
                    Local0 = EC07 /* \_SB_.PCI0.LPCB.ECDV.EC07 */
                }

                If ((Arg0 == 0x08))
                {
                    Local0 = EC08 /* \_SB_.PCI0.LPCB.ECDV.EC08 */
                }

                If ((Arg0 == 0x09))
                {
                    Local0 = EC09 /* \_SB_.PCI0.LPCB.ECDV.EC09 */
                }

                If ((Arg0 == 0x0A))
                {
                    Local0 = EC10 /* \_SB_.PCI0.LPCB.ECDV.EC10 */
                }

                If ((Arg0 == 0x0B))
                {
                    Local0 = EC11 /* \_SB_.PCI0.LPCB.ECDV.EC11 */
                }

                If ((Arg0 == 0x0C))
                {
                    Local0 = EC12 /* \_SB_.PCI0.LPCB.ECDV.EC12 */
                }

                If ((Arg0 == 0x0D))
                {
                    Local0 = EC13 /* \_SB_.PCI0.LPCB.ECDV.EC13 */
                }

                If ((Arg0 == 0x0E))
                {
                    Local0 = EC14 /* \_SB_.PCI0.LPCB.ECDV.EC14 */
                }

                If ((Arg0 == 0x0F))
                {
                    Local0 = EC15 /* \_SB_.PCI0.LPCB.ECDV.EC15 */
                }

                If ((Arg0 == 0x10))
                {
                    Local0 = EC16 /* \_SB_.PCI0.LPCB.ECDV.EC16 */
                }

                If ((Arg0 == 0x11))
                {
                    Local0 = EC17 /* \_SB_.PCI0.LPCB.ECDV.EC17 */
                }

                If ((Arg0 == 0x12))
                {
                    Local0 = EC18 /* \_SB_.PCI0.LPCB.ECDV.EC18 */
                }

                If ((Arg0 == 0x13))
                {
                    Local0 = EC19 /* \_SB_.PCI0.LPCB.ECDV.EC19 */
                }

                If ((Arg0 == 0x14))
                {
                    Local0 = EC20 /* \_SB_.PCI0.LPCB.ECDV.EC20 */
                }

                If ((Arg0 == 0x15))
                {
                    Local0 = EC21 /* \_SB_.PCI0.LPCB.ECDV.EC21 */
                }

                If ((Arg0 == 0x16))
                {
                    Local0 = EC22 /* \_SB_.PCI0.LPCB.ECDV.EC22 */
                }

                If ((Arg0 == 0x17))
                {
                    Local0 = EC23 /* \_SB_.PCI0.LPCB.ECDV.EC23 */
                }

                If ((Arg0 == 0x18))
                {
                    Local0 = EC24 /* \_SB_.PCI0.LPCB.ECDV.EC24 */
                }

                If ((Arg0 == 0x19))
                {
                    Local0 = EC25 /* \_SB_.PCI0.LPCB.ECDV.EC25 */
                }

                If ((Arg0 == 0x1A))
                {
                    Local0 = EC26 /* \_SB_.PCI0.LPCB.ECDV.EC26 */
                }

                If ((Arg0 == 0x1B))
                {
                    Local0 = EC27 /* \_SB_.PCI0.LPCB.ECDV.EC27 */
                }

                If ((Arg0 == 0x1C))
                {
                    Local0 = EC28 /* \_SB_.PCI0.LPCB.ECDV.EC28 */
                }

                If ((Arg0 == 0x1D))
                {
                    Local0 = EC29 /* \_SB_.PCI0.LPCB.ECDV.EC29 */
                }

                If ((Arg0 == 0x1E))
                {
                    Local0 = EC30 /* \_SB_.PCI0.LPCB.ECDV.EC30 */
                }

                If ((Arg0 == 0x1F))
                {
                    Local0 = EC31 /* \_SB_.PCI0.LPCB.ECDV.EC31 */
                }

                If ((Arg0 == 0x20))
                {
                    Local0 = EC32 /* \_SB_.PCI0.LPCB.ECDV.EC32 */
                }

                If ((Arg0 == 0x21))
                {
                    Local0 = EC33 /* \_SB_.PCI0.LPCB.ECDV.EC33 */
                }

                If ((Arg0 == 0x22))
                {
                    Local0 = EC34 /* \_SB_.PCI0.LPCB.ECDV.EC34 */
                }

                If ((Arg0 == 0x23))
                {
                    Local0 = EC35 /* \_SB_.PCI0.LPCB.ECDV.EC35 */
                }

                If ((Arg0 == 0x24))
                {
                    Local0 = EC36 /* \_SB_.PCI0.LPCB.ECDV.EC36 */
                }

                If ((Arg0 == 0x25))
                {
                    Local0 = EC37 /* \_SB_.PCI0.LPCB.ECDV.EC37 */
                }

                If ((Arg0 == 0x26))
                {
                    Local0 = EC38 /* \_SB_.PCI0.LPCB.ECDV.EC38 */
                }

                If ((Arg0 == 0x27))
                {
                    Local0 = EC39 /* \_SB_.PCI0.LPCB.ECDV.EC39 */
                }

                If ((Arg0 == 0x28))
                {
                    Local0 = EC40 /* \_SB_.PCI0.LPCB.ECDV.EC40 */
                }

                If ((Arg0 == 0x29))
                {
                    Local0 = EC41 /* \_SB_.PCI0.LPCB.ECDV.EC41 */
                }

                If ((Arg0 == 0x2A))
                {
                    Local0 = EC42 /* \_SB_.PCI0.LPCB.ECDV.EC42 */
                }

                If ((Arg0 == 0x2B))
                {
                    Local0 = EC43 /* \_SB_.PCI0.LPCB.ECDV.EC43 */
                }

                If ((Arg0 == 0x2C))
                {
                    Local0 = EC44 /* \_SB_.PCI0.LPCB.ECDV.EC44 */
                }

                If ((Arg0 == 0x2D))
                {
                    Local0 = EC45 /* \_SB_.PCI0.LPCB.ECDV.EC45 */
                }

                If ((Arg0 == 0x2E))
                {
                    Local0 = EC46 /* \_SB_.PCI0.LPCB.ECDV.EC46 */
                }

                If ((Arg0 == 0x2F))
                {
                    Local0 = EC47 /* \_SB_.PCI0.LPCB.ECDV.EC47 */
                }

                If ((Arg0 == 0x30))
                {
                    Local0 = EC48 /* \_SB_.PCI0.LPCB.ECDV.EC48 */
                }

                If ((Arg0 == 0x31))
                {
                    Local0 = EC49 /* \_SB_.PCI0.LPCB.ECDV.EC49 */
                }

                Release (\ECMX)
                Return (Local0)
            }

            Method (ECR2, 1, NotSerialized)
            {
                Local0 = \_SB.PCI0.LPCB.ECDV.ECR1 (Arg0)
                Arg0++
                Local1 = (\_SB.PCI0.LPCB.ECDV.ECR1 (Arg0) << 0x08)
                Local0 += Local1
                Return (Local0)
            }

            Method (ECW1, 2, NotSerialized)
            {
                If ((\ECRD == 0x00))
                {
                    EISC (0x81, Arg0, Arg1)
                    Return (Zero)
                }

                Acquire (\ECMX, 0xFFFF)
                If ((Arg0 == 0x00))
                {
                    EC00 = Arg1
                }

                If ((Arg0 == 0x01))
                {
                    EC01 = Arg1
                }

                If ((Arg0 == 0x02))
                {
                    EC02 = Arg1
                }

                If ((Arg0 == 0x03))
                {
                    EC03 = Arg1
                }

                If ((Arg0 == 0x04))
                {
                    EC04 = Arg1
                }

                If ((Arg0 == 0x05))
                {
                    EC05 = Arg1
                }

                If ((Arg0 == 0x06))
                {
                    EC06 = Arg1
                }

                If ((Arg0 == 0x07))
                {
                    EC07 = Arg1
                }

                If ((Arg0 == 0x08))
                {
                    EC08 = Arg1
                }

                If ((Arg0 == 0x09))
                {
                    EC09 = Arg1
                }

                If ((Arg0 == 0x0A))
                {
                    EC10 = Arg1
                }

                If ((Arg0 == 0x0B))
                {
                    EC11 = Arg1
                }

                If ((Arg0 == 0x0C))
                {
                    EC12 = Arg1
                }

                Release (\ECMX)
                Return (Zero)
            }
        }
    }

    Scope (\)
    {
        Name (ECRD, 0x00)
        Mutex (ECMX, 0x01)
        Mutex (ECSX, 0x01)
        Method (EISC, 3, NotSerialized)
        {
            Acquire (ECSX, 0xFFFF)
            Name (ECIB, Buffer (0x04){})
            CreateByteField (ECIB, 0x00, ECIC)
            CreateByteField (ECIB, 0x01, ECP1)
            CreateByteField (ECIB, 0x02, ECP2)
            ECIC = Arg0
            ECP1 = Arg1
            ECP2 = Arg2
            ECIB = GENS (0x08, ECIB, SizeOf (ECIB))
            Local0 = ECIC /* \EISC.ECIC */
            Release (ECSX)
            Return (Local0)
        }

        Method (ECBT, 2, NotSerialized)
        {
            Local0 = \_SB.PCI0.LPCB.ECDV.ECR1 (Arg0)
            Local0 &= Arg1
            If (Local0)
            {
                Return (0x01)
            }

            Return (0x00)
        }

        Method (ECB1, 2, NotSerialized)
        {
            Local0 = ECBT (Arg0, Arg1)
            If (Local0)
            {
                Return (0x00)
            }

            Return (0x01)
        }

        Method (ECRB, 1, NotSerialized)
        {
            Return (\_SB.PCI0.LPCB.ECDV.ECR1 (Arg0))
        }

        Method (ECRW, 1, NotSerialized)
        {
            Return (\_SB.PCI0.LPCB.ECDV.ECR2 (Arg0))
        }

        Method (ECWB, 2, NotSerialized)
        {
            \_SB.PCI0.LPCB.ECDV.ECW1 (Arg0, Arg1)
        }

        Method (ECG1, 0, NotSerialized)
        {
            Return (ECRW (0x07))
        }

        Method (ECG2, 0, NotSerialized)
        {
            Return (ECBT (0x00, 0x01))
        }

        Method (ECG3, 0, NotSerialized)
        {
            Return (ECBT (0x00, 0x10))
        }

        Method (ECG4, 0, NotSerialized)
        {
            Return (ECBT (0x05, 0x04))
        }

        Method (ECG5, 0, NotSerialized)
        {
            Local0 = ECRB (0x06)
            Return (Local0)
        }

        Method (ECG7, 0, NotSerialized)
        {
            Local0 = ECRB (0x09)
            Return (Local0)
        }

        Mutex (ECM1, 0x01)
        Method (ECG6, 2, NotSerialized)
        {
            Acquire (ECM1, 0xFFFF)
            Local2 = ECG2 ()
            ECWB (0x03, Arg0)
            Arg1 [0x00] = ECRB (0x10)
            Local0 = ECRW (0x12)
            If ((Local0 == 0x00))
            {
                Local0++
            }
            ElseIf ((Local2 != 0x00))
            {
                If ((Local0 & 0x8000))
                {
                    Local0 = Ones
                }
            }
            ElseIf ((Local0 & 0x8000))
            {
                Local0 = (0x00 - Local0)
                Local0 &= 0xFFFF
            }
            Else
            {
                Local0 = Ones
            }

            Arg1 [0x01] = Local0
            Local0 = ECRW (0x16)
            Arg1 [0x02] = Local0
            Local0 = ECRW (0x14)
            Arg1 [0x03] = Local0
            Release (ECM1)
        }

        Method (ECM8, 1, NotSerialized)
        {
            ECWB (0x04, Arg0)
            Name (LBUF, Buffer (0x21){})
            Local0 = 0x00
            While ((Local0 < 0x20))
            {
                Local1 = ECRB (0x2A)
                LBUF [Local0] = Local1
                If ((Local1 == 0x00))
                {
                    Break
                }

                Local0++
            }

            If ((Local1 != 0x00))
            {
                LBUF [Local0] = 0x00
                Local0++
            }

            Local0++
            Name (OBUF, Buffer (Local0){})
            OBUF = LBUF /* \ECM8.LBUF */
            Return (OBUF) /* \ECM8.OBUF */
        }

        Name (BS01, Package (0x03)
        {
            0x01, 
            0xFF, 
            "Unknown"
        })
        Name (BS02, Package (0x0F)
        {
            0x03, 
            0x02, 
            "Sony", 
            0x03, 
            "Sanyo", 
            0x04, 
            "Panasonic", 
            0x07, 
            "SMP", 
            0x08, 
            "Motorola", 
            0x06, 
            "Samsung SDI", 
            0xFF, 
            "Unknown"
        })
        Name (BS03, Package (0x13)
        {
            0x02, 
            0x01, 
            "PbAc", 
            0x02, 
            "LION", 
            0x03, 
            "NiCd", 
            0x04, 
            "NiMH", 
            0x05, 
            "NiZn", 
            0x06, 
            "RAM", 
            0x07, 
            "ZnAR", 
            0x08, 
            "LiP", 
            0xFF, 
            "Unknown"
        })
        Method (ECU0, 2, NotSerialized)
        {
            Local0 = 0x01
            Local1 = 0x00
            While ((Local1 != 0xFF))
            {
                Local1 = DerefOf (Arg0 [Local0])
                If ((Arg1 == Local1))
                {
                    Local0++
                    Local2 = DerefOf (Arg0 [Local0])
                    Local2 = XPTB (Local2)
                    Return (Local2)
                }

                Local0 += 0x02
            }

            Local2 = DerefOf (Arg0 [0x00])
            Local2 = ECM8 (Local2)
            Return (Local2)
        }

        Method (ECG9, 2, NotSerialized)
        {
            Acquire (ECM1, 0xFFFF)
            ECWB (0x03, Arg0)
            Arg1 [0x00] = 0x01
            Local0 = ECRW (0x20)
            Arg1 [0x01] = Local0
            Local1 = ECRW (0x1E)
            Arg1 [0x02] = Local1
            Arg1 [0x03] = 0x01
            Local2 = ECRW (0x22)
            Arg1 [0x04] = Local2
            Divide (Local0, 0x0A, Local5, Local3)
            Arg1 [0x05] = Local3
            Divide (Local0, 0x21, Local5, Local3)
            Arg1 [0x06] = Local3
            Divide (Local0, 0x64, Local5, Local3)
            Arg1 [0x07] = Local3
            Arg1 [0x08] = Local3
            Local3 = ECU0 (BS01, 0x00)
            Arg1 [0x09] = Local3
            Local3 = ECRW (0x26)
            Local3 = XPTS (Local3)
            Arg1 [0x0A] = Local3
            Local3 = ECRB (0x29)
            Local3 = ECU0 (BS03, Local3)
            Arg1 [0x0B] = Local3
            Local3 = ECRB (0x28)
            Local3 = ECU0 (BS02, Local3)
            Arg1 [0x0C] = Local3
            Release (ECM1)
        }

        Method (ECGA, 0, NotSerialized)
        {
            Local0 = ECRB (0x2F)
            Return (Local0)
        }

        Method (ECS1, 2, NotSerialized)
        {
            ECWB (0x02, Arg0)
        }

        Method (ECS2, 1, NotSerialized)
        {
            ECWB (0x01, Arg0)
        }

        Method (ECS3, 0, NotSerialized)
        {
            ECWB (0x05, 0x01)
        }

        Mutex (QSEV, 0x01)
        Method (EC0A, 1, NotSerialized)
        {
            Acquire (QSEV, 0xFFFF)
            Local1 = ECRB (0x2B)
            Local0 = 0x00
            While ((Local0 < Local1))
            {
                Local2 = ECRB (0x2C)
                If ((Local0 < SizeOf (Arg0)))
                {
                    BBWR (Arg0, Local0, Local2)
                }

                Local0++
            }

            Release (QSEV)
            Return (Arg0)
        }

        Method (ECS4, 1, NotSerialized)
        {
            ECWB (0x11, Arg0)
        }

        Method (ECS5, 1, NotSerialized)
        {
            ECWB (0x10, Arg0)
        }
    }

    Method (NEVT, 0, NotSerialized)
    {
        Local0 = ECG1 ()
        If ((Local0 & 0x01))
        {
            \EV6 (0x01, 0x00)
        }

        If ((Local0 & 0x40))
        {
            \EV6 (0x02, 0x00)
        }

        If ((Local0 & 0x04))
        {
            Local1 = ECG3 ()
            \EV6 (0x03, Local1)
        }

        If ((Local0 & 0x10))
        {
            Local1 = ECBT (0x00, 0x80)
            Local2 = ECRB (0x2D)
            \EV7 (Local1, Local2)
        }

        If ((Local0 & 0x0100))
        {
            \EV8 (0x0100, 0x00)
        }

        If ((Local0 & 0x0200))
        {
            \EV8 (0x0200, 0x00)
        }

        If ((Local0 & 0x0400))
        {
            \EV8 (0x0400, 0x00)
        }

        If ((Local0 & 0x0800))
        {
            \EV8 (0x0800, 0x00)
        }

        If ((Local0 & 0x8000))
        {
            Local1 = ECRB (0x2E)
            \EV9 (0x8000, Local1)
        }

        If ((Local0 & 0x08))
        {
            PWRE ()
        }

        If ((Local0 & 0x80))
        {
            SMIE ()
        }
    }

    Method (PWRE, 0, NotSerialized)
    {
        Local0 = ECG5 ()
        Local1 = (Local0 ^ APRE) /* \APRE */
        APRE = (Local0 & (0x01 | (0x02 | 0x10)))
        If ((Local1 & 0x01))
        {
            \EV10 (0x00, 0x00)
        }

        Local2 = (APRE & 0x02)
        If ((Local1 & 0x02))
        {
            If (Local2)
            {
                \EV11 (0x01, 0x00)
            }
            Else
            {
                \EV11 (0x02, 0x00)
            }
        }

        If ((Local1 & 0x04))
        {
            If (Local2)
            {
                \EV11 (0x04, 0x00)
            }
        }

        If ((Local1 & 0x08))
        {
            If (Local2)
            {
                \EV11 (0x04, 0x00)
            }
        }

        Local2 = (APRE & 0x10)
        If ((Local1 & 0x10))
        {
            If (Local2)
            {
                \EV11 (0x01, 0x01)
            }
            Else
            {
                \EV11 (0x02, 0x01)
            }
        }

        If ((Local1 & 0x20))
        {
            If (Local2)
            {
                \EV11 (0x04, 0x01)
            }
        }

        If ((Local1 & 0x40))
        {
            If (Local2)
            {
                \EV11 (0x04, 0x01)
            }
        }
    }

    Method (SMEE, 1, NotSerialized)
    {
        Local0 = Arg0
        Local0 = GENS (0x11, 0x00, 0x00)
        If ((\_SB.OSID () >= 0x20))
        {
            If ((Local0 & 0x04))
            {
                \EV12 (0x01, 0x00)
            }

            If ((Local0 & 0x02))
            {
                \EV12 (0x02, 0x00)
            }
        }
    }

    Method (SMIE, 0, NotSerialized)
    {
        Local0 = GENS (0x10, 0x00, 0x00)
        If ((Local0 & 0x04))
        {
            SMEE (Local0)
        }

        If ((Local0 & 0x02))
        {
            \EV13 (0x00, 0x00)
        }

        If ((Local0 & 0x08))
        {
            \EV4 (0x00, 0x00)
        }

        If ((Local0 & 0x40))
        {
            \EV14 (0x00, 0x00)
        }

        If ((Local0 & 0x80))
        {
            \EV15 (0x00, 0x00)
        }

        If ((Local0 & 0x10))
        {
            \EV3 (0x00, 0x00)
        }
    }

    Scope (\_SB.PCI0.LPCB)
    {
        Method (EINI, 2, NotSerialized)
        {
            If ((Arg0 == 0x02))
            {
                APRE = ECG5 ()
                APRE &= (0x01 | (0x02 | 0x10))
            }
        }
    }

    Scope (\_GPE)
    {
        Method (_L1F, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            Local0 = ECG7 ()
            If ((Local0 & 0x02))
            {
                Local1 = ECG3 ()
                \EV6 (0x03, Local1)
            }

            Local1 = 0x00
            If ((Local0 == 0x00))
            {
                Local1 = 0x01
            }

            If ((Local0 & 0x01))
            {
                Local1 = 0x01
            }

            If ((Local0 == 0x04))
            {
                Local1 = 0x01
            }

            If (Local1)
            {
                \EV6 (0x01, 0x01)
            }
        }
    }

    Scope (\_SB)
    {
        Mutex (ECAX, 0x01)
        Method (EEAC, 2, NotSerialized)
        {
            Acquire (ECAX, 0xFFFF)
            Name (EABF, Buffer (0x08){})
            CreateDWordField (EABF, 0x00, ECST)
            CreateDWordField (EABF, 0x04, ECPA)
            ECST = Arg0
            ECPA = Arg1
            EABF = GENS (0x07, EABF, SizeOf (EABF))
            Local0 = ECST /* \_SB_.EEAC.ECST */
            Release (ECAX)
            Return (Local0)
        }

        Scope (\_SB)
        {
            Method (PPRW, 0, NotSerialized)
            {
                Name (EPRW, Package (0x02)
                {
                    0x00, 
                    0x03
                })
                Local0 = EEAC (0x03, 0x00)
                EPRW [0x00] = Local0
                Return (EPRW) /* \_SB_.PPRW.EPRW */
            }

            Device (LID)
            {
                Name (_HID, EisaId ("PNP0C0D") /* Lid Device */)  // _HID: Hardware ID
                Method (_LID, 0, NotSerialized)  // _LID: Lid Status
                {
                    Local0 = ECG3 ()
                    Return (Local0)
                }

                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (PPRW ())
                }

                Method (_PSW, 1, NotSerialized)  // _PSW: Power State Wake
                {
                    EEAC (0x02, Arg0)
                }
            }

            Device (PBTN)
            {
                Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (PPRW ())
                }

                Method (_PSW, 1, NotSerialized)  // _PSW: Power State Wake
                {
                    EEAC (0x01, Arg0)
                }
            }

            Device (SBTN)
            {
                Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
            }

            Method (BTNV, 2, NotSerialized)
            {
                If ((Arg0 == 0x01))
                {
                    If ((Arg1 == 0x00))
                    {
                        Notify (\_SB.PBTN, 0x80) // Status Change
                    }

                    If ((Arg1 == 0x01))
                    {
                        Notify (\_SB.PBTN, 0x02) // Device Wake
                    }
                }

                If ((Arg0 == 0x02))
                {
                    Notify (\_SB.SBTN, 0x80) // Status Change
                }
            }
        }

        Device (AC)
        {
            Name (_HID, "ACPI0003" /* Power Source Device */)  // _HID: Hardware ID
            Method (_PCL, 0, NotSerialized)  // _PCL: Power Consumer List
            {
                Return (Package (0x03)
                {
                    \_SB, 
                    BAT0, 
                    BAT1
                })
            }

            Method (_PSR, 0, NotSerialized)  // _PSR: Power Source
            {
                Local0 = ECG5 ()
                Local0 &= 0x01
                Return (Local0)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Method (ACEV, 2, NotSerialized)
        {
            Notify (\_SB.AC, 0x80) // Status Change
        }

        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
            Name (_UID, 0x01)  // _UID: Unique ID
            Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
            {
                \_SB
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = ECG5 ()
                Local0 &= 0x02
                If (Local0)
                {
                    Return (0x1F)
                }

                Return (0x0F)
            }

            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                Name (BIF0, Package (0x0D){})
                ECG9 (0x01, BIF0)
                Return (BIF0) /* \_SB_.BAT0._BIF.BIF0 */
            }

            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                Name (BST0, Package (0x04){})
                ECG6 (0x01, BST0)
                Return (BST0) /* \_SB_.BAT0._BST.BST0 */
            }
        }

        Device (BAT1)
        {
            Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
            {
                \_SB
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = EEAC (0x05, 0x00)
                If ((Local0 < 0x02))
                {
                    Return (0x00)
                }

                Local0 = ECG5 ()
                Local0 &= 0x10
                If (Local0)
                {
                    Return (0x1F)
                }

                Return (0x0F)
            }

            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                Name (BIF1, Package (0x0D){})
                ECG9 (0x02, BIF1)
                Return (BIF1) /* \_SB_.BAT1._BIF.BIF1 */
            }

            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                Name (BST1, Package (0x04){})
                ECG6 (0x02, BST1)
                Return (BST1) /* \_SB_.BAT1._BST.BST1 */
            }
        }

        Method (BTEV, 2, NotSerialized)
        {
            If ((Arg0 == 0x01))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.BAT0, 0x81) // Information Change
                }
                Else
                {
                    Notify (\_SB.BAT1, 0x81) // Information Change
                }
            }

            If ((Arg0 == 0x02))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.BAT0, 0x81) // Information Change
                }
                Else
                {
                    Notify (\_SB.BAT1, 0x81) // Information Change
                }
            }

            If ((Arg0 == 0x03))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.BAT0, 0x80) // Status Change
                }
                Else
                {
                    Notify (\_SB.BAT1, 0x80) // Status Change
                }
            }

            If ((Arg0 == 0x04))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.BAT0, 0x80) // Status Change
                }
                Else
                {
                    Notify (\_SB.BAT1, 0x80) // Status Change
                }
            }
        }

        Scope (\_SB)
        {
            Method (CBAT, 2, NotSerialized)
            {
                Notify (\_SB.BAT0, 0x81) // Information Change
                Notify (\_SB.BAT1, 0x81) // Information Change
            }
        }
    }

    Scope (\)
    {
        Name (DCKS, 0xFF)
        Name (DCKT, 0x00)
    }

    Scope (\_SB.PCI0.LPCB)
    {
        Method (DCK3, 0, NotSerialized)
        {
            If (CondRefOf (\_SB.PCI0.LPCB.LPTE))
            {
                Notify (\_SB.PCI0.LPCB.LPTE, 0x01) // Device Check
            }

            If (CondRefOf (\_SB.PCI0.LPCB.UAR1))
            {
                Notify (\_SB.PCI0.LPCB.UAR1, 0x01) // Device Check
            }
        }

        Method (DCK4, 2, NotSerialized)
        {
            DCKS = Arg0
            DCKT = Arg1
            DCK3 ()
        }

        Method (DCK5, 2, NotSerialized)
        {
            Local0 = ECRB (0x2D)
            If ((Local0 != DCKT))
            {
                DCK3 ()
            }
        }
    }

    Scope (\_SB.PCI0.LPCB)
    {
        OperationRegion (LPCB, SystemIO, \SP2O, 0x02)
        Field (LPCB, ByteAcc, Lock, Preserve)
        {
            INDX,   8, 
            DATA,   8
        }

        IndexField (INDX, DATA, ByteAcc, Lock, Preserve)
        {
            Offset (0x01), 
            CR01,   8, 
            CR02,   8, 
            Offset (0x0C), 
            CR0C,   8, 
            Offset (0x22), 
            CR22,   8, 
            CR23,   8, 
            CR24,   8, 
            CR25,   8, 
            CR26,   8, 
            CR27,   8, 
            CR28,   8, 
            Offset (0x55), 
            CR55,   8, 
            Offset (0xAA), 
            CRAA,   8
        }

        Device (UAR1)
        {
            Name (_HID, EisaId ("PNP0501") /* 16550A-compatible COM Serial Port */)  // _HID: Hardware ID
            Name (_UID, 0x00)  // _UID: Unique ID
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x08, 
                0x03
            })
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Name (DCK9, Buffer (0x04){})
                CreateByteField (DCK9, 0x00, DCK8)
                CreateByteField (DCK9, 0x01, DCK6)
                CreateByteField (DCK9, 0x02, DCK2)
                CreateByteField (DCK9, 0x03, DCK7)
                DCK8 = 0x01
                Local0 = GENS (0x13, DCK9, SizeOf (DCK9))
                DCK9 = Local0
                If (((DCK6 == 0x01) && (DCK7 == 0x01)))
                {
                    If (((DCK2 == 0x01) || (DCK2 == 0x04)))
                    {
                        Return (0x0F)
                    }
                }

                Return (0x00)
            }

            Method (_DIS, 0, Serialized)  // _DIS: Disable Device
            {
                CR55 = 0x00
                CR02 = (CR02 & 0xF0)
                CRAA = 0x00
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (BUF0, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x03F8,             // Range Minimum
                        0x03F8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        _Y22)
                    IRQNoFlags (_Y23)
                        {4}
                })
                CreateByteField (BUF0, \_SB.PCI0.LPCB.UAR1._CRS._Y22._MIN, IOL0)  // _MIN: Minimum Base Address
                CreateByteField (BUF0, 0x03, IOH0)
                CreateByteField (BUF0, \_SB.PCI0.LPCB.UAR1._CRS._Y22._MAX, IOL1)  // _MAX: Maximum Base Address
                CreateByteField (BUF0, 0x05, IOH1)
                CreateByteField (BUF0, \_SB.PCI0.LPCB.UAR1._CRS._Y22._LEN, LEN0)  // _LEN: Length
                CreateWordField (BUF0, \_SB.PCI0.LPCB.UAR1._CRS._Y23._INT, IRQW)  // _INT: Interrupts
                CR55 = 0x00
                IOL0 = (CR24 << 0x02)
                IOL1 = (CR24 << 0x02)
                IOH0 = (CR24 >> 0x06)
                IOH1 = (CR24 >> 0x06)
                LEN0 = 0x08
                IRQW = (One << ((CR28 & 0xF0) >> 0x04))
                CRAA = 0x00
                Return (BUF0) /* \_SB_.PCI0.LPCB.UAR1._CRS.BUF0 */
            }

            Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
            {
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x03F8,             // Range Minimum
                        0x03F8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IRQNoFlags ()
                        {4}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x03F8,             // Range Minimum
                        0x03F8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IRQNoFlags ()
                        {4,5,6,7,10,11,12}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x02F8,             // Range Minimum
                        0x02F8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IRQNoFlags ()
                        {4,5,6,7,10,11,12}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x03E8,             // Range Minimum
                        0x03E8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IRQNoFlags ()
                        {4,5,6,7,10,11,12}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x02E8,             // Range Minimum
                        0x02E8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IRQNoFlags ()
                        {4,5,6,7,10,11,12}
                }
                EndDependentFn ()
            })
            Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
            {
                CreateByteField (Arg0, 0x02, IOLO)
                CreateByteField (Arg0, 0x03, IOHI)
                CreateWordField (Arg0, 0x09, IRQW)
                CR55 = 0x00
                CR02 = (CR02 & 0xF0)
                CR24 = (IOLO >> 0x02)
                CR24 |= (IOHI << 0x06)
                CR28 &= 0x0F
                CR28 |= ((FindSetRightBit (IRQW) - 0x01) << 0x04)
                IOD0 &= 0xF8
                If ((IOHI == 0x03))
                {
                    If ((IOLO == 0xF8))
                    {
                        IOD0 |= 0x00
                    }
                    Else
                    {
                        IOD0 |= 0x07
                    }
                }
                ElseIf ((IOLO == 0xF8))
                {
                    IOD0 |= 0x01
                }
                Else
                {
                    IOD0 |= 0x05
                }

                CR02 = (CR02 | 0x08)
                CRAA = 0x00
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                CR55 = 0x00
                CR02 = (CR02 | 0x08)
                CRAA = 0x00
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                CR55 = 0x00
                CR02 = (CR02 & 0xF0)
                CRAA = 0x00
            }
        }

        Device (LPTE)
        {
            Name (_HID, EisaId ("PNP0401") /* ECP Parallel Port */)  // _HID: Hardware ID
            Name (_UID, 0x05)  // _UID: Unique ID
            Method (CLPS, 0, NotSerialized)
            {
                Name (DCK9, Buffer (0x04){})
                CreateByteField (DCK9, 0x00, DCK8)
                CreateByteField (DCK9, 0x01, DCK6)
                CreateByteField (DCK9, 0x02, DCK2)
                CreateByteField (DCK9, 0x03, DCK7)
                DCK8 = 0x02
                Local0 = GENS (0x13, DCK9, SizeOf (DCK9))
                DCK9 = Local0
                If (((DCK6 == 0x01) && (DCK7 == 0x01)))
                {
                    If (((DCK2 == 0x01) || (DCK2 == 0x04)))
                    {
                        Return (0x01)
                    }
                }

                Return (0x00)
            }

            Method (_STA, 0, Serialized)  // _STA: Status
            {
                If (CLPS ())
                {
                    CR55 = 0x00
                    Local0 = CR01 /* \_SB_.PCI0.LPCB.CR01 */
                    CRAA = 0x00
                    If ((Local0 & 0x04))
                    {
                        Return (0x0F)
                    }

                    Return (0x0D)
                }

                Return (0x0D)
            }

            Method (_DIS, 0, Serialized)  // _DIS: Disable Device
            {
                CR55 = 0x00
                CR01 = (CR01 & 0xFB)
                CRAA = 0x00
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (BUF0, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0000,             // Range Minimum
                        0x0000,             // Range Maximum
                        0x01,               // Alignment
                        0x00,               // Length
                        _Y24)
                    IRQNoFlags (_Y25)
                        {0}
                })
                If (CLPS ())
                {
                    CreateByteField (BUF0, \_SB.PCI0.LPCB.LPTE._CRS._Y24._MIN, IOL0)  // _MIN: Minimum Base Address
                    CreateByteField (BUF0, 0x03, IOH0)
                    CreateByteField (BUF0, \_SB.PCI0.LPCB.LPTE._CRS._Y24._MAX, IOL1)  // _MAX: Maximum Base Address
                    CreateByteField (BUF0, 0x05, IOH1)
                    CreateByteField (BUF0, \_SB.PCI0.LPCB.LPTE._CRS._Y24._LEN, LEN0)  // _LEN: Length
                    CreateWordField (BUF0, \_SB.PCI0.LPCB.LPTE._CRS._Y25._INT, IRQW)  // _INT: Interrupts
                    CR55 = 0x00
                    IOL0 = (CR23 << 0x02)
                    IOL1 = (CR23 << 0x02)
                    IOH0 = (CR23 >> 0x06)
                    IOH1 = (CR23 >> 0x06)
                    LEN0 = 0x04
                    Local1 = 0x00
                    Local1 = (CR27 & 0x0F)
                    IRQW = (0x01 << Local1)
                    CRAA = 0x00
                }

                Return (BUF0) /* \_SB_.PCI0.LPCB.LPTE._CRS.BUF0 */
            }

            Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
            {
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x0378,             // Range Minimum
                        0x0378,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {5}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x0278,             // Range Minimum
                        0x0278,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {5}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x03BC,             // Range Minimum
                        0x03BC,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {5}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x0378,             // Range Minimum
                        0x0378,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {7}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x0278,             // Range Minimum
                        0x0278,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {7}
                }
                StartDependentFn (0x00, 0x02)
                {
                    IO (Decode16,
                        0x03BC,             // Range Minimum
                        0x03BC,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IRQNoFlags ()
                        {7}
                }
                EndDependentFn ()
            })
            Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
            {
                If ((CLPS () == 0x00))
                {
                    Return (Zero)
                }

                CreateByteField (Arg0, 0x02, IOL0)
                CreateByteField (Arg0, 0x03, IOH0)
                CreateWordField (Arg0, 0x09, IRQW)
                CR55 = 0x00
                CR01 = (CR01 & 0xFB)
                CR23 = (IOL0 >> 0x02)
                CR23 |= (IOH0 << 0x06)
                FindSetRightBit (IRQW, Local0)
                If ((IRQW != Zero))
                {
                    Local0--
                }

                CR27 = Local0
                IOD1 &= 0xFC
                If ((IOH0 == 0x03))
                {
                    If ((IOL0 == 0x78))
                    {
                        IOD1 |= 0x00
                    }
                    Else
                    {
                        IOD1 |= 0x02
                    }
                }
                Else
                {
                    IOD1 |= 0x01
                }

                CR01 |= 0x04
                CRAA = 0x00
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                CR55 = 0x00
                CR01 = (CR01 | 0x04)
                CRAA = 0x00
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                CR55 = 0x00
                CR01 = (CR01 & 0xFB)
                CRAA = 0x00
            }
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (VID)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            Name (IVD5, Buffer (0x03){})
            CreateByteField (IVD5, 0x00, IVD6)
            CreateByteField (IVD5, 0x01, IVD7)
            CreateByteField (IVD5, 0x02, IVD8)
            OperationRegion (PCS, PCI_Config, 0x00, 0x0100)
            Field (PCS, AnyAcc, NoLock, WriteAsZeros)
            {
                VVID,   16, 
                Offset (0x0A), 
                DCLS,   16
            }

            Method (VINI, 2, NotSerialized)
            {
                If ((Arg0 == 0x02))
                {
                    IVD6 = 0x00
                    Local1 = DCLS /* \_SB_.PCI0.VID_.DCLS */
                    If ((DCLS == 0x0300))
                    {
                        IVD6 = 0x01
                        Local0 = \_SB.LID._LID ()
                        \_SB.PCI0.VID.GLID (Local0)
                    }
                }
            }

            Scope (\)
            {
                Method (VDP2, 2, NotSerialized)
                {
                    Name (VDP3, Buffer (0x10){})
                    CreateByteField (VDP3, 0x00, VDP4)
                    CreateByteField (VDP3, 0x01, VDP5)
                    CreateDWordField (VDP3, 0x05, VDP6)
                    VDP4 = 0x04
                    VDP5 = Arg0
                    VDP6 = Arg1
                    GENS (0x05, VDP3, SizeOf (VDP3))
                }

                Method (VDP1, 2, NotSerialized)
                {
                    Local0 = Arg1
                    Local0 <<= 0x08
                    Local0 |= Arg0
                    Local0 = GENS (0x05, Local0, 0x00)
                    Return (Local0)
                }
            }

            Name (VDP7, Buffer (0x02)
            {
                 0x00, 0x00                                       // ..
            })
            CreateByteField (VDP7, 0x01, VDP8)
            Method (DINI, 2, NotSerialized)
            {
                If ((Arg0 == 0x02))
                {
                    VDP8 = 0x01
                }
            }

            Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
            {
                VDP8 = Arg0
                VDP1 (0x01, VDP8)
            }

            Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
            {
                Return (Package (0x06)
                {
                    0x0100, 
                    0x0400, 
                    0x0302, 
                    0x0303, 
                    0x0300, 
                    0x0301
                })
            }

            Device (CRT)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0100)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x02)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x02)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x02, Arg0)
                }
            }

            Device (LCD)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0400)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x01)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x01)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x01, Arg0)
                }

                Name (BRT0, 0x64)
                Name (DBCL, Package (0x12){})
                Method (_BCL, 0, Serialized)  // _BCL: Brightness Control Levels
                {
                    Name (BRT1, Buffer (0x12){})
                    CreateByteField (BRT1, 0x00, BRT2)
                    BRT2 = 0x01
                    Local2 = GENS (0x09, BRT1, SizeOf (BRT1))
                    Local0 = 0x00
                    Local1 = 0x12
                    While ((Local0 < Local1))
                    {
                        Local3 = BBRD (Local2, Local0)
                        DBCL [Local0] = Local3
                        Local0++
                    }

                    Return (DBCL) /* \_SB_.PCI0.VID_.LCD_.DBCL */
                }

                Method (_BCM, 1, Serialized)  // _BCM: Brightness Control Method
                {
                    Name (BRT3, Buffer (0x02){})
                    CreateByteField (BRT3, 0x00, BRT4)
                    CreateByteField (BRT3, 0x01, BRT5)
                    BRT4 = 0x02
                    BRT5 = Arg0
                    BRT0 = Arg0
                    GENS (0x09, BRT3, SizeOf (BRT3))
                }

                Method (_BQC, 0, Serialized)  // _BQC: Brightness Query Current
                {
                    Local0 = GENS (0x09, 0x03, 0x00)
                    BRT0 = Local0
                    Return (Local0)
                }

                Scope (\_SB.PCI0.VID)
                {
                    Method (BRT6, 2, NotSerialized)
                    {
                        If ((Arg0 == 0x01))
                        {
                            Notify (\_SB.PCI0.VID.LCD, 0x86) // Device-Specific
                        }

                        If ((Arg0 & 0x02))
                        {
                            Notify (\_SB.PCI0.VID.LCD, 0x87) // Device-Specific
                        }
                    }
                }
            }

            Device (DVI)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0302)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x08)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x08)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x08, Arg0)
                }
            }

            Device (DVI2)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0303)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x10)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x10)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x10, Arg0)
                }
            }

            Device (DP)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0300)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x20)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x20)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x20, Arg0)
                }
            }

            Device (DP2)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x0301)
                }

                Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                {
                    Local0 = VDP1 (0x02, 0x40)
                    Return (Local0)
                }

                Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                {
                    Local0 = VDP1 (0x03, 0x40)
                    Return (Local0)
                }

                Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                {
                    VDP2 (0x40, Arg0)
                }
            }

            Scope (\_SB.PCI0)
            {
                OperationRegion (MCHP, PCI_Config, 0x40, 0xC0)
                Field (MCHP, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    TASM,   10, 
                    Offset (0x62)
                }
            }

            OperationRegion (IGDP, PCI_Config, 0x40, 0xC0)
            Field (IGDP, AnyAcc, NoLock, Preserve)
            {
                Offset (0x12), 
                    ,   1, 
                GIVD,   1, 
                    ,   2, 
                GUMA,   3, 
                Offset (0x14), 
                    ,   4, 
                GMFN,   1, 
                Offset (0x18), 
                Offset (0xA4), 
                ASLE,   8, 
                Offset (0xA8), 
                GSSE,   1, 
                GSSB,   14, 
                GSES,   1, 
                Offset (0xB0), 
                    ,   12, 
                CDVL,   1, 
                Offset (0xB2), 
                Offset (0xB5), 
                LBPC,   8, 
                Offset (0xBC), 
                ASLS,   32
            }

            OperationRegion (IGDM, SystemMemory, ASLB, 0x2000)
            Field (IGDM, AnyAcc, NoLock, Preserve)
            {
                SIGN,   128, 
                SIZE,   32, 
                OVER,   32, 
                SVER,   256, 
                VVER,   128, 
                GVER,   128, 
                MBOX,   32, 
                DMOD,   32, 
                Offset (0x100), 
                DRDY,   32, 
                CSTS,   32, 
                CEVT,   32, 
                Offset (0x120), 
                DIDL,   32, 
                DDL2,   32, 
                DDL3,   32, 
                DDL4,   32, 
                DDL5,   32, 
                DDL6,   32, 
                DDL7,   32, 
                DDL8,   32, 
                CPDL,   32, 
                CPL2,   32, 
                CPL3,   32, 
                CPL4,   32, 
                CPL5,   32, 
                CPL6,   32, 
                CPL7,   32, 
                CPL8,   32, 
                CADL,   32, 
                CAL2,   32, 
                CAL3,   32, 
                CAL4,   32, 
                CAL5,   32, 
                CAL6,   32, 
                CAL7,   32, 
                CAL8,   32, 
                NADL,   32, 
                NDL2,   32, 
                NDL3,   32, 
                NDL4,   32, 
                NDL5,   32, 
                NDL6,   32, 
                NDL7,   32, 
                NDL8,   32, 
                ASLP,   32, 
                TIDX,   32, 
                CHPD,   32, 
                CLID,   32, 
                CDCK,   32, 
                SXSW,   32, 
                EVTS,   32, 
                CNOT,   32, 
                NRDY,   32, 
                Offset (0x200), 
                SCIE,   1, 
                GEFC,   4, 
                GXFC,   3, 
                GESF,   8, 
                Offset (0x204), 
                PARM,   32, 
                DSLP,   32, 
                Offset (0x300), 
                ARDY,   32, 
                ASLC,   32, 
                TCHE,   32, 
                ALSI,   32, 
                BCLP,   32, 
                PFIT,   32, 
                CBLV,   32, 
                BCLM,   320, 
                CPFM,   32, 
                EPFM,   32, 
                PLUT,   592, 
                PFMB,   32, 
                CCDV,   32, 
                PCFT,   32, 
                Offset (0x400), 
                GVD1,   49152, 
                PHED,   32, 
                BDDC,   2048
            }

            Name (DBTB, Package (0x15)
            {
                0x00, 
                0x07, 
                0x38, 
                0x01C0, 
                0x0E00, 
                0x3F, 
                0x01C7, 
                0x0E07, 
                0x01F8, 
                0x0E38, 
                0x0FC0, 
                0x00, 
                0x00, 
                0x00, 
                0x00, 
                0x00, 
                0x7000, 
                0x7007, 
                0x7038, 
                0x71C0, 
                0x7E00
            })
            Name (CDCT, Package (0x05)
            {
                Package (0x02)
                {
                    0xE4, 
                    0x0140
                }, 

                Package (0x02)
                {
                    0xDE, 
                    0x014D
                }, 

                Package (0x02)
                {
                    0xDE, 
                    0x014D
                }, 

                Package (0x02)
                {
                    0x00, 
                    0x00
                }, 

                Package (0x02)
                {
                    0xDE, 
                    0x014D
                }
            })
            Name (SUCC, 0x01)
            Name (NVLD, 0x02)
            Name (CRIT, 0x04)
            Name (NCRT, 0x06)
            Method (GSCI, 0, NotSerialized)
            {
                Method (GBDA, 0, NotSerialized)
                {
                    If ((GESF == 0x00))
                    {
                        PARM = 0x0679
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x01))
                    {
                        PARM = 0x0240
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x04))
                    {
                        PARM &= 0xEFFF0000
                        PARM &= (DerefOf (DBTB [IBTT]) << 0x10)
                        PARM |= IBTT /* \_SB_.PCI0.VID_.PARM */
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x05))
                    {
                        PARM = IPSC /* \IPSC */
                        PARM |= (IPAT << 0x08)
                        PARM += 0x0100
                        PARM |= (LIDS << 0x10)
                        PARM += 0x00010000
                        PARM |= (IBIA << 0x14)
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x06))
                    {
                        PARM = ITVF /* \ITVF */
                        PARM |= (ITVM << 0x04)
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x07))
                    {
                        PARM = GIVD /* \_SB_.PCI0.VID_.GIVD */
                        PARM ^= 0x01
                        PARM |= (GMFN << 0x01)
                        PARM |= (0x03 << 0x0B)
                        IDMS = 0x30
                        PARM |= (IDMS << 0x0D)
                        PARM |= (DerefOf (DerefOf (CDCT [HVCO]) [CDVL]) << 
                            0x15) /* \_SB_.PCI0.VID_.PARM */
                        GESF = 0x01
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x0A))
                    {
                        PARM = 0x00
                        If (ISSC)
                        {
                            PARM |= 0x03
                        }

                        GESF = 0x00
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x0B))
                    {
                        PARM = KSV0 /* \KSV0 */
                        GESF = KSV1 /* \KSV1 */
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    GESF = Zero
                    Return (CRIT) /* \_SB_.PCI0.VID_.CRIT */
                }

                Method (SBCB, 0, NotSerialized)
                {
                    If ((GESF == 0x00))
                    {
                        PARM = 0x00
                        PARM = 0x000F87FD
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x01))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x03))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x04))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x05))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x06))
                    {
                        ITVF = (PARM & 0x0F)
                        ITVM = ((PARM & 0xF0) >> 0x04)
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x07))
                    {
                        If ((PARM == 0x00))
                        {
                            Local0 = CLID /* \_SB_.PCI0.VID_.CLID */
                            If ((0x80000000 & Local0))
                            {
                                CLID &= 0x0F
                                GLID (CLID)
                            }
                        }

                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x08))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x09))
                    {
                        IBTT = (PARM & 0xFF)
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x0A))
                    {
                        IPSC = (PARM & 0xFF)
                        If (((PARM >> 0x08) & 0xFF))
                        {
                            IPAT = ((PARM >> 0x08) & 0xFF)
                            IPAT--
                        }

                        IBIA = ((PARM >> 0x14) & 0x07)
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x0B))
                    {
                        IF1E = ((PARM >> 0x01) & 0x01)
                        If ((PARM & (0x0F << 0x0D)))
                        {
                            IDMS = ((PARM >> 0x0D) & 0x0F)
                        }
                        Else
                        {
                            IDMS = ((PARM >> 0x11) & 0x0F)
                        }

                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x10))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x11))
                    {
                        PARM = (LIDS << 0x08)
                        PARM += 0x0100
                        GESF = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x12))
                    {
                        If ((PARM & 0x01))
                        {
                            If (((PARM >> 0x01) == 0x01))
                            {
                                ISSC = 0x01
                            }
                            Else
                            {
                                GESF = Zero
                                Return (CRIT) /* \_SB_.PCI0.VID_.CRIT */
                            }
                        }
                        Else
                        {
                            ISSC = 0x00
                        }

                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x13))
                    {
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    If ((GESF == 0x14))
                    {
                        PAVP = (PARM & 0x0F)
                        GESF = Zero
                        PARM = Zero
                        Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                    }

                    GESF = Zero
                    Return (SUCC) /* \_SB_.PCI0.VID_.SUCC */
                }

                If ((GEFC == 0x04))
                {
                    GXFC = GBDA ()
                }

                If ((GEFC == 0x06))
                {
                    GXFC = SBCB ()
                }

                GEFC = 0x00
                SCIS = 0x01
                GSSE = 0x00
                SCIE = 0x00
                Return (Zero)
            }

            Method (PDRD, 0, NotSerialized)
            {
                If (!DRDY)
                {
                    Sleep (ASLP)
                }

                Return (!DRDY)
            }

            Method (PSTS, 0, NotSerialized)
            {
                If ((CSTS > 0x02))
                {
                    Sleep (ASLP)
                }

                Return ((CSTS == 0x03))
            }

            Method (GNOT, 2, NotSerialized)
            {
                If (PDRD ())
                {
                    Return (0x01)
                }

                CEVT = Arg0
                CSTS = 0x03
                If (((CHPD == 0x00) && (Arg1 == 0x00)))
                {
                    If (((OSYS > 0x07D0) || (OSYS < 0x07D6)))
                    {
                        Notify (\_SB.PCI0, Arg1)
                    }
                    Else
                    {
                        Notify (\_SB.PCI0.VID, Arg1)
                    }
                }

                If (CondRefOf (HNOT))
                {
                    HNOT (Arg0)
                }
                Else
                {
                    Notify (\_SB.PCI0.VID, 0x80) // Status Change
                }

                Return (0x00)
            }

            Method (GHDS, 1, NotSerialized)
            {
                TIDX = Arg0
                Return (GNOT (0x01, 0x00))
            }

            Method (GLID, 1, NotSerialized)
            {
                CLID = Arg0
                Return (GNOT (0x02, 0x00))
            }

            Method (GDCK, 1, NotSerialized)
            {
                CDCK = Arg0
                Return (GNOT (0x04, 0x00))
            }

            Method (PARD, 0, NotSerialized)
            {
                If (!ARDY)
                {
                    Sleep (ASLP)
                }

                Return (!ARDY)
            }

            Method (AINT, 2, NotSerialized)
            {
                If (!(TCHE & (0x01 << Arg0)))
                {
                    Return (0x01)
                }

                If (PARD ())
                {
                    Return (0x01)
                }

                If ((Arg0 == 0x02))
                {
                    If (CPFM)
                    {
                        Local0 = (CPFM & 0x0F)
                        Local1 = (EPFM & 0x0F)
                        If ((Local0 == 0x01))
                        {
                            If ((Local1 & 0x06))
                            {
                                PFIT = 0x06
                            }
                            ElseIf ((Local1 & 0x08))
                            {
                                PFIT = 0x08
                            }
                            Else
                            {
                                PFIT = 0x01
                            }
                        }

                        If ((Local0 == 0x06))
                        {
                            If ((Local1 & 0x08))
                            {
                                PFIT = 0x08
                            }
                            ElseIf ((Local1 & 0x01))
                            {
                                PFIT = 0x01
                            }
                            Else
                            {
                                PFIT = 0x06
                            }
                        }

                        If ((Local0 == 0x08))
                        {
                            If ((Local1 & 0x01))
                            {
                                PFIT = 0x01
                            }
                            ElseIf ((Local1 & 0x06))
                            {
                                PFIT = 0x06
                            }
                            Else
                            {
                                PFIT = 0x08
                            }
                        }
                    }
                    Else
                    {
                        PFIT ^= 0x07
                    }

                    PFIT |= 0x80000000
                    ASLC = 0x04
                }
                ElseIf ((Arg0 == 0x01))
                {
                    BCLP = ((Arg1 * 0xFF) / 0x64)
                    BCLP |= 0x80000000
                    ASLC = 0x02
                }
                ElseIf ((Arg0 == 0x00))
                {
                    ALSI = Arg1
                    ASLC = 0x01
                }
                Else
                {
                    Return (0x01)
                }

                ASLE = 0x01
                Return (0x00)
            }

            Method (SCIP, 0, NotSerialized)
            {
                If ((OVER != 0x00))
                {
                    Return (!GSMI)
                }

                Return (0x00)
            }

            Scope (\_GPE)
            {
                Method (_L06, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
                {
                    If ((\_SB.PCI0.VID.SCIP () != 0x00))
                    {
                        If (\_SB.PCI0.VID.GSSE)
                        {
                            \_SB.PCI0.VID.GSCI ()
                        }
                        Else
                        {
                            SCIS = 0x01
                        }
                    }
                }
            }

            Method (ILID, 0, NotSerialized)
            {
                If ((IVD6 == 0x01))
                {
                    Local0 = \_SB.LID._LID ()
                    \_SB.PCI0.VID.GLID (Local0)
                    Notify (\_SB.LID, 0x80) // Status Change
                    IVD8 = 0x00
                    Sleep (0x01F4)
                    Local0 = 0x01
                }
                Else
                {
                    Local0 = 0x00
                }

                Return (Local0)
            }

            Method (ILDE, 2, NotSerialized)
            {
                If ((Arg0 == 0x03))
                {
                    ILID ()
                }
            }

            Method (IVD1, 2, NotSerialized)
            {
                If ((IVD6 == 0x01))
                {
                    \_SB.PCI0.VID.GHDS (0x00)
                }
            }

            Method (IVD2, 2, NotSerialized)
            {
                If ((IVD6 == 0x01))
                {
                    \_SB.PCI0.VID.GDCK (\_SB.PCI0.VID.CDCK)
                    If ((\_SB.PCI0.VID.CDCK == 0x01))
                    {
                        If ((\_SB.PCI0.VID.CLID == 0x00))
                        {
                            Sleep (0x07D0)
                            IVD8 = 0x01
                            \_SB.PCI0.VID.GLID (0x01)
                            Notify (\_SB.LID, 0x80) // Status Change
                            Sleep (0x02EE)
                            \_SB.PCI0.VID.GLID (0x00)
                            Notify (\_SB.LID, 0x80) // Status Change
                            Sleep (0x07D0)
                        }
                    }
                }
            }

            Method (IVD4, 2, NotSerialized)
            {
                IVD7 = \_SB.LID._LID ()
            }

            Method (IVD3, 2, NotSerialized)
            {
                If ((IVD6 == 0x01))
                {
                    Local0 = \_SB.LID._LID ()
                    \_SB.PCI0.VID.CLID = Local0
                    If ((Arg0 == 0x03))
                    {
                        If (((IVD7 != Local0) | (Local0 == 0x00)))
                        {
                            If ((OSID () >= 0x20))
                            {
                                \_SB.PCI0.VID.GLID (Local0)
                            }
                            Else
                            {
                                ILID ()
                            }
                        }
                    }
                }
            }
        }
    }

    Scope (\_SB.PCI0.AGP.VID)
    {
        OperationRegion (NVHM, SystemMemory, NVHA, 0x00010400)
        Field (NVHM, AnyAcc, NoLock, Preserve)
        {
            NVSG,   128, 
            NVSZ,   32, 
            NVVR,   32, 
            Offset (0x100), 
            NVHO,   32, 
            RVBS,   32, 
            Offset (0x180), 
            TNDI,   8, 
            DGND,   8, 
            IGND,   8, 
            Offset (0x190), 
            Offset (0x1B0), 
            DDI1,   32, 
            DDI2,   32, 
            DDI3,   32, 
            DDI4,   32, 
            DDI5,   32, 
            DDI6,   32, 
            DDI7,   32, 
            DDI8,   32, 
            Offset (0x200), 
            GACD,   16, 
            GATD,   16, 
            Offset (0x260), 
            DCP1,   32, 
            DCP2,   32, 
            DCP3,   32, 
            DCP4,   32, 
            DCP5,   32, 
            DCP6,   32, 
            DCP7,   32, 
            DCP8,   32, 
            DCA1,   32, 
            DCA2,   32, 
            DCA3,   32, 
            DCA4,   32, 
            DCA5,   32, 
            DCA6,   32, 
            DCA7,   32, 
            DCA8,   32, 
            DNA1,   32, 
            DNA2,   32, 
            DNA3,   32, 
            DNA4,   32, 
            DNA5,   32, 
            DNA6,   32, 
            DNA7,   32, 
            DNA8,   32, 
            Offset (0x3C0), 
            RAPM,   8, 
            EAPM,   8, 
            TSLC,   16, 
            DNDI,   8, 
            Offset (0x400), 
            RBF1,   262144, 
            RBF2,   262144
        }
    }

    Scope (\_SB.PCI0.AGP.VID)
    {
        Name (EVD4, Buffer (0x01){})
        CreateByteField (EVD4, 0x00, EVD5)
        OperationRegion (PCS, PCI_Config, 0x00, 0x0100)
        Field (PCS, AnyAcc, NoLock, WriteAsZeros)
        {
            VVID,   16, 
            Offset (0x0A), 
            DCLS,   16
        }

        Method (VINI, 2, NotSerialized)
        {
            If ((Arg0 == 0x02))
            {
                EVD5 = 0x00
                Local1 = DCLS /* \_SB_.PCI0.AGP_.VID_.DCLS */
                If ((DCLS == 0x0300))
                {
                    EVD5 = 0x01
                }
            }
        }

        Name (VDP7, Buffer (0x02)
        {
             0x00, 0x00                                       // ..
        })
        CreateByteField (VDP7, 0x01, VDP8)
        Method (DINI, 2, NotSerialized)
        {
            If ((Arg0 == 0x02))
            {
                VDP8 = 0x01
            }
        }

        Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
        {
            VDP8 = Arg0
            VDP1 (0x01, VDP8)
        }

        Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
        {
            Return (Package (0x06)
            {
                0x80000100, 
                0x80002400, 
                0x80007302, 
                0x80007303, 
                0x80006300, 
                0x80006301
            })
        }

        Device (CRT)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80000100 & 0xFFFF))
                }

                Return (0x80000100)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x02)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x02)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x02, Arg0)
            }
        }

        Device (LCD)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80002400 & 0xFFFF))
                }

                Return (0x80002400)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x01)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x01)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x01, Arg0)
            }

            Name (BRT0, 0x64)
            Name (DBCL, Package (0x12){})
            Method (_BCL, 0, Serialized)  // _BCL: Brightness Control Levels
            {
                Name (BRT1, Buffer (0x12){})
                CreateByteField (BRT1, 0x00, BRT2)
                BRT2 = 0x01
                Local2 = GENS (0x09, BRT1, SizeOf (BRT1))
                Local0 = 0x00
                Local1 = 0x12
                While ((Local0 < Local1))
                {
                    Local3 = BBRD (Local2, Local0)
                    DBCL [Local0] = Local3
                    Local0++
                }

                Return (DBCL) /* \_SB_.PCI0.AGP_.VID_.LCD_.DBCL */
            }

            Method (_BCM, 1, Serialized)  // _BCM: Brightness Control Method
            {
                Name (BRT3, Buffer (0x02){})
                CreateByteField (BRT3, 0x00, BRT4)
                CreateByteField (BRT3, 0x01, BRT5)
                BRT4 = 0x02
                BRT5 = Arg0
                BRT0 = Arg0
                GENS (0x09, BRT3, SizeOf (BRT3))
            }

            Method (_BQC, 0, Serialized)  // _BQC: Brightness Query Current
            {
                Local0 = GENS (0x09, 0x03, 0x00)
                BRT0 = Local0
                Return (Local0)
            }

            Scope (\_SB.PCI0.AGP.VID)
            {
                Method (BRT6, 2, NotSerialized)
                {
                    If ((Arg0 == 0x01))
                    {
                        Notify (\_SB.PCI0.AGP.VID.LCD, 0x86) // Device-Specific
                    }

                    If ((Arg0 & 0x02))
                    {
                        Notify (\_SB.PCI0.AGP.VID.LCD, 0x87) // Device-Specific
                    }
                }
            }
        }

        Device (DVI)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80007302 & 0xFFFF))
                }

                Return (0x80007302)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x08)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x08)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x08, Arg0)
            }
        }

        Device (DVI2)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80007303 & 0xFFFF))
                }

                Return (0x80007303)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x10)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x10)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x10, Arg0)
            }
        }

        Device (DP)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80006300 & 0xFFFF))
                }

                Return (0x80006300)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x20)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x20)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x20, Arg0)
            }
        }

        Device (DP2)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80006301 & 0xFFFF))
                }

                Return (0x80006301)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x40)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x40)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x40, Arg0)
            }
        }

        Method (UCMP, 2, NotSerialized)
        {
            If ((0x10 != SizeOf (Arg0)))
            {
                Return (Zero)
            }

            If ((0x10 != SizeOf (Arg1)))
            {
                Return (Zero)
            }

            Local0 = Zero
            While ((Local0 < 0x10))
            {
                If ((DerefOf (Arg0 [Local0]) != DerefOf (Arg1 [Local0]
                    )))
                {
                    Return (Zero)
                }

                Local0++
            }

            Return (One)
        }

        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
            If ((UCMP (Arg0, ToUUID ("d4a50b75-65c7-46f7-bfb7-41514cea0244") /* Unknown UUID */) == One))
            {
                If ((Arg1 != 0x0102))
                {
                    Return (0x80000002)
                }

                _T_0 = Arg2
                If ((_T_0 == 0x00))
                {
                    VDP1 (0x06, 0x00)
                    Return (Buffer (0x04)
                    {
                         0x21, 0x00, 0x08, 0x00                           // !...
                    })
                }
                ElseIf ((_T_0 == 0x05))
                {
                    CreateDWordField (Arg3, 0x00, DSTS)
                    If ((DSTS & 0x01000000))
                    {
                        GATD = (DSTS & 0x0FFF)
                        GACD = ((DSTS >> 0x0C) & 0x0FFF)
                    }

                    Return (Buffer (0x04)
                    {
                         0x00, 0x00, 0x00, 0x00                           // ....
                    })
                }
                ElseIf ((_T_0 == 0x13))
                {
                    Return (Buffer (0x04)
                    {
                         0x00, 0x06, 0x00, 0x00                           // ....
                    })
                }

                Return (0x80000002)
            }

            Return (0x80000001)
        }

        Method (EVD1, 2, NotSerialized)
        {
            If ((EVD5 == 0x01))
            {
                Notify (\_SB.PCI0.AGP.VID, 0x80) // Status Change
            }
        }

        Method (EVD2, 2, NotSerialized)
        {
            If ((EVD5 == 0x01))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.PCI0.AGP.VID, 0xD1) // Hardware-Specific
                }
                Else
                {
                    Notify (\_SB.PCI0.AGP.VID, 0xD2) // Hardware-Specific
                }
            }
        }

        Method (EVD3, 2, NotSerialized)
        {
            If ((Arg0 == 0x03))
            {
                If ((EVD5 == 0x01))
                {
                    If ((OSID () < 0x20))
                    {
                        VDP1 (0x05, Arg1)
                    }

                    Notify (\_SB.LID, 0x80) // Status Change
                    Sleep (0x01F4)
                }
            }
        }
    }

    Scope (\_SB.PCI0.PEG3.VID)
    {
        OperationRegion (NVHM, SystemMemory, NVHA, 0x00010400)
        Field (NVHM, AnyAcc, NoLock, Preserve)
        {
            NVSG,   128, 
            NVSZ,   32, 
            NVVR,   32, 
            Offset (0x100), 
            NVHO,   32, 
            RVBS,   32, 
            Offset (0x180), 
            TNDI,   8, 
            DGND,   8, 
            IGND,   8, 
            Offset (0x190), 
            Offset (0x1B0), 
            DDI1,   32, 
            DDI2,   32, 
            DDI3,   32, 
            DDI4,   32, 
            DDI5,   32, 
            DDI6,   32, 
            DDI7,   32, 
            DDI8,   32, 
            Offset (0x200), 
            GACD,   16, 
            GATD,   16, 
            Offset (0x260), 
            DCP1,   32, 
            DCP2,   32, 
            DCP3,   32, 
            DCP4,   32, 
            DCP5,   32, 
            DCP6,   32, 
            DCP7,   32, 
            DCP8,   32, 
            DCA1,   32, 
            DCA2,   32, 
            DCA3,   32, 
            DCA4,   32, 
            DCA5,   32, 
            DCA6,   32, 
            DCA7,   32, 
            DCA8,   32, 
            DNA1,   32, 
            DNA2,   32, 
            DNA3,   32, 
            DNA4,   32, 
            DNA5,   32, 
            DNA6,   32, 
            DNA7,   32, 
            DNA8,   32, 
            Offset (0x3C0), 
            RAPM,   8, 
            EAPM,   8, 
            TSLC,   16, 
            DNDI,   8, 
            Offset (0x400), 
            RBF1,   262144, 
            RBF2,   262144
        }
    }

    Scope (\_SB.PCI0.PEG3.VID)
    {
        Name (EVD4, Buffer (0x01){})
        CreateByteField (EVD4, 0x00, EVD5)
        OperationRegion (PCS, PCI_Config, 0x00, 0x0100)
        Field (PCS, AnyAcc, NoLock, WriteAsZeros)
        {
            VVID,   16, 
            Offset (0x0A), 
            DCLS,   16
        }

        Method (VINI, 2, NotSerialized)
        {
            If ((Arg0 == 0x02))
            {
                EVD5 = 0x00
                Local1 = DCLS /* \_SB_.PCI0.PEG3.VID_.DCLS */
                If ((DCLS == 0x0300))
                {
                    EVD5 = 0x01
                }
            }
        }

        Name (VDP7, Buffer (0x02)
        {
             0x00, 0x00                                       // ..
        })
        CreateByteField (VDP7, 0x01, VDP8)
        Method (DINI, 2, NotSerialized)
        {
            If ((Arg0 == 0x02))
            {
                VDP8 = 0x01
            }
        }

        Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
        {
            VDP8 = Arg0
            VDP1 (0x01, VDP8)
        }

        Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
        {
            Return (Package (0x06)
            {
                0x80000100, 
                0x80002400, 
                0x80007302, 
                0x80007303, 
                0x80006300, 
                0x80006301
            })
        }

        Device (CRT)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80000100 & 0xFFFF))
                }

                Return (0x80000100)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x02)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x02)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x02, Arg0)
            }
        }

        Device (LCD)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80002400 & 0xFFFF))
                }

                Return (0x80002400)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x01)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x01)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x01, Arg0)
            }

            Name (BRT0, 0x64)
            Name (DBCL, Package (0x12){})
            Method (_BCL, 0, Serialized)  // _BCL: Brightness Control Levels
            {
                Name (BRT1, Buffer (0x12){})
                CreateByteField (BRT1, 0x00, BRT2)
                BRT2 = 0x01
                Local2 = GENS (0x09, BRT1, SizeOf (BRT1))
                Local0 = 0x00
                Local1 = 0x12
                While ((Local0 < Local1))
                {
                    Local3 = BBRD (Local2, Local0)
                    DBCL [Local0] = Local3
                    Local0++
                }

                Return (DBCL) /* \_SB_.PCI0.PEG3.VID_.LCD_.DBCL */
            }

            Method (_BCM, 1, Serialized)  // _BCM: Brightness Control Method
            {
                Name (BRT3, Buffer (0x02){})
                CreateByteField (BRT3, 0x00, BRT4)
                CreateByteField (BRT3, 0x01, BRT5)
                BRT4 = 0x02
                BRT5 = Arg0
                BRT0 = Arg0
                GENS (0x09, BRT3, SizeOf (BRT3))
            }

            Method (_BQC, 0, Serialized)  // _BQC: Brightness Query Current
            {
                Local0 = GENS (0x09, 0x03, 0x00)
                BRT0 = Local0
                Return (Local0)
            }

            Scope (\_SB.PCI0.PEG3.VID)
            {
                Method (BRT6, 2, NotSerialized)
                {
                    If ((Arg0 == 0x01))
                    {
                        Notify (\_SB.PCI0.PEG3.VID.LCD, 0x86) // Device-Specific
                    }

                    If ((Arg0 & 0x02))
                    {
                        Notify (\_SB.PCI0.PEG3.VID.LCD, 0x87) // Device-Specific
                    }
                }
            }
        }

        Device (DVI)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80007302 & 0xFFFF))
                }

                Return (0x80007302)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x08)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x08)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x08, Arg0)
            }
        }

        Device (DVI2)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80007303 & 0xFFFF))
                }

                Return (0x80007303)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x10)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x10)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x10, Arg0)
            }
        }

        Device (DP)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80006300 & 0xFFFF))
                }

                Return (0x80006300)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x20)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x20)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x20, Arg0)
            }
        }

        Device (DP2)
        {
            Method (_ADR, 0, NotSerialized)  // _ADR: Address
            {
                If ((OSID () < 0x20))
                {
                    Return ((0x80006301 & 0xFFFF))
                }

                Return (0x80006301)
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Local0 = VDP1 (0x02, 0x40)
                Return (Local0)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Local0 = VDP1 (0x03, 0x40)
                Return (Local0)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
                VDP2 (0x40, Arg0)
            }
        }

        Method (UCMP, 2, NotSerialized)
        {
            If ((0x10 != SizeOf (Arg0)))
            {
                Return (Zero)
            }

            If ((0x10 != SizeOf (Arg1)))
            {
                Return (Zero)
            }

            Local0 = Zero
            While ((Local0 < 0x10))
            {
                If ((DerefOf (Arg0 [Local0]) != DerefOf (Arg1 [Local0]
                    )))
                {
                    Return (Zero)
                }

                Local0++
            }

            Return (One)
        }

        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
            If ((UCMP (Arg0, ToUUID ("d4a50b75-65c7-46f7-bfb7-41514cea0244") /* Unknown UUID */) == One))
            {
                If ((Arg1 != 0x0102))
                {
                    Return (0x80000002)
                }

                _T_0 = Arg2
                If ((_T_0 == 0x00))
                {
                    VDP1 (0x06, 0x00)
                    Return (Buffer (0x04)
                    {
                         0x21, 0x00, 0x08, 0x00                           // !...
                    })
                }
                ElseIf ((_T_0 == 0x05))
                {
                    CreateDWordField (Arg3, 0x00, DSTS)
                    If ((DSTS & 0x01000000))
                    {
                        GATD = (DSTS & 0x0FFF)
                        GACD = ((DSTS >> 0x0C) & 0x0FFF)
                    }

                    Return (Buffer (0x04)
                    {
                         0x00, 0x00, 0x00, 0x00                           // ....
                    })
                }
                ElseIf ((_T_0 == 0x13))
                {
                    Return (Buffer (0x04)
                    {
                         0x00, 0x06, 0x00, 0x00                           // ....
                    })
                }

                Return (0x80000002)
            }

            Return (0x80000001)
        }

        Method (EVD1, 2, NotSerialized)
        {
            If ((EVD5 == 0x01))
            {
                Notify (\_SB.PCI0.PEG3.VID, 0x80) // Status Change
            }
        }

        Method (EVD2, 2, NotSerialized)
        {
            If ((EVD5 == 0x01))
            {
                If ((Arg1 == 0x00))
                {
                    Notify (\_SB.PCI0.PEG3.VID, 0xD1) // Hardware-Specific
                }
                Else
                {
                    Notify (\_SB.PCI0.PEG3.VID, 0xD2) // Hardware-Specific
                }
            }
        }

        Method (EVD3, 2, NotSerialized)
        {
            If ((Arg0 == 0x03))
            {
                If ((EVD5 == 0x01))
                {
                    If ((OSID () < 0x20))
                    {
                        VDP1 (0x05, Arg1)
                    }

                    Notify (\_SB.LID, 0x80) // Status Change
                    Sleep (0x01F4)
                }
            }
        }
    }

    Scope (\)
    {
        Mutex (SMIX, 0x01)
        Name (SMIB, 0xCBF4C000)
        Name (PSMI, 0x000000B2)
        Method (SNVC, 1, NotSerialized)
        {
            OperationRegion (WWPR, SystemMemory, SMIB, 0x04)
            Field (WWPR, DWordAcc, Lock, Preserve)
            {
                SCDW,   32
            }

            SCDW = Arg0
        }

        Method (SNWB, 2, NotSerialized)
        {
            Local0 = SMIB /* \SMIB */
            Local0 += Arg1
            Local0 += 0x04
            OperationRegion (WWPR, SystemMemory, Local0, 0x01)
            Field (WWPR, ByteAcc, Lock, Preserve)
            {
                SBY0,   8
            }

            CreateByteField (Arg0, Arg1, SVAL)
            SBY0 = SVAL /* \SNWB.SVAL */
        }

        Method (SNRB, 2, NotSerialized)
        {
            Local0 = SMIB /* \SMIB */
            Local0 += Arg1
            Local0 += 0x04
            OperationRegion (WWPR, SystemMemory, Local0, 0x04)
            Field (WWPR, ByteAcc, Lock, Preserve)
            {
                SBY0,   8
            }

            CreateByteField (Arg0, Arg1, SVAL)
            SVAL = SBY0 /* \SNRB.SBY0 */
            Return (Arg0)
        }

        Method (SNVP, 2, NotSerialized)
        {
            Local0 = SMIB /* \SMIB */
            Local0 += Arg1
            Local0 += 0x04
            OperationRegion (WWPR, SystemMemory, Local0, 0x04)
            Field (WWPR, ByteAcc, Lock, Preserve)
            {
                SDW0,   32
            }

            CreateDWordField (Arg0, Arg1, SVAL)
            SDW0 = SVAL /* \SNVP.SVAL */
        }

        Method (SNVG, 2, NotSerialized)
        {
            Local0 = SMIB /* \SMIB */
            Local0 += Arg1
            Local0 += 0x04
            OperationRegion (WWPR, SystemMemory, Local0, 0x04)
            Field (WWPR, ByteAcc, Lock, Preserve)
            {
                SDW0,   32
            }

            CreateDWordField (Arg0, Arg1, SVAL)
            SVAL = SDW0 /* \SNVG.SDW0 */
            Return (Arg0)
        }

        Method (GENS, 3, NotSerialized)
        {
            Acquire (SMIX, 0xFFFF)
            Local0 = Arg1
            If ((ObjectType (Arg1) == 0x01))
            {
                Local0 = SMBI (Arg0, Arg1)
            }

            If ((ObjectType (Arg1) == 0x03))
            {
                Local0 = SMBF (Arg0, Arg1, Arg2)
            }

            Release (SMIX)
            Return (Local0)
        }

        Method (SMBI, 2, NotSerialized)
        {
            SNVC (Arg0)
            Local0 = (SMIB + 0x04)
            OperationRegion (WWPR, SystemMemory, Local0, 0x04)
            Field (WWPR, ByteAcc, Lock, Preserve)
            {
                SDW0,   32
            }

            SDW0 = Arg1
            ASMI ()
            Return (SDW0) /* \SMBI.SDW0 */
        }

        Method (SMBF, 3, NotSerialized)
        {
            If ((Arg2 > 0xFC))
            {
                Return (Arg1)
            }

            If ((SizeOf (Arg1) < Arg2))
            {
                Return (Arg1)
            }

            SNVC (Arg0)
            Divide (Arg2, 0x04, Local3, Local4)
            Local0 = 0x00
            While ((Local0 < Local3))
            {
                SNWB (Arg1, Local0)
                Local0++
            }

            While ((Local0 < Arg2))
            {
                SNVP (Arg1, Local0)
                Local0 += 0x04
            }

            ASMI ()
            Local0 = 0x00
            While ((Local0 < Local3))
            {
                Arg1 = SNRB (Arg1, Local0)
                Local0++
            }

            While ((Local0 < Arg2))
            {
                Arg1 = SNVG (Arg1, Local0)
                Local0 += 0x04
            }

            Return (Arg1)
        }

        Method (ASMI, 0, NotSerialized)
        {
            OperationRegion (SMIR, SystemIO, PSMI, 0x01)
            Field (SMIR, ByteAcc, Lock, Preserve)
            {
                SCMD,   8
            }

            SCMD = 0x04
        }
    }

    Scope (\_SB)
    {
        Device (AMW0)
        {
            Mutex (WMIX, 0x01)
            Name (_HID, "*pnp0c14")  // _HID: Hardware ID
            Name (_UID, 0x00)  // _UID: Unique ID
            Name (_WDG, Buffer (0x64)
            {
                /* 0000 */  0xBC, 0xDC, 0x9D, 0x8D, 0x97, 0xA9, 0xDA, 0x11,  // ........
                /* 0008 */  0xB0, 0x12, 0xB6, 0x22, 0xA1, 0xEF, 0x54, 0x92,  // ..."..T.
                /* 0010 */  0x41, 0x41, 0x01, 0x00, 0xCE, 0x93, 0x05, 0xA8,  // AA......
                /* 0018 */  0x97, 0xA9, 0xDA, 0x11, 0xB0, 0x12, 0xB6, 0x22,  // ......."
                /* 0020 */  0xA1, 0xEF, 0x54, 0x92, 0x42, 0x41, 0x01, 0x02,  // ..T.BA..
                /* 0028 */  0x94, 0x59, 0xBB, 0x9D, 0x97, 0xA9, 0xDA, 0x11,  // .Y......
                /* 0030 */  0xB0, 0x12, 0xB6, 0x22, 0xA1, 0xEF, 0x54, 0x92,  // ..."..T.
                /* 0038 */  0xD0, 0x00, 0x01, 0x08, 0xE0, 0x6C, 0x77, 0xA3,  // .....lw.
                /* 0040 */  0x88, 0x1E, 0xDB, 0x11, 0xA9, 0x8B, 0x08, 0x00,  // ........
                /* 0048 */  0x20, 0x0C, 0x9A, 0x66, 0x42, 0x43, 0x01, 0x00,  //  ..fBC..
                /* 0050 */  0x21, 0x12, 0x90, 0x05, 0x66, 0xD5, 0xD1, 0x11,  // !...f...
                /* 0058 */  0xB2, 0xF0, 0x00, 0xA0, 0xC9, 0x06, 0x29, 0x10,  // ......).
                /* 0060 */  0x4D, 0x4F, 0x01, 0x00                           // MO..
            })
            Name (INFO, Buffer (0x80){})
            Name (ECD0, 0x00)
            Method (WED0, 1, NotSerialized)
            {
                ECD0 = Arg0
                Return (Zero)
            }

            Method (WCAA, 1, NotSerialized)
            {
                Return (Zero)
            }

            Method (WQAA, 1, NotSerialized)
            {
                Acquire (WMIX, 0xFFFF)
                BCLR (INFO)
                If ((Arg0 != 0x00))
                {
                    Local1 = INFO /* \_SB_.AMW0.INFO */
                }
                Else
                {
                    BDWR (INFO, 0x00, 0x4C4C4544)
                    BDWR (INFO, 0x04, 0x494D5720)
                    BDWR (INFO, 0x08, 0x01)
                    BDWR (INFO, 0x0C, 0x80)
                    Local1 = INFO /* \_SB_.AMW0.INFO */
                }

                Release (WMIX)
                Return (Local1)
            }

            Method (WSAA, 2, NotSerialized)
            {
                Return (Arg1)
            }

            Method (WMBA, 3, NotSerialized)
            {
                CreateDWordField (Arg2, 0x28, WBUF)
                Local1 = (WBUF + 0x2C)
                If ((Local1 <= 0x80))
                {
                    Local0 = WMI (Arg2, Local1)
                }

                Return (Local0)
            }

            Method (WMI, 2, NotSerialized)
            {
                If ((Arg1 <= 0x80))
                {
                    Arg0 = GENS (0x03, Arg0, Arg1)
                }

                Return (Arg0)
            }

            Name (WQMO, Buffer (0x04F8)
            {
                /* 0000 */  0x46, 0x4F, 0x4D, 0x42, 0x01, 0x00, 0x00, 0x00,  // FOMB....
                /* 0008 */  0xE8, 0x04, 0x00, 0x00, 0xD8, 0x15, 0x00, 0x00,  // ........
                /* 0010 */  0x44, 0x53, 0x00, 0x01, 0x1A, 0x7D, 0xDA, 0x54,  // DS...}.T
                /* 0018 */  0x28, 0xD5, 0x8A, 0x00, 0x01, 0x06, 0x18, 0x42,  // (......B
                /* 0020 */  0x10, 0x0D, 0x10, 0x22, 0x21, 0x04, 0x12, 0x01,  // ..."!...
                /* 0028 */  0xA1, 0xC8, 0x2C, 0x0C, 0x86, 0x10, 0x38, 0x2E,  // ..,...8.
                /* 0030 */  0x84, 0x1C, 0x40, 0x48, 0x1C, 0x14, 0x4A, 0x08,  // ..@H..J.
                /* 0038 */  0x84, 0xFA, 0x13, 0xC8, 0xAF, 0x00, 0x84, 0x0E,  // ........
                /* 0040 */  0x05, 0xC8, 0x14, 0x60, 0x50, 0x80, 0x53, 0x04,  // ...`P.S.
                /* 0048 */  0x11, 0xF4, 0x2A, 0xC0, 0xA6, 0x00, 0x93, 0x02,  // ..*.....
                /* 0050 */  0x2C, 0x0A, 0xD0, 0x2E, 0xC0, 0xB2, 0x00, 0xDD,  // ,.......
                /* 0058 */  0x02, 0xA4, 0xC3, 0x12, 0x91, 0xE0, 0x28, 0x31,  // ......(1
                /* 0060 */  0xE0, 0x28, 0x9D, 0xD8, 0xC2, 0x0D, 0x1B, 0xBC,  // .(......
                /* 0068 */  0x50, 0x14, 0xCD, 0x20, 0x4A, 0x82, 0xCA, 0x05,  // P.. J...
                /* 0070 */  0xF8, 0x46, 0x10, 0x78, 0xB9, 0x02, 0x24, 0x4F,  // .F.x..$O
                /* 0078 */  0x40, 0x9A, 0x05, 0x18, 0x16, 0x60, 0x5D, 0x80,  // @....`].
                /* 0080 */  0xEC, 0x21, 0x50, 0xA9, 0x43, 0x40, 0xC9, 0x19,  // .!P.C@..
                /* 0088 */  0x02, 0x6A, 0x00, 0xAD, 0x4E, 0x40, 0xF8, 0x95,  // .j..N@..
                /* 0090 */  0x4E, 0x09, 0x49, 0x10, 0xCE, 0x58, 0xC5, 0xE3,  // N.I..X..
                /* 0098 */  0x6B, 0x16, 0x4D, 0xCF, 0x49, 0xCE, 0x31, 0xE4,  // k.M.I.1.
                /* 00A0 */  0x78, 0x5C, 0xE8, 0x41, 0xF0, 0x40, 0x0A, 0x40,  // x\.A.@.@
                /* 00A8 */  0x58, 0x78, 0x08, 0x45, 0x80, 0x41, 0x49, 0x18,  // Xx.E.AI.
                /* 00B0 */  0x0B, 0x75, 0x31, 0x6A, 0xD4, 0x48, 0xD9, 0x80,  // .u1j.H..
                /* 00B8 */  0x0C, 0x51, 0xDA, 0xA8, 0xD1, 0x03, 0x3A, 0xBF,  // .Q....:.
                /* 00C0 */  0x23, 0x39, 0xBB, 0xA3, 0x3B, 0x92, 0x04, 0x46,  // #9..;..F
                /* 00C8 */  0x3D, 0xA6, 0x63, 0x2C, 0x6C, 0x46, 0x42, 0x8D,  // =.c,lFB.
                /* 00D0 */  0xD1, 0x1C, 0x14, 0x81, 0xC6, 0x0D, 0xDA, 0x12,  // ........
                /* 00D8 */  0x61, 0x35, 0xAE, 0xD8, 0x67, 0x66, 0xE1, 0xC3,  // a5..gf..
                /* 00E0 */  0x12, 0xC6, 0x11, 0x1C, 0x58, 0x82, 0x46, 0xD1,  // ....X.F.
                /* 00E8 */  0x34, 0xC7, 0xB3, 0x0D, 0x91, 0xE0, 0x20, 0x42,  // 4..... B
                /* 00F0 */  0x63, 0x64, 0x40, 0xC8, 0xF3, 0xB0, 0x05, 0x7A,  // cd@....z
                /* 00F8 */  0xE4, 0x09, 0xEC, 0x1E, 0x51, 0x0A, 0x11, 0x34,  // ....Q..4
                /* 0100 */  0xDF, 0x13, 0xA9, 0x51, 0x80, 0x36, 0x0C, 0xD9,  // ...Q.6..
                /* 0108 */  0x3A, 0x1B, 0x68, 0xA8, 0xB1, 0x1A, 0x43, 0x11,  // :.h...C.
                /* 0110 */  0x44, 0x84, 0xA0, 0x51, 0x0C, 0x16, 0x21, 0x54,  // D..Q..!T
                /* 0118 */  0x88, 0xFF, 0x7F, 0x94, 0xA8, 0xA7, 0x14, 0x24,  // .......$
                /* 0120 */  0x6A, 0x65, 0x20, 0x42, 0x0B, 0x66, 0x04, 0x66,  // je B.f.f
                /* 0128 */  0x7F, 0x10, 0x24, 0xC6, 0x99, 0x41, 0x87, 0x05,  // ..$..A..
                /* 0130 */  0xCB, 0x00, 0x91, 0x11, 0x41, 0xA3, 0x61, 0x67,  // ....A.ag
                /* 0138 */  0x01, 0x0F, 0xC7, 0x33, 0x69, 0x7E, 0x62, 0x1A,  // ...3i~b.
                /* 0140 */  0x9C, 0x09, 0xC6, 0x3E, 0x3F, 0x50, 0x51, 0x07,  // ...>?PQ.
                /* 0148 */  0x07, 0x4A, 0x60, 0x29, 0x03, 0x27, 0xB6, 0xC7,  // .J`).'..
                /* 0150 */  0xA5, 0xF1, 0x9D, 0x71, 0xD4, 0x10, 0xA7, 0x7E,  // ...q...~
                /* 0158 */  0x66, 0xFE, 0x47, 0x78, 0x0B, 0x3E, 0x02, 0xF0,  // f.Gx.>..
                /* 0160 */  0x31, 0x78, 0xB0, 0x87, 0x10, 0xF0, 0x08, 0xD9,  // 1x......
                /* 0168 */  0x19, 0xC0, 0x80, 0x78, 0xEF, 0x93, 0x26, 0x73,  // ...x..&s
                /* 0170 */  0xF1, 0x59, 0x00, 0xC6, 0xF0, 0xE1, 0x1A, 0x1F,  // .Y......
                /* 0178 */  0x85, 0xC6, 0xC3, 0xCE, 0x07, 0x6C, 0x5C, 0x1C,  // .....l\.
                /* 0180 */  0xDE, 0x87, 0x82, 0x13, 0x2E, 0x16, 0x44, 0x01,  // ......D.
                /* 0188 */  0x20, 0x24, 0xEB, 0x7C, 0x80, 0x9E, 0xF5, 0xB1,  //  $.|....
                /* 0190 */  0x05, 0x7C, 0x18, 0x68, 0xF6, 0x0E, 0x41, 0x08,  // .|.h..A.
                /* 0198 */  0x5E, 0x04, 0x7C, 0x74, 0xF0, 0x71, 0xC3, 0xE3,  // ^.|t.q..
                /* 01A0 */  0x7E, 0xDE, 0x00, 0xC3, 0xE1, 0xC0, 0xC3, 0xF1,  // ~.......
                /* 01A8 */  0x69, 0x03, 0xB8, 0x8C, 0x80, 0x4B, 0x7B, 0x52,  // i....K{R
                /* 01B0 */  0x98, 0x40, 0x92, 0x9F, 0x00, 0x12, 0x03, 0x83,  // .@......
                /* 01B8 */  0x3A, 0x10, 0xF8, 0x60, 0x01, 0x57, 0x12, 0x1C,  // :..`.W..
                /* 01C0 */  0x6A, 0x78, 0x9E, 0xD8, 0x03, 0xC2, 0xFF, 0xFF,  // jx......
                /* 01C8 */  0x28, 0x4F, 0xE4, 0xC5, 0xC0, 0xD3, 0x7F, 0x0C,  // (O......
                /* 01D0 */  0x80, 0x71, 0x40, 0xF0, 0xB4, 0x4E, 0xCA, 0x37,  // .q@..N.7
                /* 01D8 */  0x8F, 0x07, 0x09, 0x0F, 0x2A, 0x4C, 0x02, 0x9F,  // ....*L..
                /* 01E0 */  0x12, 0x18, 0x1A, 0x3F, 0x6E, 0x80, 0x75, 0xD4,  // ...?n.u.
                /* 01E8 */  0xF8, 0x03, 0x02, 0xBC, 0x93, 0xC4, 0xF9, 0xF5,  // ........
                /* 01F0 */  0x39, 0x00, 0x1D, 0x1A, 0x4E, 0x91, 0x81, 0xBC,  // 9...N...
                /* 01F8 */  0x06, 0x9C, 0xF4, 0x29, 0x79, 0x7C, 0x09, 0x7C,  // ...)y|.|
                /* 0200 */  0xE6, 0x80, 0x7D, 0x37, 0x38, 0x8C, 0x83, 0x09,  // ..}78...
                /* 0208 */  0x11, 0xE1, 0x3D, 0xE0, 0xA9, 0xC3, 0x77, 0x8D,  // ..=...w.
                /* 0210 */  0x47, 0x81, 0x40, 0x11, 0x7A, 0x3B, 0x73, 0xD0,  // G.@.z;s.
                /* 0218 */  0x53, 0x88, 0x51, 0xA2, 0x9D, 0x55, 0x98, 0x07,  // S.Q..U..
                /* 0220 */  0x8E, 0x28, 0x3E, 0x72, 0x18, 0xE1, 0xDD, 0xC3,  // .(>r....
                /* 0228 */  0x77, 0x82, 0x07, 0x90, 0xD6, 0x26, 0x27, 0xDC,  // w....&'.
                /* 0230 */  0x40, 0xCF, 0x1C, 0x2C, 0xDA, 0x99, 0x45, 0x16,  // @..,..E.
                /* 0238 */  0x40, 0x14, 0x69, 0x34, 0xA8, 0x33, 0x82, 0x4F,  // @.i4.3.O
                /* 0240 */  0x03, 0x9E, 0xD6, 0x53, 0x8C, 0x8F, 0x12, 0x06,  // ...S....
                /* 0248 */  0x39, 0xC3, 0x03, 0x7B, 0x4E, 0x78, 0x0C, 0xF0,  // 9..{Nx..
                /* 0250 */  0x80, 0xD9, 0xFD, 0xC0, 0xC7, 0x09, 0x9F, 0x0B,  // ........
                /* 0258 */  0xF0, 0xAE, 0x01, 0x35, 0x43, 0x1F, 0x36, 0xE0,  // ...5C.6.
                /* 0260 */  0x1C, 0x3A, 0xF0, 0xA7, 0x09, 0xFC, 0xC1, 0x02,  // .:......
                /* 0268 */  0x3F, 0x1E, 0x5F, 0x73, 0xD8, 0x84, 0x13, 0x58,  // ?._s...X
                /* 0270 */  0xFE, 0x20, 0x50, 0x23, 0x33, 0xB4, 0x67, 0x79,  // . P#3.gy
                /* 0278 */  0x5A, 0xAF, 0x01, 0x3E, 0xED, 0x98, 0xC0, 0xE7,  // Z..>....
                /* 0280 */  0x0D, 0xFF, 0xFF, 0xFF, 0x39, 0x1E, 0x0F, 0xF8,  // ....9...
                /* 0288 */  0x15, 0x9F, 0x2E, 0xC8, 0x5D, 0xC1, 0xF3, 0xF5,  // ....]...
                /* 0290 */  0xD9, 0x85, 0xD9, 0x18, 0x0F, 0x6A, 0x14, 0x3E,  // .....j.>
                /* 0298 */  0xE0, 0xE0, 0xCE, 0x2E, 0x3E, 0x02, 0xF8, 0xEC,  // ....>...
                /* 02A0 */  0x02, 0x3C, 0x27, 0xF1, 0x2C, 0x01, 0xDE, 0x43,  // .<'.,..C
                /* 02A8 */  0x80, 0x4F, 0x24, 0xF1, 0x1E, 0xB6, 0x60, 0x8C,  // .O$...`.
                /* 02B0 */  0x18, 0x0F, 0x79, 0xC6, 0x55, 0x0F, 0x43, 0x17,  // ..y.U.C.
                /* 02B8 */  0x01, 0xAB, 0xBB, 0xAF, 0xA0, 0x8E, 0x5E, 0x60,  // ......^`
                /* 02C0 */  0x82, 0x7A, 0xCD, 0xC0, 0x9D, 0x5E, 0x80, 0xCF,  // .z...^..
                /* 02C8 */  0x29, 0x0B, 0xDE, 0xFF, 0xFF, 0x94, 0x05, 0xDC,  // ).......
                /* 02D0 */  0xAF, 0x0A, 0xFC, 0x88, 0x02, 0x06, 0xC8, 0xCE,  // ........
                /* 02D8 */  0x4E, 0x27, 0x42, 0x78, 0x2F, 0x79, 0x0E, 0xF1,  // N'Bx/y..
                /* 02E0 */  0xED, 0xCA, 0x07, 0x93, 0x20, 0xCF, 0x01, 0x11,  // .... ...
                /* 02E8 */  0x9E, 0xB2, 0xF8, 0x7D, 0x20, 0x4A, 0xCC, 0x03,  // ...} J..
                /* 02F0 */  0x8A, 0x14, 0xC5, 0x88, 0x41, 0x9E, 0xB0, 0x7C,  // ....A..|
                /* 02F8 */  0x3D, 0x89, 0x61, 0xE8, 0x60, 0xE1, 0xC2, 0x47,  // =.a.`..G
                /* 0300 */  0x78, 0xCA, 0x02, 0x2C, 0x5E, 0xB2, 0x30, 0xA7,  // x..,^.0.
                /* 0308 */  0x2C, 0x60, 0xF0, 0xFF, 0x3F, 0x65, 0x81, 0x6B,  // ,`..?e.k
                /* 0310 */  0xDC, 0x4F, 0x59, 0xC0, 0x4C, 0xFA, 0x73, 0x92,  // .OY.L.s.
                /* 0318 */  0x9C, 0x6A, 0xF4, 0x04, 0x50, 0xF4, 0x83, 0x05,  // .j..P...
                /* 0320 */  0x85, 0xF1, 0x29, 0x0B, 0x70, 0x25, 0xEF, 0x80,  // ..).p%..
                /* 0328 */  0x00, 0x9A, 0xB3, 0x93, 0x6F, 0x0B, 0x06, 0x3B,  // ....o..;
                /* 0330 */  0x66, 0x5F, 0x32, 0x7C, 0x4A, 0x04, 0xC3, 0x21,  // f_2|J..!
                /* 0338 */  0xC3, 0x77, 0xAA, 0x43, 0x79, 0xE4, 0x78, 0x0A,  // .w.Cy.x.
                /* 0340 */  0xF0, 0x11, 0x0B, 0xEC, 0x71, 0x8E, 0x01, 0x3A,  // ....q..:
                /* 0348 */  0xAE, 0xF8, 0x88, 0xE5, 0xFF, 0xFF, 0x11, 0x0B,  // ........
                /* 0350 */  0xE0, 0xC6, 0x01, 0x04, 0x7F, 0xEA, 0x80, 0x75,  // .......u
                /* 0358 */  0x0F, 0x08, 0xEB, 0x43, 0x07, 0xF0, 0x90, 0xFD,  // ...C....
                /* 0360 */  0x10, 0xD0, 0x19, 0xC6, 0x92, 0x41, 0x64, 0xE3,  // .....Ad.
                /* 0368 */  0x5C, 0x43, 0xC7, 0x68, 0xF1, 0x0B, 0xD5, 0x4D,  // \C.h...M
                /* 0370 */  0x21, 0xF6, 0xC1, 0x70, 0xD9, 0x40, 0x02, 0xF5,  // !..p.@..
                /* 0378 */  0x70, 0x2D, 0x98, 0x42, 0xA2, 0x68, 0x34, 0x1A,  // p-.B.h4.
                /* 0380 */  0x03, 0x13, 0x18, 0xC1, 0x19, 0xC4, 0x80, 0xCE,  // ........
                /* 0388 */  0x08, 0xA1, 0x43, 0x19, 0x4E, 0xC5, 0x79, 0x08,  // ..C.N.y.
                /* 0390 */  0xF5, 0xFF, 0x27, 0x18, 0xEA, 0xC6, 0x44, 0x67,  // ..'...Dg
                /* 0398 */  0xE7, 0xF9, 0xF3, 0xDB, 0x88, 0x4F, 0x04, 0x06,  // .....O..
                /* 03A0 */  0xF6, 0x15, 0xE2, 0x2D, 0x03, 0x2C, 0xC3, 0xF2,  // ...-.,..
                /* 03A8 */  0xE2, 0x9E, 0x00, 0x8E, 0xF1, 0x24, 0x13, 0x54,  // .....$.T
                /* 03B0 */  0x73, 0xAC, 0x41, 0xCD, 0xC1, 0x57, 0x81, 0x37,  // s.A..W.7
                /* 03B8 */  0x32, 0x13, 0xF8, 0x0A, 0x06, 0xB6, 0xD3, 0x0C,  // 2.......
                /* 03C0 */  0x46, 0xDF, 0x9D, 0x00, 0x14, 0x40, 0x3E, 0x0A,  // F....@>.
                /* 03C8 */  0xF8, 0xBE, 0xFC, 0x36, 0xC0, 0x66, 0xF1, 0xCA,  // ...6.f..
                /* 03D0 */  0x6C, 0x34, 0x9F, 0x3F, 0x11, 0x43, 0x47, 0x89,  // l4.?.CG.
                /* 03D8 */  0x19, 0x3A, 0x05, 0xF1, 0xD0, 0x1D, 0x74, 0xE8,  // .:....t.
                /* 03E0 */  0xE8, 0xE3, 0x80, 0x4F, 0x56, 0xB8, 0x60, 0x87,  // ...OV.`.
                /* 03E8 */  0x2F, 0x68, 0x93, 0x3B, 0xDA, 0x13, 0xF3, 0x2C,  // /h.;...,
                /* 03F0 */  0x3C, 0x4F, 0xDC, 0xDC, 0xC1, 0x74, 0x44, 0x82,  // <O...tD.
                /* 03F8 */  0x31, 0x78, 0xCC, 0xE4, 0xC1, 0x2C, 0x70, 0xF2,  // 1x...,p.
                /* 0400 */  0xA0, 0xF8, 0xFF, 0x4F, 0x1E, 0x26, 0x3C, 0x26,  // ...O.&<&
                /* 0408 */  0xEC, 0xE1, 0x90, 0x1E, 0x3A, 0x3C, 0x32, 0x3E,  // ....:<2>
                /* 0410 */  0x4E, 0x9F, 0x7E, 0x18, 0xF6, 0xE9, 0x9C, 0x4B,  // N.~....K
                /* 0418 */  0xD1, 0x33, 0xD2, 0x1D, 0xE3, 0x99, 0x0B, 0x03,  // .3......
                /* 0420 */  0xEB, 0x91, 0x73, 0x58, 0xA3, 0x85, 0x3D, 0xE0,  // ..sX..=.
                /* 0428 */  0xE7, 0x10, 0xDF, 0x61, 0x7C, 0xE0, 0x61, 0xB0,  // ...a|.a.
                /* 0430 */  0x3E, 0xBD, 0x80, 0xE3, 0xF8, 0x05, 0xFF, 0x34,  // >......4
                /* 0438 */  0x00, 0x9E, 0x03, 0x88, 0xC7, 0xF0, 0x02, 0xC2,  // ........
                /* 0440 */  0x8F, 0x2F, 0x3A, 0xFF, 0x52, 0xA1, 0x8B, 0x93,  // ./:.R...
                /* 0448 */  0x3C, 0x18, 0xD4, 0x69, 0x0A, 0x70, 0x75, 0x7A,  // <..i.puz
                /* 0450 */  0x03, 0xCF, 0x55, 0x1F, 0x77, 0x96, 0xC2, 0xFD,  // ..U.w...
                /* 0458 */  0xFF, 0xCF, 0x52, 0x30, 0x0E, 0xBF, 0xBE, 0xC0,  // ..R0....
                /* 0460 */  0xFB, 0x2E, 0x65, 0x84, 0x03, 0x79, 0x96, 0x02,  // ..e..y..
                /* 0468 */  0x7B, 0xEC, 0x67, 0x88, 0x0E, 0x01, 0x3E, 0x4B,  // {.g...>K
                /* 0470 */  0x01, 0xFC, 0x78, 0x7D, 0xF8, 0x3C, 0x03, 0x37,  // ..x}.<.7
                /* 0478 */  0xF0, 0xE9, 0x17, 0x68, 0xFD, 0xFF, 0x4F, 0x21,  // ...h..O!
                /* 0480 */  0xE0, 0x3F, 0x46, 0xF8, 0x88, 0x83, 0x3B, 0xFA,  // .?F...;.
                /* 0488 */  0x02, 0xB7, 0x83, 0x31, 0x3F, 0x63, 0xE0, 0x8E,  // ...1?c..
                /* 0490 */  0x63, 0xC0, 0xE3, 0xE4, 0x8C, 0x3B, 0x4D, 0x78,  // c....;Mx
                /* 0498 */  0x08, 0x7C, 0x00, 0xAD, 0x4E, 0x8F, 0x9C, 0x7A,  // .|..N..z
                /* 04A0 */  0x4E, 0x09, 0x77, 0x1C, 0xE0, 0x53, 0xC2, 0x0D,  // N.w..S..
                /* 04A8 */  0x00, 0xA3, 0xD0, 0xA6, 0x4F, 0x8D, 0x46, 0xAD,  // ....O.F.
                /* 04B0 */  0x1A, 0x94, 0xA9, 0x51, 0xA6, 0x41, 0xAD, 0x3E,  // ...Q.A.>
                /* 04B8 */  0x95, 0x1A, 0x33, 0xA6, 0x03, 0xCE, 0xAF, 0x03,  // ..3.....
                /* 04C0 */  0x1D, 0x0F, 0x1C, 0xEA, 0x85, 0x20, 0x10, 0x4B,  // ..... .K
                /* 04C8 */  0x7A, 0x75, 0x08, 0xC4, 0xA2, 0x3C, 0x80, 0xB0,  // zu...<..
                /* 04D0 */  0xB8, 0x26, 0x40, 0x98, 0xF0, 0x37, 0x81, 0x40,  // .&@..7.@
                /* 04D8 */  0x1C, 0x1B, 0x84, 0x8A, 0xA5, 0x97, 0x91, 0xF1,  // ........
                /* 04E0 */  0x19, 0x44, 0x40, 0x0E, 0xE1, 0x03, 0x88, 0x45,  // .D@....E
                /* 04E8 */  0x02, 0x11, 0x38, 0x51, 0x02, 0x4A, 0x9D, 0x80,  // ..8Q.J..
                /* 04F0 */  0x30, 0xA1, 0xAF, 0x06, 0x81, 0xF8, 0xFF, 0x0F   // 0.......
            })
        }
    }

    Scope (\_SB.AMW0)
    {
        Name (WMEV, 0x00)
        Name (WMBU, Buffer (0x80){})
        Name (WM, 0x00)
        Method (SWEV, 1, NotSerialized)
        {
            WMEV |= Arg0
        }

        Method (CWEV, 1, NotSerialized)
        {
            WMEV &= ~Arg0
        }

        Method (WVSP, 0, NotSerialized)
        {
            Acquire (WMIX, 0xFFFF)
            WM = 0x00
            BCLR (WMBU)
        }

        Method (WVCU, 0, NotSerialized)
        {
            Acquire (WMIX, 0xFFFF)
            WM = 0x00
        }

        Method (WVPT, 1, NotSerialized)
        {
            Local0 = WM /* \_SB_.AMW0.WM__ */
            Local0 += 0x02
            If ((Local0 <= SizeOf (WMBU)))
            {
                CreateWordField (WMBU, WM, WMWD)
                WMWD = Arg0
                WM = Local0
            }
        }

        Method (_WED, 1, NotSerialized)  // _Wxx: Wake Event, xx=0x00-0xFF
        {
            WVSP ()
            If ((Arg0 != 0xD0))
            {
                WVCU ()
                Return (WMBU) /* \_SB_.AMW0.WMBU */
            }

            If ((ECD0 == 0x00))
            {
                WVCU ()
                Return (WMBU) /* \_SB_.AMW0.WMBU */
            }

            If ((WMEV & 0x0200))
            {
                CWEV (0x0200)
                WVPT (0x02)
                WVPT (0x00)
                WVPT (0xE045)
            }
            ElseIf ((WMEV & 0x0100))
            {
                CWEV (0x0100)
                If (ECG4 ())
                {
                    WVPT (0x02)
                    WVPT (0x00)
                    WVPT (0xE043)
                }
                Else
                {
                    WVPT (0x02)
                    WVPT (0x00)
                    WVPT (0xE044)
                }
            }
            ElseIf ((WMEV & 0x0800))
            {
                WMBU = EC0A (WMBU)
                CWEV (0x0800)
            }

            WVCU ()
            Return (WMBU) /* \_SB_.AMW0.WMBU */
        }
    }

    Scope (\)
    {
        Method (WMNF, 2, NotSerialized)
        {
            \_SB.AMW0.SWEV (Arg0)
            Notify (\_SB.AMW0, 0xD0) // Hardware-Specific
        }
    }

    Scope (\_SB.PCI0.LPCB)
    {
        Device (PS2M)
        {
            Name (_HID, EisaId ("DLL040C"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0F13") /* PS/2 Mouse */)  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IRQ (Edge, ActiveHigh, Exclusive, )
                    {12}
            })
            Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
            {
                StartDependentFn (0x00, 0x00)
                {
                    IRQNoFlags ()
                        {12}
                }
                EndDependentFn ()
            })
        }
    }

    Method (\AWAK, 1, NotSerialized)
    {
        Return (Package (0x02)
        {
            0x00, 
            0x00
        })
    }

    Method (\APTS, 1, NotSerialized)
    {
    }

    Name (\_S0, Package (0x04)  // _S0_: S0 System State
    {
        0x00, 
        0x00, 
        0x00, 
        0x00
    })
    Name (\_S3, Package (0x04)  // _S3_: S3 System State
    {
        0x05, 
        0x00, 
        0x00, 
        0x00
    })
    Name (\_S4, Package (0x04)  // _S4_: S4 System State
    {
        0x06, 
        0x00, 
        0x00, 
        0x00
    })
    Name (\_S5, Package (0x04)  // _S5_: S5 System State
    {
        0x07, 
        0x00, 
        0x00, 
        0x00
    })
    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        \APTS (Arg0)
        \EV5 (Arg0, 0x00)
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        \EV2 (Arg0, 0x00)
        \AWAK (Arg0)
        Return (0x00)
    }

    Scope (\_SB.PCI0)
    {
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            \EV1 (0x02, 0x00)
        }
    }

    Method (\EV9, 2, NotSerialized)
    {
        \_SB.PCI0.AGP.VID.EVD2 (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.EVD2 (Arg0, Arg1)
    }

    Method (\EV11, 2, NotSerialized)
    {
        \_SB.BTEV (Arg0, Arg1)
    }

    Method (\EV7, 2, NotSerialized)
    {
        \_SB.PCI0.LPCB.DCK4 (Arg0, Arg1)
    }

    Method (\EV13, 2, NotSerialized)
    {
        \_SB.PCI0.AGP.VID.EVD1 (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.EVD1 (Arg0, Arg1)
        \_SB.PCI0.VID.IVD1 (Arg0, Arg1)
    }

    Method (\EV8, 2, NotSerialized)
    {
        WMNF (Arg0, Arg1)
    }

    Method (\EV3, 2, NotSerialized)
    {
        \_SB.PCI0.SAT0.SEC0.ODDE (Arg0, Arg1)
    }

    Method (\EV15, 2, NotSerialized)
    {
    }

    Method (\EV4, 2, NotSerialized)
    {
        \_PR.PPCE (Arg0, Arg1)
    }

    Method (\EV1, 2, NotSerialized)
    {
        \_SB.PCI0.AGP.VID.DINI (Arg0, Arg1)
        \_SB.PCI0.AGP.VID.VINI (Arg0, Arg1)
        \_SB.PCI0.IINI (Arg0, Arg1)
        \_SB.PCI0.LPCB.EINI (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.DINI (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.VINI (Arg0, Arg1)
        \_SB.PCI0.VID.DINI (Arg0, Arg1)
        \_SB.PCI0.VID.VINI (Arg0, Arg1)
        \_SB.SOS0 (Arg0, Arg1)
    }

    Method (\EV5, 2, NotSerialized)
    {
        ECS1 (Arg0, Arg1)
        \_SB.PCI0.VID.IVD4 (Arg0, Arg1)
    }

    Method (\EV6, 2, NotSerialized)
    {
        \_SB.BTNV (Arg0, Arg1)
        \_SB.PCI0.AGP.VID.EVD3 (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.EVD3 (Arg0, Arg1)
        \_SB.PCI0.VID.ILDE (Arg0, Arg1)
    }

    Method (\EV12, 2, NotSerialized)
    {
        \_SB.PCI0.AGP.VID.BRT6 (Arg0, Arg1)
        \_SB.PCI0.PEG3.VID.BRT6 (Arg0, Arg1)
        \_SB.PCI0.VID.BRT6 (Arg0, Arg1)
    }

    Method (\EV14, 2, NotSerialized)
    {
        \_SB.PCI0.VID.IVD2 (Arg0, Arg1)
    }

    Method (\EV10, 2, NotSerialized)
    {
        \_SB.ACEV (Arg0, Arg1)
    }

    Method (\EV2, 2, NotSerialized)
    {
        \_GPE.NWAK (Arg0, Arg1)
        \_SB.CBAT (Arg0, Arg1)
        \_SB.PCI0.LPCB.DCK5 (Arg0, Arg1)
        \_SB.PCI0.LPCB.ECDV.ECM9 (Arg0, Arg1)
        \_SB.PCI0.VID.IVD3 (Arg0, Arg1)
        \_SB.SOS4 (Arg0, Arg1)
    }
}

