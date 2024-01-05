//  TEXT.m Created by SHINYA TAKAHASHI on 2023/10/22.

#import <UIKit/UIKit.h>
#import "KAF.h"
#import "TEXT.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmultichar"


@interface TEXT : UITextView
@end



@implementation TEXT



static f64_2 getBoundingSize(f64 width, char *str, f64 lineSpacing, char *fontName, f64 fontSize)
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *att = @{
        NSFontAttributeName : [UIFont fontWithName:[NSString stringWithUTF8String:fontName] size:fontSize],
        NSParagraphStyleAttributeName : paragraphStyle
    };
    
    NSString *s = [NSString stringWithUTF8String:str];
    
    CGRect rect = [s boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:att
                                  context:nil];
    
    return (f64_2){ceil(rect.size.width), ceil(rect.size.height)};
}



static void setAlignmentVerticalCenter(UITextView *view, char *fontName)
{
    if (view) {
        f64_2 size = getBoundingSize(view.bounds.size.width, (char *)[view.text UTF8String], 0, fontName, view.font.pointSize);
        f64 topInset = (view.bounds.size.height - size.h * view.zoomScale) / 2;
        topInset = topInset < 0.0 ? 0.0 : topInset;
        UIEdgeInsets insets = UIEdgeInsetsMake(topInset, view.contentInset.left, view.contentInset.bottom, view.contentInset.right);
        [view setTextContainerInset:insets];
    }
}


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++ interface +++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

void *TEXTNew(i32 type, void *parent, f64_4 frame)
{
    TEXT *view = [[TEXT alloc] initWithFrame:CGRectMake(frame.x, frame.y, frame.w, frame.h)];
    view.userInteractionEnabled = NO;
    view.scrollEnabled = NO;
    view.clipsToBounds = YES;
    
    if (type == TEXTTYPE_FIELD || type == TEXTTYPE_TEXTVIEW_EDITABLE) {
        view.userInteractionEnabled = YES;
        view.editable = YES;
    }
    
    if (type == TEXTTYPE_TEXTVIEW_EDITABLE) {
        view.scrollEnabled = YES;
    }
    
    view.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    view.textColor = (__bridge UIColor *)OSColorFromHSBA(COLOR_FONT);
    view.showsVerticalScrollIndicator = NO;
    view.alwaysBounceVertical = NO;
    view.delaysContentTouches = NO;
    view.autocapitalizationType = UITextAutocapitalizationTypeNone;
    view.autocorrectionType = UITextAutocorrectionTypeNo;
    view.smartDashesType = UITextSmartDashesTypeNo;
    view.smartQuotesType = UITextSmartQuotesTypeNo;
    view.spellCheckingType = UITextSpellCheckingTypeNo;
    
    if (type == TEXTTYPE_FIELD || type == TEXTTYPE_LABEL) {
        view.textAlignment = NSTextAlignmentCenter;
        setAlignmentVerticalCenter(view, "HelveticaNeue");
    }
    
    [(__bridge UIView *)parent addSubview:view];
    return (__bridge void *)view;
}



void TEXTSetText(void *textView, char *text)
{
    if (textView && text) {
        TEXT *view = (__bridge TEXT *)textView;
        view.text = [NSString stringWithUTF8String:text];
    }
}



void TEXTSetBackgroundColor(void *textView, f64_4 color)
{
    if (textView) {
        TEXT *view = (__bridge TEXT *)textView;
        view.backgroundColor = [UIColor colorWithHue:color.hsb_h saturation:color.hsb_s brightness:color.hsb_b alpha:color.hsb_a];
    }
}



char *TEXTGetText(void *textView)
{
    TEXT *view = (__bridge TEXT *)textView;
    char *s = (char *)[view.text UTF8String];
    return s;
}



@end



#pragma clang diagnostic pop
