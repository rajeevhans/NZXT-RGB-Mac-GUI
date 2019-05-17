# NZXT RGB Mac GUI
## For Hackintosh computers in NZXT RGB cases (H500i)

This app adds a menu icon at the top of the screen which will allow you to turn RGB on/off.  
It uses Apple's internal HID driver to send commands to the NZXT RGB controller over USB.  

At the moment, the app only supports solid white light on/off (this is the only mode I use).  
You can add other modes and submit a pull request; I will merge them into here.  
See "How to add modes" below.

### Compatibility
This app is made for the NZXT H500i case, but should be compatible with other cases that use the same USB RGB controller:  
Vendor ID: 0x1e71  
Product ID: 0x1714

### RGB Support
The commands were captured using libpcap in Wireshark on Windows.  
You can expand the functionality by capturing more commands and adding them to the app.  
At the moment, the app only supports solid white light on/off.

### Reference:

Tried using:
https://github.com/libusb/libusb  
With example code from:
https://stackoverflow.com/questions/29428775/not-able-to-transfer-data-through-libusb  
But got error:
libusb: error [darwin_claim_interface] USBInterfaceOpen: another process has device opened for exclusive access  
Upon further research:
https://github.com/libusb/libusb/issues/158  
"Also, it might be better for you to use libhid to access this device.
Due to the way Microsoft handles USB a lot of devices erroneously use HID to avoid having to make a driver."  
So used this library to send data using the OS's HID APIs:
https://github.com/signal11/hidapi

### How to add modes

1. Use Wireshark with libpcap (optional during install process) to capture data from the NZXT CAM software while changing modes.  
- In Wireshark, select the packet and right-click "Leftover Capture Data" (to get packet payload alone without header) -> Export Packet Bytes...  
- Then, run "xxd -i /path/to/exported/data.bin" to get C-style arrays  
- Add to app code in AppDelegate.m, driver.h, driver.c
- Submit a pull request so I can merge your code here

### License

GNU GPL v3; see License.txt  
Uses HIDAPI from https://github.com/signal11/hidapi, also under GNU GPL v3
