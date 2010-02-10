//
//  DynamicCell.h
//  MeridianRemote
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Pathfinder Development. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DynamicCell : UITableViewCell {
    // Properties
    float paddingTop;
    float paddingBottom;
    float paddingLeft;
    float paddingRight;
    float verticalSpacing;
    float horizontalSpacing;
    UIColor *defaultTextColor;
    UIFont *defaultFont;

    // Internals
    NSMutableSet *unusedSubviews;
    float height;
    CGRect lastFrame;
    UIView *lastView;
}

// Properties
@property (nonatomic, assign) float paddingTop;
@property (nonatomic, assign) float paddingBottom;
@property (nonatomic, assign) float paddingLeft;
@property (nonatomic, assign) float paddingRight;
@property (nonatomic, assign) float verticalSpacing;
@property (nonatomic, assign) float horizontalSpacing;
@property (nonatomic, retain) UIColor *defaultTextColor;
@property (nonatomic, retain) UIFont *defaultFont;

// Internals
@property (nonatomic, retain) NSMutableSet *unusedSubviews;

- (void) reset;
- (float) height;
- (void) setPadding:(float)padding;

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

@end
