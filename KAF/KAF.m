//  Created by SHINYA TAKAHASHI on 2023/06.

#import <UIKit/UIKit.h>
#import "KAF.h"



@interface KAObserver : NSObject
@end



@implementation KAObserver



static UIView *_footer = nil, *_subFooter = nil;
static NSMutableDictionary *bodys = nil, *listners = nil;
static CGRect area = {0};
static CGRect _kbdEndFrame = {0};
static f64 _subFooterEndHeight = 0;
static i32 observerAdded = 0;
static f64 duration = 0.2;
static i64 options = UIViewAnimationOptionCurveEaseInOut;



static CGRect CGRectMerge(CGRect a, CGRect b)
{
    // 両方zeroならzeroを返す
    if (CGRectIsEmpty(a)) {
        if (CGRectIsEmpty(b)) return CGRectZero;
        else return b;
    }
    else if (CGRectIsEmpty(b)) {
        if (CGRectIsEmpty(a)) return CGRectZero;
        else return a;
    }
    else {
        return CGRectUnion(a, b);
    }
}



static void getEndFramesOfKeyboardAnimation(CGRect *bodyEndFrame, CGRect *subFooterEndFrame, CGRect *footerEndFrame)
{
    f64 areaEndY = _kbdEndFrame.origin.y < area.origin.y + area.size.height ? _kbdEndFrame.origin.y : area.origin.y + area.size.height;
    if (_kbdEndFrame.origin.y < 0.1) {
        areaEndY = area.origin.y + area.size.height;
    }
    *footerEndFrame = (CGRect){area.origin.x, areaEndY - _footer.frame.size.height, area.size.width, _footer.frame.size.height};
    *subFooterEndFrame = (CGRect){area.origin.x, (*footerEndFrame).origin.y - _subFooterEndHeight, area.size.width, _subFooterEndHeight};
    *bodyEndFrame = (CGRect){area.origin.x, area.origin.y, area.size.width, (*subFooterEndFrame).origin.y - area.origin.y};
}



static void animate(i32 event)
{
    CGRect bodyEndFrame, subFooterEndFrame, footerEndFrame;
    getEndFramesOfKeyboardAnimation(&bodyEndFrame, &subFooterEndFrame, &footerEndFrame);
    
    [bodys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        KAFCallback cb = [obj pointerValue];
        UIView *body = [key pointerValue];
        if (cb) cb((__bridge void *)body, event);
        
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            body.frame = bodyEndFrame;
        } completion:^(BOOL finished){
            if (cb) cb((__bridge void *)body, event);
        }];
    }];
    
    [listners enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        KAFCallback cb = [obj pointerValue];
        void *listner = [key pointerValue];
        if (cb) {
            cb(listner, event);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cb(listner, event);
            });
        }
    }];
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        _footer.frame = footerEndFrame;
        _subFooter.frame = subFooterEndFrame;
    } completion:nil];
}



static void addObserver(void)
{
    if (!observerAdded) {
        observerAdded = 1;
        [[NSNotificationCenter defaultCenter] addObserver:[KAObserver class]
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:[KAObserver class]
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}



+ (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    _kbdEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    options = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    animate(KAF_EVENT_WILL_SHOW);
}



+ (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    _kbdEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _subFooterEndHeight = 0;
    animate(KAF_EVENT_WILL_HIDE);
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++ interface +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

void KAFGetRectsInFrameWithHeights(f64_4 frame, f64 header_h, f64 footer_h, f64_4 *headerRect, f64_4 *bodyRect, f64_4 *footerRect)
{
    if (headerRect) {
        *headerRect = (f64_4){frame.x, frame.y, frame.w, header_h};
    }
    if (bodyRect) {
        *bodyRect = (f64_4){frame.x, frame.y + header_h, frame.w, frame.h - header_h - footer_h};
    }
    if (footerRect) {
        *footerRect = (f64_4){frame.x, frame.y + frame.h - footer_h, frame.w, footer_h};
    }
}



f64_4 KAFGetSafeArea(void *view)
{
    UIView *view_ = (__bridge UIView *)view;
    CGRect frame = view_.frame;
    UIEdgeInsets inset = view_.safeAreaInsets;
    f64_4 safeArea = {
        inset.left,
        inset.top,
        frame.size.width - inset.right - inset.left,
        frame.size.height - inset.top - inset.bottom
    };
    return safeArea;
}



void KAFAddListner(void *listner, KAFCallback cb)
{
    if (!listners) listners = [[NSMutableDictionary alloc] init];
    [listners setObject:[NSValue valueWithPointer:cb] forKey:[NSValue valueWithPointer:listner]];
}



void KAFAddBody(void *body, KAFCallback cb)
{
    if (!bodys) bodys = [[NSMutableDictionary alloc] init];
    [bodys setObject:[NSValue valueWithPointer:cb] forKey:[NSValue valueWithPointer:body]];
    UIView *_body =(__bridge UIView *)body;
    area = CGRectMerge(area, _body.frame);
    addObserver();
}



void KAFSetFooter(void *footer)
{
    _footer = (__bridge UIView *)footer;
    area = CGRectMerge(area, _footer.frame);
    addObserver();
}



void KAFReboundSubFooter(void *subFooter, f64 subFooterEndHeight)
{
    // subFooterがあればそのframeから、無ければfooterのframe.h:0からEndHeightへアニメーション
    CGRect frame = _subFooter.frame;
    if (!_subFooter) {
        frame = _footer.frame;
        frame.size.height = 0;
    }
    
    _subFooter.hidden = YES;
    _subFooter = (__bridge UIView *)subFooter;
    _subFooter.hidden = NO;
    _subFooter.frame = frame;

    _subFooterEndHeight = subFooterEndHeight;
    [_subFooter.superview bringSubviewToFront:_subFooter];
    animate(KAF_EVENT_NON);
}



void KAFShrinkSubFooter(void *subFooter)
{
    _subFooter = (__bridge UIView *)subFooter;
    _subFooterEndHeight = 0;
    [_footer.superview bringSubviewToFront:_footer];
    animate(KAF_EVENT_NON);
}



void *OSColorFromHSBA(f64_4 hsba)
{
    static UIColor *color = nil;
    color = [UIColor colorWithHue:hsba.hsb_h saturation:hsba.hsb_s brightness:hsba.hsb_b alpha:hsba.hsb_a];
    return (__bridge void *)color;
}



@end












