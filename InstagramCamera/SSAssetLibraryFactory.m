//
//  SSAssetLibraryFactory.m
//  SmartStuffSwap
//
//  Created by Alex on 6/24/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "SSAssetLibraryFactory.h"
#import "SSUtils.h"
@implementation SSAssetLibraryFactory{
    
     NSOperationQueue *operation;
    
}

static SSAssetLibraryFactory *sharedLibrary = nil;
static   ALAssetsLibrary *assetLibrary ;


+ (SSAssetLibraryFactory*)sharedManager
{
    if (sharedLibrary == nil) {
        sharedLibrary = [[super allocWithZone:NULL] init];
        assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return sharedLibrary;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager] ;
}



-(void)cancelLoadAsset{
    [operation cancelAllOperations];
}

-(void)startLoadAsset{
    
     if(!_dataArray)
       _dataArray = [[NSMutableArray alloc]init];
    else
       [_dataArray removeAllObjects];
  
    
    if(!operation)
       operation =[[NSOperationQueue alloc]init];
  
 
    SSLoadAsset  *loaderAsset= [[SSLoadAsset alloc]initWithData:assetLibrary data:_dataArray ];
    
    
    [operation addOperation:loaderAsset];
    
    
}
#pragma mark - Notification Listener

-(void)insertAssetLibraryLoadedByURl:(NSURL*)url{
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        NSLog(@"  %@",asset);
         [_dataArray addObject:asset];
        
    } failureBlock:^(NSError *error) {
        NSLog(@" error %@",error);
    }];

}



- (void)assetsLibraryDidChange:(NSNotification *)note{
    
    NSDictionary* info = [note userInfo];
    NSLog(@"assetsLibraryDidChange calling syncPhotoInfoFromAssets, userInfo %@", info);
    
    
     [_dataArray removeAllObjects];
    

    
    for (NSString *obj in info.keyEnumerator ) {
        
        NSLog(@" %@",obj);
        
        if (  [obj isEqualToString:ALAssetLibraryUpdatedAssetsKey] ) {
            [self insertAssetLibraryLoadedByURl:[info valueForKey:ALAssetLibraryUpdatedAssetsKey]];
        }
        
       

    }
    
    
}


-(void)shutdownFactory{
  //  [_dataArray removeAllObjects];
   // _dataArray = nil;
}

-(void)creaStuffSwapAlbum{
    [assetLibrary addAssetsGroupAlbumWithName:STUFFSWAP_ALBUM resultBlock:^(ALAssetsGroup *group) {
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error create StuffSwap album  %@",error);
    }];
}





-(void)savePhotoInAlbumStuffSwap:(CGImageRef)imageRef orientation:(ALAssetOrientation)imageOrientation {
   
    [assetLibrary writeImageToSavedPhotosAlbum:imageRef orientation:imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
       
        if([error.domain isEqualToString:ALAssetsLibraryErrorDomain]&&
            error.code==ALAssetsLibraryAccessUserDeniedError){
            
            [self performSelector:@selector(showmessageAlbumDeniedAccess) withObject:nil afterDelay:0.9];
            return;
        }
        [self _addAssetURL:assetURL failure:^(NSError *error) {
            NSLog(@"  addAsset : %@  ",error);
        }];
    
    
            
        
    }];
       

    
}


-(void)_addAssetURL:(NSURL *)assetURL  failure:(ALAssetsLibraryAccessFailureBlock)failure{

    __block BOOL albumWasFound = NO;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock enumerationBlock;
    enumerationBlock = ^(ALAssetsGroup *group, BOOL *stop) {
                
        if ([STUFFSWAP_ALBUM compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
            albumWasFound = YES;
            // target album is found
            [self _addAssetToURL:assetURL group:group];
            return;
        }
        
    if (group == nil && albumWasFound == NO) {
       
        
        // if iOS version is lower than 5.0, throw a warning message
        if (! [assetLibrary respondsToSelector:@selector(addAssetsGroupAlbumWithName:resultBlock:failureBlock:)])
            NSLog(@"![WARNING][LIB:ALAssetsLibrary+CustomPhotoAlbum]: \
                  |-addAssetsGroupAlbumWithName:resultBlock:failureBlock:| \
                  only available on iOS 5.0 or later. \
                  ASSET cannot be saved to album!");
        // create new assets album
        else [assetLibrary addAssetsGroupAlbumWithName:STUFFSWAP_ALBUM
                                   resultBlock:^(ALAssetsGroup *group) {
                                       // get the photo's instance
                                       [assetLibrary assetForURL:assetURL
                                                 resultBlock:^(ALAsset *asset) {
                                                     // add photo to the newly created album
                                                     [group addAsset:asset];
                                                 }
                                                failureBlock:failure];
                                   }
                                  failureBlock:failure];
        
        // should be the last iteration anyway, but just in case
        return;
    }
            
    };
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:enumerationBlock failureBlock:^(NSError *error) {
        
        
        NSLog(@"  enumaration error:%@",error);
    }];
}

-(void)_addAssetToURL:(NSURL*)url group:(ALAssetsGroup*)group {
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        [group addAsset:asset];
        // NSLog(@"   #asset saved");
    } failureBlock:^(NSError *error) {
        NSLog(@"   error add photo to library:%@",error);
    }];
}







/*
 
 //  __block ALAssetsGroup* groupToAddTo;
 [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum
 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
 
 NSString *groupname = [group valueForProperty:ALAssetsGroupPropertyName];
 NSLog(@"name %@  group:%@",groupname,group);
 
 if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:STUFFSWAP_ALBUM]) {
 [self _addAs];
 
 }
 }
 failureBlock:^(NSError* error) {
 NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
 }];
 

 
 */



-(void)showmessageAlbumDeniedAccess{
    NSString *msg =@"Приложение не имеет доступа к Фотоальбомам этого телефона.\n Пожалуйста, дайте доступ через:\n Setting-Privacy- Photos-StuffSwap" ;
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
    [alert show];
    
}


@end
