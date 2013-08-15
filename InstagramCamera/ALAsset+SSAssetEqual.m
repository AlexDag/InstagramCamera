//
//  ALAsset+SSAssetEqual.m
//  SmartStuffSwap
//
//  Created by Alex on 6/27/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "ALAsset+SSAssetEqual.h"

@implementation ALAsset (SSAssetEqual)


- (BOOL)isEqual:(id)obj {
   if(![obj isKindOfClass:[ALAsset class]])
        return NO;
    
    

    
    NSURL *u1 = [self valueForProperty: ALAssetPropertyAssetURL];
    NSURL *u2 = [obj valueForProperty: ALAssetPropertyAssetURL];
    
    return ([u1 isEqual:u2]);

}

@end
