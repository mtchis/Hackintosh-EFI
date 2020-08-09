// PS2 remap
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "what", "ps2", 0x00000000)
{
#endif
    Name (_SB.PCI0.LPCB.PS2K.RMCF, Package (0x02)
    {
        "Keyboard", 
        Package ()
        {
            "Custom PS2 Map", 
            Package ()
            {
                Package (){}, 
                "3f=0", // Map f5 to nothing
                "40=0", // Map f6 to nothing
                // Uncomment if you want to use non-macOS USB keyboard to map PS2 to USB keyboard
                // Then use Karabiner-Elements to switch back
                // Then you would disable the above two mapping lines and make K-E do the work
                /*"e05b=3a", // PS2-left-cmd to ADB-left-alt
                "38=37" // PS2-left-alt to ADB-left-cmd
                */
            }
        }
    })
#ifndef NO_DEFINITIONBLOCK
}
#endif