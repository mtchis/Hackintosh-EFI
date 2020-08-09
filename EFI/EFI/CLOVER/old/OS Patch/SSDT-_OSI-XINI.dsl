// Alternative to XOSI patch
// Use with the provided config.plist ACPI patch: config-_OSI.XINI.plist
// credit whatnameisit
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "_OSI", 0x00000000)
{
#endif
    External (OSYS, FieldUnitObj)    // (from opcode)

    Method (XINI, 0, NotSerialized)
    {
        // Original Store (0x07D, OSYS) in DSDT is changed to call XINI in this SSDT
        Store (0x07D0, OSYS)
        If (LAnd (CondRefOf (\_OSI), _OSI ("Darwin"))) // If the booted OS is "Darwin" aka macOS
        {
            If (_OSI ("Darwin"))
            {
                Store (0x07DF, OSYS) // Make "Darwin" act like "Windows 2015"
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif