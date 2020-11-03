#pragma once

#define BLOWER_USB_SERIAL_VID      4292
#define BLOWER_USB_SERIAL_PID      60000

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_BOARD_IO   100 // ms
#else
#define TEI_FOR_BOARD_IO   1500 // ms
#endif

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_BLOWER_RBMDSI   130 // ms
#else
#define TEI_FOR_BLOWER_RBMDSI   1500 // ms
#endif
