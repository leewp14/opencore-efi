/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20140210-00 [Feb 10 2014]
 * Copyright (c) 2000 - 2014 Intel Corporation
 * 
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000036A (874)
 *     Revision         0x01
 *     Checksum         0x00
 *     OEM ID           "APPLE "
 *     OEM Table ID     "CpuPm"
 *     OEM Revision     0x00021500 (136448)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20140210 (538182160)
 */

DefinitionBlock ("ssdt.aml", "SSDT", 1, "APPLE ", "CpuPm", 0x00021500)
{
    External (\_PR_.CPU0, DeviceObj)
    External (\_PR_.CPU1, DeviceObj)
    External (\_PR_.CPU2, DeviceObj)
    External (\_PR_.CPU3, DeviceObj)
    External (\_PR_.CPU4, DeviceObj)
    External (\_PR_.CPU5, DeviceObj)
    External (\_PR_.CPU6, DeviceObj)
    External (\_PR_.CPU7, DeviceObj)

    Scope (\_PR_.CPU0)
    {
        Method (_INI, 0, NotSerialized)
        {
            Store ("ssdtPRGen version.....: 21.5 / Mac OS X 10.13.6 (17G14033)", Debug)
            Store ("custom mode...........: 0", Debug)
            Store ("host processor........: Intel(R) Core(TM) i7 CPU Q 740 @ 1.73GHz", Debug)
            Store ("target processor......: i7-740QM", Debug)
            Store ("number of processors..: 1", Debug)
            Store ("baseFrequency.........: 933", Debug)
            Store ("frequency.............: 1733", Debug)
            Store ("busFrequency..........: 133", Debug)
            Store ("logicalCPUs...........: 8", Debug)
            Store ("maximum TDP...........: 45", Debug)
            Store ("packageLength.........: 16", Debug)
            Store ("turboStates...........: 9", Debug)
            Store ("maxTurboFrequency.....: 2933", Debug)
            Store ("machdep.xcpm.mode.....: 0", Debug)
        }

        Name (APLF, Zero)
        Name (APSN, 0x09)
        Name (APSS, Package (0x10)
        {
            /* High Frequency Modes (turbo) */
            Package (0x06) { 0x0B75, 0x00AFC8, 0x0A, 0x0A, 0x0016, 0x0016 },
            Package (0x06) { 0x0AF0, 0x00AFC8, 0x0A, 0x0A, 0x0015, 0x0015 },
            Package (0x06) { 0x0A6A, 0x00AFC8, 0x0A, 0x0A, 0x0014, 0x0014 },
            Package (0x06) { 0x09E5, 0x00AFC8, 0x0A, 0x0A, 0x0013, 0x0013 },
            Package (0x06) { 0x0960, 0x00AFC8, 0x0A, 0x0A, 0x0012, 0x0012 },
            Package (0x06) { 0x08DB, 0x00AFC8, 0x0A, 0x0A, 0x0011, 0x0011 },
            Package (0x06) { 0x0855, 0x00AFC8, 0x0A, 0x0A, 0x0010, 0x0010 },
            Package (0x06) { 0x07D0, 0x00AFC8, 0x0A, 0x0A, 0x000F, 0x000F },
            Package (0x06) { 0x074B, 0x00AFC8, 0x0A, 0x0A, 0x000E, 0x000E },
            /* High Frequency Modes (non-turbo) */
            Package (0x06) { 0x06C5, 0x00AFC8, 0x0A, 0x0A, 0x000D, 0x000D },
            Package (0x06) { 0x0640, 0x008025, 0x0A, 0x0A, 0x000C, 0x000C },
            Package (0x06) { 0x05BB, 0x0065B9, 0x0A, 0x0A, 0x000B, 0x000B },
            Package (0x06) { 0x0536, 0x004F36, 0x0A, 0x0A, 0x000A, 0x000A },
            Package (0x06) { 0x04B0, 0x003415, 0x0A, 0x0A, 0x0009, 0x0009 },
            Package (0x06) { 0x042B, 0x0025F8, 0x0A, 0x0A, 0x0008, 0x0008 },
            Package (0x06) { 0x03A6, 0x001AAA, 0x0A, 0x0A, 0x0007, 0x0007 }
        })

        Method (ACST, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU0.ACST Called", Debug)
            Store ("CPU0 C-States    : 13", Debug)

            /* Low Power Modes for CPU0 */
            Return (Package (0x05)
            {
                One,
                0x03,
                Package (0x04)
                {
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x01,               // Bit Width
                            0x02,               // Bit Offset
                            0x0000000000000000, // Address
                            0x01,               // Access Size
                            )
                    },
                    One,
                    Zero,
                    0x03E8
                },

                Package (0x04)
                {
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x01,               // Bit Width
                            0x02,               // Bit Offset
                            0x0000000000000010, // Address
                            0x03,               // Access Size
                            )
                    },
                    0x03,
                    0xCD,
                    0x01F4
                },

                Package (0x04)
                {
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x01,               // Bit Width
                            0x02,               // Bit Offset
                            0x0000000000000020, // Address
                            0x03,               // Access Size
                            )
                    },
                    0x06,
                    0xF5,
                    0x015E
                }
            })
        }
    }

    Scope (\_PR_.CPU1)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU1.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU2)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU2.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU3)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU3.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU4)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU4.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU5)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU5.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU6)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU6.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }

    Scope (\_PR_.CPU7)
    {
        Method (APSS, 0, NotSerialized)
        {
            Store ("Method _PR_.CPU7.APSS Called", Debug)

            Return (\_PR_.CPU0.APSS)
        }
    }
}
