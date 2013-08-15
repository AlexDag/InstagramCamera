//
//  SSLoadAsset.h
//  
//
//  Created by Alex on 6/23/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SSLoadAsset : NSOperation
- (id)initWithData:(ALAssetsLibrary *)library data:(NSMutableArray*)data ;
@end
