// Touchpad activation with VoodooI2C and HID satellite kexts
// Specific to X510UA-BQ490
// For other products, copy contents from DSDT's ETPD device to this SSDT's ETXX device, replacing everything except _CRS and _STA
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "elan", 0x00000000)
{
#endif
    External (_SB_.PCI0.I2C0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)
    External (_SB_.TPDI, FieldUnitObj)    // (from opcode)
    External (_SB_.TPHI, FieldUnitObj)    // (from opcode)
    External (_SB_.TPIF, FieldUnitObj)    // (from opcode)
    External (SMD0, FieldUnitObj)    // (from opcode)

    Scope (_SB)
    {
        If (_OSI ("Darwin"))
        {
            Store (Zero, TPIF) // Preset the variable TPIF to turn off original ETPD device
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        If (LAnd (_OSI ("Darwin"), LEqual (SMD0, 0x02))) // Turn off the unused I2C0. This might fix issues with random stops in the touchpad
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }
    }

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (USTP, One) // "Infinite click" fix.
            Name (SSCN, Package (0x03) // Assignment of SSCN and FMCN
            {
                0x0210, 
                0x0280, 
                0x1E
            })
            Name (FMCN, Package (0x03)
            {
                0x80, 
                0xA0, 
                0x1E
            })
        }
    }

    Device (_SB.PCI0.I2C1.ETXX) // A new touchpad device with contents the same contents except _STA and _CRS
    { // This is where you replace everything except _STA and _CRS
        Name (_ADR, One)  // _ADR: Address
        Name (ETPH, Package (0x16)
        {
            "ELAN1200", 
            "ELAN1201", 
            "ELAN1203", 
            "ELAN1200", 
            "ELAN1201", 
            "ELAN1300", 
            "ELAN1301", 
            "ELAN1300", 
            "ELAN1301", 
            "ELAN1000", 
            "ELAN1200", 
            "ELAN1200", 
            "ELAN1200", 
            "ELAN1200", 
            "ELAN1200", 
            "ELAN1203", 
            "ELAN1203", 
            "ELAN1201", 
            "ELAN1300", 
            "ELAN1300", 
            "ELAN1200", 
            "ELAN1300"
        })
        Name (FTPH, Package (0x05)
        {
            "FTE1001", 
            "FTE1200", 
            "FTE1200", 
            "FTE1300", 
            "FTE1300"
        })
        Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
        {
            If (And (TPDI, 0x04))
            {
                Return (DerefOf (Index (ETPH, TPHI)))
            }

            If (And (TPDI, 0x10))
            {
                Return (DerefOf (Index (FTPH, TPHI)))
            }

            Return ("ELAN1010")
        }

        Name (_CID, "PNP0C50")  // _CID: Compatible ID
        Name (_UID, One)  // _UID: Unique ID
        Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (LEqual (Arg0, ToUUID ("3cdff6f7-4267-4555-ad05-b30a3d8938de") /* HID I2C Device */))
            {
                If (LEqual (Arg2, Zero))
                {
                    If (LEqual (Arg1, One))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                           
                        })
                    }
                    Else
                    {
                        Return (Buffer (One)
                        {
                             0x00                                           
                        })
                    }
                }

                If (LEqual (Arg2, One))
                {
                    Return (One)
                }
            }
            Else
            {
                Return (Buffer (One)
                {
                     0x00                                           
                })
            }
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F) // Turn on this device for macOS
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (SBFB) // Activate the touchpad in polling mode.
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
