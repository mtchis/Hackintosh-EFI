# Asus Vivobook X510UA-BQ490

Tested on 10.14.4-10.15 (Clover) and 10.15 Beta 2 (OpenCore) 

![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## System specification

1. Name:           Asus Vivobook X510UA-BQ490
2. CPU:            Intel Core i5-8250U
3. Graphics:        Intel UHD Graphics 620 // Dual monitor with HDMI (Index 2) and 2048 MB VRAM
4. Wifi:           Intel Dual Band Wireless-AC 8265 - with bluetooth // REPLACED WITH DW1560 (AirDrop and Handoff Working perfectly)
5. Card Reader:    Connected via USB
6. Camera:         ASUS UVC HD
7. Audio:          Conexant Audio CX8050
8. Touchpad:       ELAN1200
9. Bios Version:   309

## Thing will not able to use

1. FN + media controller's key

## Known problems

1.  Not on X510UA-BQ490

## VoodooI2C

1. Polling mode for smooth movements and gestures
2. Finger ID-implemented VoodooInput and VoodooI2C for persistent gesture input

## Attention please
1. Note that this fork is mostly for my laptop only (X510UA-BQ490). If yours has similar features such as no dGPU and no KB backlight, try, but at your own risk. Otherwise, please go to tctien342's original master branch or hieplpvip's Zenbook repository.
2. If the versions of your VirtualSMC and corresponding efi driver and plugins do not match, touchpad and other battery issues may arise. Please make sure to download the most recent stable release of the SMC package and install them accordingly.

## Steps to install

1. Prepare USB drive with macOS installer mounted on it.
2. Replace EFI folder in USB EFI partition with the EFI folder in Clover EFI.
3. Boot into USB and select macOS installer.
4. During the installation, touchpad does not work. You need a mouse connected through USB. (Or you may delete the IOGraphicsFamily dependency from VoodooI2CHID.kext/info.plist. or force-load it in config.plist/KernelAndKextPatches/ForceKextsToLoad.) Follow installation instructions found on tonymacx86 or other hackintosh forums.
5. After installation, boot into macOS, copy kexts In /kexts/Other -> /Library/Extension.
6. Use Kext Utility (or simply copy this line without the quotation marks: "sudo chmod -R 755 /L*/E*&&sudo chown -R 0:0 /L*/E*&&sudo kextcache -i /") to rebuild kext cache then reboot.
    - If you have installed Catalina, use [Hackintool](http://headsoft.com.au/download/mac/Hackintool.zip) to disable Gate Keeper beforehand.
7. Now the touchpad and sound input should function correctly. You need to mount EFI and copy Clover EFI to the system EFI partition in like what you have done on USB EFI partition.
8. After System EFI replaced by your EFI, use Clover Configurator to change SMBIOS, generate your serial and MBL.
- Note: You may want to complete these extra steps.
    - You want to replace the WiFi/Bluetooth card for macOS support -- Replace WiFi/Bluetooth card
    - You have replaced the WiFi/Bluetooth card but Bluetooth fails upon wake from sleep -- Set Bluetooth port as internal
    - You have not replaced the WiFi/Bluetooth card but want to have working iMessage and FaceTime with USB WiFi dongle or USB LAN -- Install RehabMan's Null Ethernet
    - You have Sleep and Airplane fn keys -- Activate Sleep and Airplane fn keys
    - You want to get rid of the control buttons to nonexistent keyboard backlight -- Remap PS2
    - You want to try a different _OSI patch -- Replace XOSI patch
    - (OpenCore) You want to enable full power management -- Unlock MSR 0xE2 (CFG Lock)


## Replace WiFi/Bluetooth card

1. Replace your stock card with BCM94360NG.
2. Go to /kexts/other/additional and copy the two Brcm kexts for Mojave (Repo and RAM2) and three for Catalina (Repo, Injector, RAM3) to /L*/E* and rebuild cache.
3. Reboot.
- Note 1: There are a few other options to replace and get the WiFi/Bluetooth working to the fullest as of 2020.04.12.
    - Fenvi's AC1200 BCM94352Z (No WiFi kext required.)
    - Other BCM94352Z variants (WiFi kext required)
    - BCM94350ZAE variants (WiFi kext required. pci-aspm-default set to 0, 66, or 67. Refer to this [issue](https://github.com/acidanthera/bugtracker/issues/794#issuecomment-608139817))
    - DW1830 (No WiFi kext required. An extension cord is needed as the card does not fit into the slot)
- Note 2: It is unknown to me whether no kext for WiFi required also means the same for Bluetooth. If you can test it yourself, please share the results.

## Set Bluetooth port as internal

1. Make sure USB injection kexts or SSDT-UIA.aml are not loaded.
2. Download [Hackintool](http://headsoft.com.au/download/mac/Hackintool.zip) by headkaze.
3. Under the USB tab, identify the Bluetooth port and set it as internal. The UVC camera can also be set as internal. Export and obtain the codeless injection kext and SSDTs in ~/Desktop. Delete the SSDTs.
4. Install the USBPorts.kext in /L*/E*.
5. Rebuild cache and reboot.

## Install RehabMan's Null Ethernet

1. Copy /kexts/other/additional/NullEthernet.kext to /L*/E* and rebuild cache.
2. Copy /ACPI/additional/SSDT-RMNE to /ACPI/patched.
3. Reboot.
- Note 1: For iMessage, FaceTime, and App Store to function correctly with RMNE, I recommend you install RMNE before trying to connect to any USB networking devices. Otherwise, you need to reset the network mapping by having RMNE set to en0. Use Google.
- Note 2: The stock Intel WiFi/Bluetooth card can be made to work with limitations. [WiFi](https://github.com/zxystd/itlwm) and [Bluetooth](https://github.com/zxystd/IntelBluetoothFirmware/releases). You need to build the WiFi kext with XCode. If you are satisfied with how it works, you can delete RMNE.

## Activate Sleep and Airplane fn keys

1. Download Release of [AsusSMC](https://github.com/hieplpvip/AsusSMC/releases).
2. Run install_daemon.sh by dragging it onto terminal.
- Note: Reboot if the script does not seem to work. After updating your EFI folder or any kexts, you may need to rerun the script.

## Remap PS2

1. Use MaciASL to save ACPI/additional/SSDT-PS2.dsl with the .aml extension in Patched folder.
2. Reboot.
- Optional: If you have a non-macOS USB keyboard, uncommenting the code in SSDT-PS2.dsl will swap left-cmd and left-alt. Install and configure Karabiner-Elements to switch back left-cmd and left-alt. This result in the same mapping in your PS2 keyboard and USB keyboard.

## Replace XOSI patch
Pick one of the below two patches.
### Insert _OSI for "Darwin"
1. Delete ACPI/Patched/SSDT-XOSI.aml.
2. Use MaciASL to save ACPI/replacement/SSDT-_OSI-XINI.dsl with the .aml extension in Patched folder.
3. Delete the _OSI and OSID patch in config.plist/ACPI/DSDT/Patches and copy OSYS patch from /replacement/config-_OSI-XINI.plist/ACPI/DSDT/Patches to config.plist.
4. Reboot.
### Assign OSYS "Windows 2015" value
1. Delete ACPI/Patched/SSDT-XOSI.aml.
2. Use MaciASL to save ACPI/replacement/SSDT-OSYS.dsl with the .aml extension in Patched folder.
3. Reboot.
- In my opinion, SSDT-OSYS.dsl is safer than SSDT-_OSI-XINI.dsl.

## Unlock MSR 0xE2 (CFG Lock)
- Note: You need to know which BIOS version matches your laptop model. Otherwise, there may be a permanent damage to your laptop.
1. Follow [Dortania's guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/extras/msr-lock).
2. The offset will be at 0x527 if your BIOS version is 309.

## When you think you are done

1. Update Clover, kexts, and efi files, but make sure to delete VoodooInput.kext inside VoodooPS2Controller.kext.
2. Backup your /L*/E* by copying them to the system EFI partition and/or installation USB EFI partition.

## Other things

1. OpenCore
    - Load CC from /L*/E*
    - Booting Windows is OK if you use KMS license.
    - Need to configure BlessOverride
2. Clover
    - If you can't get Fn keys to work (namely touchpad enable/disable), try loading all kexts except CC from Clover in which case BrcmFirmwareData needs to load instead of BrcmFirmwareRepo.
    - If you update kexts, you need to delete VoodooInput.kext in VoodooPS2Controller.kext/Contents/Plugins to avoid loading VoodooInput twice. VoodooInput.kext, which is required by VoodooI2C for MT2 emulation, is already bundled with VoodooI2C.
## Changelog
May 9, 2020
- Reverted _PTS patch as it is a workaround to correctly shutdown without restarting which is no longer needed.
- Switched from VoodooTSCSync.kext to CpuTscSync.kext to fix rare kernel panic on wake.

April 24, 2020
- Added back _PTS part in ACPI to avoid "Device not ejected properly" message on wake.

April 12, 2020
- Updated OpenCore to r0.5.7 and VoodooI2C to r2.4.

March 23, 2020
- Use Finger ID-implemented VoodooInput and VoodooI2C for persistent touchpad gestures.

March 4, 2020
- Updated OpenCore to 0.5.6.

February 3, 2020
- Updated OpenCore to 0.5.4.

January 27, 2020 
- Updated kexts and Clover.
- AppleALC.kext stays on 1.4.2. Built AsusSMC.kext 1.2.0 with 10.15.2 and latest Lilu and VirtualSMC SDKs.
- Added NoTouchID.kext and other SMC sensor kexts.
- Deleted .efi files specific to FileVault. If needed, they can be obtained from the Release.

December 28, 2019
- Reverted back to AppleALC 1.4.2 with the layout-id 03000000, reinstalled CodecCommander and the corresponding SSDT: SSDT-CC.aml
- Reinstall USBPorts.kext to comply with ACPI specifications.

December 26, 2019
- Deleted USB configuration as not needed for working bluetooth on wake from sleep in 10.15.2: deleted USBPorts.kext.
- Changed SMBIOS to MacBookPro15,4 and added NoTouchID.kext.
- Switched CPUFriendDataProvider.kext to a new one: BPOWER-CPUFriendDataProvider.kext.

December 16, 2019
- Set the default touchpad patch to be SSDT-I2C1_USTP.aml.

-December 15, 2019
- Updated AppleALC to 1.4.4 and deleted CodecCommander and the corresponding patches.

October 28, 2019
- Added a simplified and minimum patch of the touchpad code in ACPI: SSDT-I2Cx_USTP.dsl.

October 26, 2019
- Update bluetooth kexts: BrcmPatchRAM2, BrcmPatchRAM3, BrcmFirmwareData, BrcmFirmwareRepo, BrcmBluetoothInjector.kext.

October 6, 2019
- Added the general touchpad polling mode patch that corresponds to the laptops in hieplpvip's repo: config-touchpad_general.plist, SSDT-ELAN-General.aml

October 4, 2019
- Separated fake EC device from main SSDT: SSDT-EC.aml.

September 28, 2019
- Deleted some entries in /config.plist/ACPI/DSDT/Fixes and added an SSDT to make the laptop behave more like MBP14,1: FixMutex, FixIPIC, FixHPET, SSDT-HPET.aml.

September 27, 2019
- Added back MATH and LDR2 devices: SSDT-MATHLDR2_STA.aml.

September 26, 2019
- Added another XOSI replacement patch: SSDT-OSYS.dsl.
- Added the steps to write your own touchpad SSDT.

September 13, 2019
- Option to replace XOSI patch by invoking If _OSI Darwin with SSDT-_OSI-XINI.dsl.
- Delete SSDT-PS2.aml and add SSDT-PS2.dsl with comments.

Prior to September 13, 2019
- Touchpad now uses polling mode with SSDT-X510UA-Touchpad.aml with assignment of FMCN and SSCN with activation from USTP=1 for proper clicks.
- Trimmed down SSDT-S510UA-KabyLakeR.aml and removed SSDT-RP01_PEGP for X510UA-BQ490.
- Removed XHC AAPL properties as not required as of Sierra.
- Removed Sinetek-rtsx.kext as the SD Card Reader is connected via USB.
- Removed SSDT-UIA.aml and included USBPorts.kext and information for proper USB configuration and working BT after sleep.
- Removed BT4LEContinuityFixup.kext and FakePCIID.kext and the FakePCIID plugin as AirportBrcmFixup, BrcmBluetoothInjector, BrcmFirmwareRepo, and BrcmPatchRAM2 are enough.
- Separated the RMNE device.
- Moved IGPU and HDEF contents from ACPI to config.plist.
- Made F5 and F6 keys do nothing with SSDT-PS2.aml as they are associated with keyboard backlight which X510UA-BQ490 does not have.

## Credits

Apple for macOS

tctien342 and hieplpvip for Asus repositories

The VoodooI2C helpdesk for working touchpad

headkaze for Hackintool

RehabMan for Null Ethernet and many other things

daliansky and williambj1 for many hotpatch methods

LeeBinder for many helps

fewtarius for new CPUFriendDataProvider.kext and SMBIOS

The Acidanthera team for OpenCore and many kexts

zxystd for Intel WiFi/Bluetooth support

## For Koreans
[README-kr](README-kr.md)를 참고하십시오.
