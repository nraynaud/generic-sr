#!/usr/bin/python
# careful with the import order here
# FileSR has a circular dependency: FileSR- > blktap2 -> lvutil -> EXTSR -> FileSR
# importing in this order seems to avoid triggering the issue.
import SR
import SRCommand
import FileSR

from lock import Lock

DRIVER_INFO = {
    'name': 'GENERIC DIRECTORY SR',
    'description': 'SR plugin which stores disks as VHD files in a directory',
    'vendor': 'Vates SAS',
    'copyright': '(C) 2018 Vates SAS',
    'driver_version': '1.0',
    'required_api_version': '1.0',
    'capabilities': ["VDI_CREATE", "VDI_DELETE", "VDI_ATTACH", "VDI_DETACH",
                     "VDI_UPDATE", "VDI_CLONE", "VDI_SNAPSHOT", "VDI_RESIZE", "VDI_MIRROR",
                     "VDI_GENERATE_CONFIG",
                     "VDI_RESET_ON_BOOT/2", "ATOMIC_PAUSE"],
    'configuration': [['directory', 'Absolute path of the VDI directory']]
}


class GENERICSR(FileSR.FileSR):

    def handles(sr_type):
        # fudge, because the parent class (FileSR) checks for smb to alter its behavior
        return sr_type == 'generic'

    handles = staticmethod(handles)


if __name__ == '__main__':
    SRCommand.run(GENERICSR, DRIVER_INFO)
else:
    SR.registerSR(GENERICSR)
