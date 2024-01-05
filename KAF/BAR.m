//  BAR.m Created by SHINYA TAKAHASHI on 2023/05/29.

#import <UIKit/UIKit.h>
#import "CTRL.h"



@interface BAR : UIView
@end



@implementation BAR {
    void *_delegate;
    BUTTONCallback _cb;
    void *btns[2];
}



static void buttonCallback(void *delegate, i32 ID, i32 event)
{
    BAR *bar = (__bridge BAR *)delegate;
    if (bar->_cb) bar->_cb(bar->_delegate, ID, event);
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++ interface +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

void *BARNew(void *parent, f64_4 frame, void *delegate, BUTTONCallback cb)
{
    BAR *bar = [[BAR alloc] initWithFrame:CGRectMake(frame.x, frame.y, frame.w, frame.h)];
    bar.backgroundColor = [UIColor systemGray4Color];
    bar.alpha = 0.8;
    bar.clipsToBounds = YES;
    bar->_delegate = delegate;
    bar->_cb = cb;
    [(__bridge UIView *)parent addSubview:bar];
    
    bar->btns[0] = BUTTONNew((__bridge void *)bar, (f64_4){5, 5, 100, frame.h - 10}, 0, 1, (__bridge void *)bar, buttonCallback);
    BUTTONSetTitle(bar->btns[0], "KBD");
    
    bar->btns[1] = BUTTONNew((__bridge void *)bar, (f64_4){frame.w - 105, 5, 100, frame.h - 10}, 1, 1, (__bridge void *)bar, buttonCallback);
    BUTTONSetTitle(bar->btns[1], "SUB-BAR");
    
    return (__bridge void *)bar;
}



void BARForceTurnOnFor(void *bar, i64 idx)
{
    BAR *bar_ = (__bridge BAR *)bar;
    BUTTONForceTurnOn(bar_->btns[idx]);
}



void BARForceTurnOffFor(void *bar, i64 idx)
{
    BAR *bar_ = (__bridge BAR *)bar;
    BUTTONForceTurnOff(bar_->btns[idx]);
}



@end

















