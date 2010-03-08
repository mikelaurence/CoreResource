//
//  DynamicCell.h
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Pathfinder Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell {
    // Layout attributes
    NSArray *columnPositions;
    NSArray *rowPositions;
    float rowSpacing;
    float columnSpacing;
    BOOL maximizeWidth;

    // Container attributes
    float paddingTop;
    float paddingBottom;
    float paddingLeft;
    float paddingRight;
    
    // Defaults
    NSArray *defaultRowPositions;
    NSArray *defaultColumnPositions;
    float defaultRowSpacing;
    float defaultColumnSpacing;
    float defaultPadding;
    UIColor *defaultTextColor;
    UIFont *defaultFont;

    // Internals
    NSMutableSet *unusedSubviews;
    NSMutableArray *placedSubviews;
    float height;
    float rowHeight;
    int currentFloat;
    BOOL needsPreparation;
    
    // View access
    NSMutableDictionary* primaryViewsByClass;
}

// Properties
@property (nonatomic, retain) NSArray *rowPositions;
@property (nonatomic, retain) NSArray *columnPositions;
@property (nonatomic, assign) float rowSpacing;
@property (nonatomic, assign) float columnSpacing;
@property (nonatomic, assign) BOOL maximizeWidth;

@property (nonatomic, assign) float paddingTop;
@property (nonatomic, assign) float paddingBottom;
@property (nonatomic, assign) float paddingLeft;
@property (nonatomic, assign) float paddingRight;

// Defaults
@property (nonatomic, retain) NSArray *defaultRowPositions;
@property (nonatomic, retain) NSArray *defaultColumnPositions;
@property (nonatomic, assign) float defaultRowSpacing;
@property (nonatomic, assign) float defaultColumnSpacing;
@property (nonatomic, assign) float defaultPadding;
@property (nonatomic, retain) UIColor *defaultTextColor;
@property (nonatomic, retain) UIFont *defaultFont;

+ (id) cellWithReuseIdentifier:(NSString*)reuseIdentifier;
- (id) initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void) reset;
- (void) prepare;
- (NSNumber*) height;
- (void) setPadding:(float)padding;

- (UIView*) viewOfClass:(Class)clazz;

#pragma mark -
#pragma mark Generic Views
- (UIView*) addView:(UIView*)view onNewLine:(BOOL)newLine;
- (UIView*) addViewOfClass:(Class)clazz;
- (UIView*) addViewOfClass:(Class)clazz onNewLine:(BOOL)newLine;

#pragma mark -
#pragma mark Labels
- (UILabel*) addLabelWithText:(NSString*)text;
- (UILabel*) addLabelWithText:(NSString*)text onNewLine:(BOOL)newLine;
- (UILabel*) addLabelWithText:(NSString*)text andFont:(UIFont*)font;
- (UILabel*) addLabelWithText:(NSString*)text andFont:(UIFont*)font onNewLine:(BOOL)newLine;

#pragma mark -
#pragma mark Text Views
- (UITextView*) addTextViewWithText:(NSString*)text;
- (UITextView*) addTextViewText:(NSString*)text onNewLine:(BOOL)newLine;
- (UITextView*) addTextViewText:(NSString*)text andFont:(UIFont*)font;
- (UITextView*) addTextViewText:(NSString*)text andFont:(UIFont*)font onNewLine:(BOOL)newLine;

#pragma mark -
#pragma mark Images
- (UIImageView*) addImage:(UIImage*)image;
- (UIImageView*) addImage:(UIImage*)image onNewLine:(BOOL)newLine;

#pragma mark -
#pragma mark Buttons
- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title onNewLine:(BOOL)newLine;
- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title andTarget:(id)target action:(SEL)action;
- (UIButton*) addButtonOfType:(UIButtonType)type withTitle:(NSString*)title andTarget:(id)target action:(SEL)action onNewLine:(BOOL)newLine;
- (UIButton*) buttonOfType:(UIButtonType)type;

#pragma mark -
#pragma mark External view access
- (UIButton*) button;
- (UITextField*) textField;

@end
