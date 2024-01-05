//  OSCTRL.h Created by SHINYA TAKAHASHI on 2023/09/10.

#pragma once
#include "MM.h"



/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++ BUTTON ++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

#define Event_ButtonOn_L   'BONL'
#define Event_ButtonOn_R   'BONR'
#define Event_ButtonOff    'BOFF'



typedef void(*BUTTONCallback)(void *delegate, i32 ID, i32 event);



void *BUTTONNew(void *parent, f64_4 frame, i32 ID, i32 usingToggle, void *delegate, BUTTONCallback cb);
void  BUTTONSetTitle(void *btn, char *title);
void  BUTTONForceTurnOn(void *btn);
void  BUTTONForceTurnOff(void *btn);

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++ BAR +++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

void *BARNew(void *parent, f64_4 frame, void *delegate, BUTTONCallback cb);
void  BARForceTurnOnFor(void *bar, i64 idx);
void  BARForceTurnOffFor(void *bar, i64 idx);








