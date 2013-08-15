//
//  SSUtils.m
//  SmartStuffSwap
//
//  Created by Alex on 6/29/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "SSUtils.h"

@implementation SSUtils{
 }
static  BOOL albumForbiddenAccess;

+(BOOL)getForbiddenAlbumAccess{
    return albumForbiddenAccess;
}
+(void)setForbiddenAlbumAccess:(BOOL)value{
    albumForbiddenAccess=value;
}

+(void)setCenterObjectForParent:(UIView*)parent object:(UIView*)object size:(int)size onlyVertical:(BOOL)onlyvertical{
    CGRect rect = object.frame;
    rect.size = CGSizeMake(size, size);
    rect.origin.y =  parent.frame.size.height/2-  rect.size.height/2 ;
    if(!onlyvertical)
        rect.origin.x =  parent.frame.size.width/2-  rect.size.width/2 ;
    
    object.frame=rect;
}


   // for one parent level only 
+(CGFloat)getGlobalCoordinatActiveField:(UIView*)activeField self_:(UIView*)self_  scroll:(UIScrollView*)scrollView{
    int delta = 0;
    CGFloat  y = scrollView.frame.origin.y;
    if( activeField.superview != self_ ){
        y+= activeField.superview.frame.origin.y;
    }
    
    y+= activeField.frame.origin.y +  activeField.frame.size.height + delta;
    return y;
}

/*
+(void)showmessageAlbumDeniedAccess{
    NSString *msg =@"Приложение не имеет доступа к Фотоальбомам этого телефона.\n Пожалуйста, дайте доступ через:\n Setting-Privacy- Photos-StuffSwap" ;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Внимание!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
*/
+(void)showAlertMessage:(NSString*)message_{
    
    [[[UIAlertView alloc]initWithTitle:@"Внимание!" message:message_ delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show ];
    
    
}



@end
