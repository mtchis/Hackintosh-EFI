// created by hieplpvip, modified by whatnameisit
// Polling mode
DefinitionBlock ("", "SSDT", 2, "hack", "tpad_gen", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.ETPD, DeviceObj)    // (from opcode)
// Uncomment if you have SMD0 in Method(_SB.PCI0.I2C0._STA) and also understand what the condition means.
/*
    External (SMD0, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.I2C0, DeviceObj)    // (from opcode)
    Scope (_SB.PCI0.I2C0)
    {
        If (LAnd (_OSI ("Darwin"), LEqual (SMD0, 0x02)))
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }
    }
*/
    Scope (_SB.PCI0.I2C1)
    {
        Name (USTP, One)
    }

    Scope (_SB.PCI0.I2C1.ETPD)
    {
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (SBFB)
        }
    }
}

