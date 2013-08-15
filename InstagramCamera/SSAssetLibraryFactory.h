//
//  SSAssetLibraryFactory.h
//  SmartStuffSwap
//
//  Created by Alex on 6/24/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLoadAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define STUFFSWAP_ALBUM @"StuffSwap"

@interface SSAssetLibraryFactory : NSObject

+ (SSAssetLibraryFactory*)sharedManager;


@property(strong,nonatomic) NSMutableArray *dataArray;
@property(strong,nonatomic)  UIImage *galleryBtnImage;
@property(assign,nonatomic) BOOL forbiddenAlbumAccess;


-(void)startLoadAsset;
-(void)cancelLoadAsset;
-(void)shutdownFactory;
-(void)creaStuffSwapAlbum;
-(void)savePhotoInAlbumStuffSwap:(CGImageRef)imageRef orientation:(ALAssetOrientation)imageOrientation;
@end
