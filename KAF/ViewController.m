//  TIME v2 Created by SHINYA TAKAHASHI on 2023/12/30.

#import "KAF.h"
#import "TEXT.h"
#import "CTRL.h"
#import "ViewController.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmultichar"



@implementation ViewController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    createKAFViews(self);
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*++++++++++++++++++++++++++++ test KAF +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

static void *header, *body, *footer, *subbar;



static void createKAFViews(ViewController *vc)
{
    f64_4 safeArea = KAFGetSafeArea((__bridge void *)vc.view);
    f64_4 headerFrame, bodyFrame, footerFrame;
    KAFGetRectsInFrameWithHeights(safeArea, 50, 50, &headerFrame, &bodyFrame, &footerFrame);

    header = TEXTNew(TEXTTYPE_FIELD, (__bridge void *)vc.view, headerFrame);
    TEXTSetBackgroundColor(header, COLOR_HEADER);
    TEXTSetText(header, "HEADER");
    
    body = TEXTNew(TEXTTYPE_TEXTVIEW_EDITABLE, (__bridge void *)vc.view, bodyFrame);
    TEXTSetBackgroundColor(body, COLOR_BODY);
    TEXTSetText(body, "BODY");
    
    subbar = TEXTNew(TEXTTYPE_LABEL , (__bridge void *)vc.view, footerFrame);
    TEXTSetBackgroundColor(subbar, COLOR_SUBBAR);
    TEXTSetText(subbar, "SUB BAR");
    [(__bridge UIView *)subbar setHidden:YES];
    
    footer = BARNew((__bridge void *)vc.view, footerFrame, (__bridge void *)vc, barCallback);
    [(__bridge UIView *)footer setBackgroundColor:(__bridge UIColor *)OSColorFromHSBA(COLOR_FOOTER)];
    
    KAFAddBody(body, NULL);
    KAFSetFooter(footer);
    KAFAddListner((__bridge void *)vc, kafCallback);
}



static UIView *findFirstResponder(UIView *view)
{
    if (view.isFirstResponder) {
        return view;
    }
    for (UIView *subView in view.subviews) {
        id _view = findFirstResponder(subView);
        if (_view) return _view;
    }
    return nil;
}



static void barCallback(void *delegate, i32 ID, i32 event)
{
    ViewController *vc = (__bridge ViewController *)delegate;
    switch (ID) {
        case 0:
            if (event == Event_ButtonOn_L || event == Event_ButtonOn_R) {
                [(__bridge UITextView *)body becomeFirstResponder];
            }
            else if (event == Event_ButtonOff) {
                UITextView *view = (UITextView *)findFirstResponder(vc.view);
                [view resignFirstResponder];
            }
            break;
        case 1:
            if (event == Event_ButtonOn_L || event == Event_ButtonOn_R) {
                KAFReboundSubFooter(subbar, 50);
            }
            else if (event == Event_ButtonOff) {
                KAFShrinkSubFooter(subbar);
            }
            break;
    }
}



static void kafCallback(void *listner, i32 event)
{
    switch (event) {
        case KAF_EVENT_WILL_SHOW:
            BARForceTurnOnFor(footer, 0);
            break;
        case KAF_EVENT_WILL_HIDE:
            BARForceTurnOffFor(footer, 0);
            BARForceTurnOffFor(footer, 1);
            break;
    }
}



@end



#pragma clang diagnostic pop
