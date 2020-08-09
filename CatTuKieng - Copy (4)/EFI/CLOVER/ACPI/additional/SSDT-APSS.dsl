// APSS lookup in non-mac OS is done with Method APSS returning the renamed APXX.
// created by whatnameisit
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "what", "APSS", 0x00000000)
{
#endif
    External (_SB_.APXX, FieldUnitObj)    // (from opcode)

    If (LNot (_OSI ("Darwin")))
    {
        Method (APSS)
        {
            Return (\_SB.APXX)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif