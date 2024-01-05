//  BUTTON.m Created by SHINYA TAKAHASHI on 2023/05/31.

#import <UIKit/UIKit.h>
#import "KAF.h"
#import "TEXT.h"
#import "CTRL.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmultichar"



@interface BUTTON : UIView
@end



@implementation BUTTON {
    void *delegate;
    i32 ID, usingToggle, toggleStatus, prevMovingInside;
    BUTTONCallback cb;
    void *lbl;
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++ interface +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

void *BUTTONNew(void *parent, f64_4 frame, i32 ID, i32 usingToggle, void *delegate, BUTTONCallback cb)
{
    BUTTON *btn = [[BUTTON alloc] initWithFrame:CGRectMake(frame.x, frame.y, frame.w, frame.h)];
    btn.clipsToBounds = YES;
    btn->delegate = delegate;
    btn->ID = ID;
    btn->usingToggle = usingToggle;
    btn->cb = cb;
    normalColor((__bridge void *)btn);
    //OSVSetBorderAttributes((__bridge void *)btn, 1.0, 10.0, COLOR_CLEAR);
    [(__bridge UIView *)parent addSubview:btn];
    return (__bridge void *)btn;
}



void BUTTONSetTitle(void *btn, char *title)
{
    BUTTON *_btn = (__bridge BUTTON *)btn;
    
    if (!_btn->lbl) {
        _btn->lbl = TEXTNew(TEXTTYPE_LABEL, btn, (f64_4){0, 0, _btn.bounds.size.width, _btn.bounds.size.height});
        [(__bridge UIView *)_btn->lbl setBackgroundColor:[UIColor clearColor]];
    }
    TEXTSetText(_btn->lbl, title);
}



void BUTTONForceTurnOn(void *btn)
{
    BUTTON *_btn = (__bridge BUTTON *)btn;
    if (_btn->usingToggle) {
        toggleOn(btn);
        _btn->toggleStatus = 1;
        _btn->prevMovingInside = 1;
    }
}



void BUTTONForceTurnOff(void *btn)
{
    BUTTON *_btn = (__bridge BUTTON *)btn;
    normalColor(btn);
    _btn->toggleStatus = 0;
    _btn->prevMovingInside = 0;
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*++++++++++++++++++++++++++++ internal +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [(__bridge UIView *)lbl setFrame:self.bounds];
}



static void highLight(void *view)
{
    UIView *_view = (__bridge UIView *)view;
    _view.backgroundColor = (__bridge UIColor *)OSColorFromHSBA(COLOR_BUTTON_ON);
    [_view setNeedsDisplay];
}



static void toggleOn(void *view)
{
    UIView *_view = (__bridge UIView *)view;
    _view.backgroundColor = (__bridge UIColor *)OSColorFromHSBA(COLOR_BUTTON_TOGGLE_ON);
}



static void normalColor(void *view)
{
    UIView *_view = (__bridge UIView *)view;
    [UIView animateWithDuration:0.1 animations:^{
        _view.backgroundColor = (__bridge UIColor *)OSColorFromHSBA(COLOR_BUTTON_OFF);
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    prevMovingInside = 1;
    highLight((__bridge void *)self);
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    i32 inside = CGRectContainsPoint(self.bounds, p);
    if (inside && !prevMovingInside) {
        prevMovingInside = 1;
        highLight((__bridge void *)self);
    }
    else if (!inside && prevMovingInside) {
        prevMovingInside = 0;
        if (toggleStatus) toggleOn((__bridge void *)self);
        else              normalColor((__bridge void *)self);
    }
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (prevMovingInside) {
        CGPoint p = [[touches anyObject] locationInView:self];
        i32 onEvent = Event_ButtonOn_L;
        if (p.x > self.bounds.size.width / 2) onEvent = Event_ButtonOn_R;
        if (usingToggle) {
            if (toggleStatus) {
                cb(delegate, ID, Event_ButtonOff);
                normalColor((__bridge void *)self);
                toggleStatus = 0;
            }
            else {
                toggleOn((__bridge void *)self);
                cb(delegate, ID, onEvent);
                toggleStatus = 1;
            }
             // do not use !toggleStatus
        }
        else {
            if (cb) cb(delegate, ID, onEvent);
            normalColor((__bridge void *)self);
        }
    }
    else if (usingToggle == 1 && toggleStatus == 1) {
        toggleOn((__bridge void *)self);
    }
    else {
        normalColor((__bridge void *)self);
    }
}



- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



@end



#pragma clang diagnostic pop
