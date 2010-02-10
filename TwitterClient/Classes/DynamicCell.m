//
//  DynamicCell.m
//  MeridianRemote
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Pathfinder Development. All rights reserved.
//

#import "DynamicCell.h"
#import "NSSet+Core.h"


@implementation DynamicCell

@synthesize unusedSubviews;
@synthesize paddingTop, paddingBottom, paddingLeft, paddingRight;
@synthesize verticalSpacing, horizontalSpacing;
@synthesize defaultFont, defaultTextColor;

- (void) reset {
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
        [unusedSubviews addObject:subview];
    }
    
    [self setPadding:10.0];
    verticalSpacing = horizontalSpacing = 5.0;
    
    height = 0;
    lastView = nil;
}

- (float) height {
    return height + paddingTop + paddingBottom;
}

- (void) setPadding:(float)padding {
    paddingTop = paddingBottom = paddingLeft = paddingRight = padding;
}



#pragma mark -
#pragma mark Generic Subviews

- (void) addSubview:(UIView *)view onNewLine:(BOOL)newLine {

    // Determine origin based on where the previous view is and whether the label is on a newline
    CGPoint origin = lastView == nil ? CGPointMake(paddingLeft, paddingTop) : 
        (newLine ? 
            CGPointMake(paddingLeft, lastFrame.origin.y + lastFrame.size.height + verticalSpacing) :
            CGPointMake(lastFrame.origin.x + lastFrame.size.width + horizontalSpacing, lastFrame.origin.y));
    
    CGSize constrainedSize = CGSizeMake(self.bounds.size.width - origin.x, NSIntegerMax);
    CGSize fittedSize = CGSizeZero;
    
    if ([view isKindOfClass:[UITextView class]]) {
        fittedSize = [((UITextView*)view).text sizeWithFont:((UITextView*)view).font constrainedToSize:constrainedSize];
        fittedSize.height += 20.0;
    }
    else
        fittedSize = [view sizeThatFits:constrainedSize];
        
    view.frame = CGRectMake(origin.x, origin.y, fittedSize.width, fittedSize.height);
    
    [self addSubview:view];

    // Increment computed cell height if this is a newline or if this new label is taller than the previous element
    if (newLine) {
        height += fittedSize.height;
        if (lastView != nil)
            height += verticalSpacing;
    }
    else {
        float additionalHeight = view.frame.size.height - lastFrame.size.height;
        if (additionalHeight > 0)
            height += additionalHeight;
    }
    
    lastView = view;
    lastFrame = view.frame;
}



#pragma mark -
#pragma mark Labels

- (UIFont*) defaultFont {
    if (defaultFont == nil)
        self.defaultFont = [UIFont systemFontOfSize:17.0];
    return defaultFont;
}

- (UIColor*) defaultTextColor {
    if (defaultTextColor == nil)
        self.defaultTextColor = [UIColor blackColor];
    return defaultTextColor;
}

- (UILabel*) addLabelWithText:(NSString*)text andFont:(UIFont*)font onNewLine:(BOOL)newLine {
    if (text == nil)
        text = @"";

    UILabel* label = [unusedSubviews objectOfClass:[UILabel class]];
    if (label != nil)
        [unusedSubviews removeObject:label];
    else {
        label = [[UILabel alloc] init];
        label.lineBreakMode = UILineBreakModeWordWrap;
    }

    label.font = font;
    label.text = text;
    label.textColor = [self defaultTextColor];
    
    // Determine number of newlines in string
    NSString *countString = @"";
    NSScanner *scanner = [NSScanner scannerWithString:text];
    [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&countString];
    label.numberOfLines = [countString length];
    
    [self addSubview:label onNewLine:newLine];
    return label;
}

- (UILabel*) addLabelWithText:(NSString*)text {
    return [self addLabelWithText:text andFont:[self defaultFont] onNewLine:YES];
}

- (UILabel*) addLabelWithText:(NSString*)text onNewLine:(BOOL)newLine {
    return [self addLabelWithText:text andFont:[self defaultFont] onNewLine:newLine];
}

- (UILabel*) addLabelWithText:(NSString*)text andFont:(UIFont*)font {
    return [self addLabelWithText:text andFont:font onNewLine:YES];
}



#pragma mark -
#pragma mark Text Views

- (UITextView*) addTextViewText:(NSString*)text andFont:(UIFont*)font onNewLine:(BOOL)newLine {
    UITextView* textView = [unusedSubviews objectOfClass:[UITextView class]];
    if (textView != nil)
        [unusedSubviews removeObject:textView];
    else {
        textView = [[UITextView alloc] init];
        textView.scrollEnabled = NO;
        textView.editable = NO;
    }
    
    textView.font = font;
    textView.text = text != nil ? text : @"";
    textView.textColor = [self defaultTextColor];
        
    [self addSubview:textView onNewLine:newLine];
    return textView;
}

- (UITextView*) addTextViewWithText:(NSString*)text {
    return [self addTextViewText:text andFont:[self defaultFont] onNewLine:YES];
}

- (UITextView*) addTextViewText:(NSString*)text onNewLine:(BOOL)newLine {
    return [self addTextViewText:text andFont:[self defaultFont] onNewLine:newLine];
}

- (UITextView*) addTextViewText:(NSString*)text andFont:(UIFont*)font {
    return [self addTextViewText:text andFont:font onNewLine:YES];
}


#pragma mark -
#pragma mark Images

- (UIImageView*) addImage:(UIImage*)image {
    return [self addImage:image onNewLine:YES];
}

- (UIImageView*) addImage:(UIImage*)image onNewLine:(BOOL)newLine {
    UIImageView* imageView = [unusedSubviews objectOfClass:[UIImageView class]];
    if (imageView != nil)
        [unusedSubviews removeObject:imageView];
    else
        imageView = [[UIImageView alloc] init];
        
    imageView.image = image;
    
    [self addSubview:imageView onNewLine:newLine];
    return imageView;
}





- (void)dealloc {
    [defaultTextColor release];
    [defaultFont release];
    [super dealloc];
}


@end
