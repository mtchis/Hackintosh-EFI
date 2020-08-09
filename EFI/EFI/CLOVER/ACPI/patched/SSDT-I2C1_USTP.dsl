// Touchpad activation with VoodooInput, VoodooI2C, and HID satellite kexts.
// "Infinite Click" in polling mode is fixed by assining USTP to One
// created by whatnameisit thanks to williambj1 and ben9923
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "what", "elan", 0x00000000)
{
#endif
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (USTP, One)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
