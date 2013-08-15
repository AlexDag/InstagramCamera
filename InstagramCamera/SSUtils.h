//
//  SSUtils.h
//  SmartStuffSwap
//
//  Created by Alex on 6/29/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_5 (!IS_IPAD && IS_WIDESCREEN)
*/

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)

#define kIPHONE5_HEIGHT ((int)568)
#define kIPHONE_HEIGHT ((int)480)
#define kIPHONE_ADJUST_HEIGHT (kIPHONE5_HEIGHT-kIPHONE_HEIGHT)

//#define kAlbumForbiddenAccess

@interface SSUtils : NSObject

+(void)setCenterObjectForParent:(UIView*)parent object:(UIView*)object size:(int)size onlyVertical:(BOOL)onlyvertical;
//+(void)showmessageAlbumDeniedAccess;
+(void)showAlertMessage:(NSString*)message_;

+(BOOL)getForbiddenAlbumAccess;
+(void)setForbiddenAlbumAccess:(BOOL)value;

//+(CGFloat)getGlobalCoordinatActiveField:(UIView*)activeField self_:(UIView*)self_  scroll:(UIScrollView*)scrollView;
//+(void)textFieldDidBeginEditing:(UITextField *)textField;

@end
