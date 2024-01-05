// KAF : Keyboard Animation Follower

#pragma once
#include "MM.h"



#define KAF_EVENT_NON               0
#define KAF_EVENT_WILL_SHOW         1
#define KAF_EVENT_WILL_HIDE         2
#define KAF_EVENT_DIDEND_ANIMATE    3


// event listner callback type
typedef void(*KAFCallback)(void *delegate, i32 event);


// utility
void  KAFGetRectsInFrameWithHeights(f64_4 frame, f64 header_h, f64 footer_h, f64_4 *headerRect, f64_4 *bodyRect, f64_4 *footerRect);
f64_4 KAFGetSafeArea(void *view);

// add listner
void KAFAddListner(void *listner, KAFCallback cb);

// add animation view
void KAFAddBody(void *body, KAFCallback cb);
void KAFSetFooter(void *footer);

// sub-bar
void KAFReboundSubFooter(void *subFooter, f64 subFooterEndHeight);
void KAFShrinkSubFooter(void *subFooter);

// 基本色HSBAの定義
#define COLOR_FONT              (f64_4){1.0, 0.1, 0.1, 1.0}
#define COLOR_HEADER            (f64_4){0.6, 0.5, 0.7, 1.0}
#define COLOR_BODY              (f64_4){0.6, 0.5, 1.0, 1.0}
#define COLOR_FOOTER            (f64_4){0.6, 0.5, 0.6, 1.0}
#define COLOR_SUBBAR            (f64_4){0.6, 0.5, 0.7, 1.0}
#define COLOR_BUTTON_OFF        (f64_4){0.6, 0.5, 0.75, 1.0}
#define COLOR_BUTTON_ON         (f64_4){0.5, 0.8, 1.0, 1.0}
#define COLOR_BUTTON_TOGGLE_ON  (f64_4){0.5, 0.6, 0.8, 1.0}

// OSカラーに変換
void *OSColorFromHSBA(f64_4 hsba);









