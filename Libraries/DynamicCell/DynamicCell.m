//
//  DynamicCell.m
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Pathfinder Development. All rights reserved.
//

#import "DynamicCell.h"
#import "NSSet+Core.h"


@implementation DynamicCell

@synthesize rowPositions, columnPositions, rowSpacing, columnSpacing, maximizeWidth;
@synthesize paddingTop, paddingBottom, paddingLeft, paddingRight;
@synthesize defaultRowPositions, defaultColumnPositions, defaultRowSpacing, defaultColumnSpacing, defaultPadding;
@synthesize defaultFont, defaultTextColor;

+ (id) cellWithReuseIdentifier:(NSString*)reuseIdentifier {
    return [[[self alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
}

- (id) initWithReuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        placedSubviews = [[NSMutableArray array] retain];
        unusedSubviews = [[NSMutableSet set] retain];
        primaryViewsByClass = [[NSMutableDictionary dictionary] retain];
        
        // Default values for "default" attributes
        defaultPadding = 10.0;
        defaultRowSpacing = defaultColumnSpacing = defaultPadding * 0.5;
        self.defaultFont = [UIFont systemFontOfSize:17.0];
        self.defaultTextColor = [UIColor blackColor];
        
        maximizeWidth = NO;
    }
    return self;
}


/**
    Clear out subviews, return layout attributes to defaults, and reset internal tracking bits
*/
- (void) reset {
    for (NSArray *row in placedSubviews) {
        for (UIView *subview in row) {
            [unusedSubviews addObject:subview];
            [subview removeFromSuperview];
            subview.bounds = CGRectZero;
        }
    }
    [placedSubviews removeAllObjects];
    [primaryViewsByClass removeAllObjects];

    self.rowPositions = defaultRowPositions;
    self.columnPositions = defaultColumnPositions;
    rowSpacing = defaultRowSpacing;
    columnSpacing = defaultColumnSpacing;
    [self setPadding:defaultPadding];

    needsPreparation = YES;
}

- (NSNumber*) height {
    if (needsPreparation)
        [self prepare];
    return [NSNumber numberWithFloat:height];
}

- (void) setPadding:(float)padding {
    paddingTop = paddingBottom = paddingLeft = paddingRight = padding;
}


/**
    Returns an existing view from unusedSubviews, if available;
    otherwise, creates a new view of the given class
*/
- (UIView*) viewOfClass:(Class)clazz {
    UIView* view = [[unusedSubviews objectOfClass:clazz] retain];
    if (view != nil)
        [unusedSubviews removeObject:view];
    else
        view = [[clazz alloc] init];
    return [view autorelease];
}



#pragma mark -
#pragma mark Generic Subviews

- (UIView*) addView:(UIView*)view onNewLine:(BOOL)newLine {
    // Create new row array if on a newline
    if ([placedSubviews count] == 0 || newLine)
        [placedSubviews addObject:[NSMutableArray array]];
        
    // Add view to placed subviews list
    [[placedSubviews lastObject] addObject:view];
    
    // Set accessible view property depending on view type (if one hasn't already been set)
    Class clazz = [view class];
    if ([view isKindOfClass:[UIButton class]]) clazz = [UIButton class]; // Consider all descendants of UIButton the same
    id primaryView = [primaryViewsByClass objectForKey:clazz];
    if (primaryView == nil)
        [primaryViewsByClass setObject:view forKey:clazz];
    
    return view;
}

- (UIView*) addViewOfClass:(Class)clazz {
    return [self addView:[self viewOfClass:clazz] onNewLine:YES];
}

- (UIView*) addViewOfClass:(Class)clazz onNewLine:(BOOL)newLine {
    return [self addView:[self viewOfClass:clazz] onNewLine:newLine];
}

- (void) prepare {
    // Prepare for row iterations
    height = paddingTop;
    CGRect lastRowExtents = CGRectNull;

    // Iterate through rows
    for (int rowIndex = 0; rowIndex < [placedSubviews count]; rowIndex++) {
        NSArray *row = [placedSubviews objectAtIndex:rowIndex];
    
        // Prepare for column iterations
        CGRect lastFrame = CGRectNull;
        CGRect extents = CGRectNull;

        // Determine base row attributes
        float rowOrigin = rowPositions != nil && rowIndex < [rowPositions count] ?
            [[rowPositions objectAtIndex:rowIndex] floatValue] : 
            rowIndex > 0 ?
                lastRowExtents.origin.y + lastRowExtents.size.height + rowSpacing :
                paddingTop;
        float maxRowHeight = rowPositions != nil && (rowIndex + 1) < [rowPositions count] ?
            [[rowPositions objectAtIndex:rowIndex + 1] floatValue] - rowOrigin : 
            NSIntegerMax;
    
        // Initial iteration through row
        for (int viewIndex = 0; viewIndex < [row count]; viewIndex++) {
            UIView *view = [row objectAtIndex:viewIndex];

            // Determine origin based on whether or not this is a new row and where the previous view is
            float originX = (columnPositions != nil && viewIndex < [columnPositions count]) ?
                [[columnPositions objectAtIndex:viewIndex] floatValue] :
                viewIndex == 0 ? 
                    paddingLeft : 
                    lastFrame.origin.x + lastFrame.size.width + columnSpacing;
            
            // Calculate bounds width (generally remaining width of cell minus any accessory view)
            float boundsWidth = self.bounds.size.width;
            if (self.accessoryView != nil)
                boundsWidth -= self.accessoryView.bounds.size.width - columnSpacing;
            if (self.accessoryType != UITableViewCellAccessoryNone)
                boundsWidth -= 20.0 - columnSpacing;
            
            // Calculate size to constrain element to
            float maxWidth = (columnPositions != nil && (viewIndex + 1) < [columnPositions count] ?
                [[columnPositions objectAtIndex:viewIndex + 1] floatValue] : 
                boundsWidth) - 
                originX - (viewIndex < [columnPositions count] - 1 ? columnSpacing : 0);
            CGSize constrainedSize = CGSizeMake(maxWidth, maxRowHeight);
            
            CGSize fittedSize = view.bounds.size;
            
            if (CGSizeEqualToSize(fittedSize, CGSizeZero)) {
                if ([view isKindOfClass:[UITextView class]]) {
                    fittedSize = [((UITextView*)view).text sizeWithFont:((UITextView*)view).font constrainedToSize:constrainedSize];
                    fittedSize.height += 20.0;
                }
                else if ([view isKindOfClass:[UITextField class]])
                    fittedSize = CGSizeMake(constrainedSize.width, 31.0);
                else
                    fittedSize = [view sizeThatFits:constrainedSize];
            }
            
            // If maximize width is set, reset frame width to max width (unless this is an image)
            if (maximizeWidth && ![view isKindOfClass:[UIImageView class]])
                fittedSize.width = maxWidth;

            view.frame = lastFrame = CGRectMake(originX, rowOrigin, fittedSize.width, fittedSize.height);
            [self.contentView addSubview:view];
            
            // Set or intersect the view's frame to build the extents for this row
            if (CGRectIsNull(extents))
                extents = [view frame];
            else
                extents = CGRectUnion(extents, [view frame]);
        }
        
        // Vertical placement iteration
        for (int viewIndex = 0; viewIndex < [row count]; viewIndex++) {
            UIView *view = [row objectAtIndex:viewIndex];

            float yOffset = 0;
    
            // "Middle" placement
            if (TRUE)
                yOffset = (extents.size.height - view.bounds.size.height) * 0.5;
            
            view.center = CGPointMake(view.center.x, view.center.y + yOffset);
        }
        
        lastRowExtents = extents;
    }

    height = lastRowExtents.origin.y + lastRowExtents.size.height + paddingBottom;       
    needsPreparation = NO;
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

    UILabel* label = (UILabel*) [self viewOfClass:[UILabel class]];

    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = font;
    label.text = text;
    label.textColor = [self defaultTextColor];
    label.backgroundColor = [UIColor clearColor];
    
    // Determine number of newlines in string
    NSString *countString = @"";
    NSScanner *scanner = [NSScanner scannerWithString:text];
    [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&countString];
    label.numberOfLines = [countString length];
    
    return (UILabel*) [self addView:label onNewLine:newLine];
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

    UITextView* textView = (UITextView*) [self viewOfClass:[UITextView class]];
    
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.font = font;
    textView.text = text != nil ? text : @"";
    textView.textColor = [self defaultTextColor];
        
    return (UITextView*) [self addView:textView onNewLine:newLine];
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
    
    UIImageView* imageView = (UIImageView*) [self viewOfClass:[UIImageView class]];
    imageView.image = image;
    
    return (UIImageView*) [self addView:imageView onNewLine:newLine];
}



#pragma mark -
#pragma mark Buttons

- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title onNewLine:(BOOL)newLine {    
    UIButton* button = [self buttonOfType:type];
    [button setTitle:title forState:UIControlStateNormal];
    
    return (UIButton*) [self addView:button onNewLine:newLine];
}

- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title andTarget:(id)target action:(SEL)action {
    return [self addButtonOfType:type withTitle:title andTarget:target action:action onNewLine:YES];
}

- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title andTarget:(id)target action:(SEL)action onNewLine:(BOOL)newLine {
    UIButton* button = [self addButtonOfType:type withTitle:title onNewLine:newLine];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton*) buttonOfType:(UIButtonType)type {
    for (UIView* view in unusedSubviews) {
        if ([view isKindOfClass:[UIButton class]] && ((UIButton*)view).buttonType == type)
            return (UIButton*) view;
    }
    return [UIButton buttonWithType:type];
}




#pragma mark -
#pragma mark External view

- (UIButton*) button {
    return [primaryViewsByClass objectForKey:[UIButton class]];
}

- (UITextField*) textField {
    return [primaryViewsByClass objectForKey:[UITextField class]];
}


#pragma mark -
#pragma mark Lifecycle End

- (void)dealloc {
    [placedSubviews release];
    [primaryViewsByClass release];
    [unusedSubviews release];
    [defaultTextColor release];
    [defaultFont release];
    [super dealloc];
}


@end
