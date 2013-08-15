//
//  SSLoadAsset.m
//  
//
//  Created by Alex on 6/23/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "SSLoadAsset.h"
#import "SSUtils.h"
@implementation SSLoadAsset{
    ALAssetsLibrary *assetLibrary;
    NSMutableArray *dataArray;
   
   }


- (id)initWithData:(ALAssetsLibrary *)library data:(NSMutableArray*)data 
{
    self = [super init];
    if (self != nil)
    {
        assetLibrary = library;
        dataArray = data;
        [SSUtils setForbiddenAlbumAccess:FALSE];
        
        
           }
    return self;
}


- (void)main{
    [self readGAllery2];
}





-(void)readGAllery2{
    
      
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *needToStop) {
            if ( !self.isCancelled && result!=nil) {
                
#if TestOut==1
                NSLog(@"%d",index);
#endif
                if(!self.isCancelled)
                   [dataArray addObject:result];
            }else
            {
#if TestOut==1
                NSLog(@" load asset stoped");
#endif
                *needToStop = YES;
               
                    }
            
        }];
    }
     
                              failureBlock:^(NSError *error) {
                                  if( [error.domain isEqualToString:ALAssetsLibraryErrorDomain] &&
                                       error.code==ALAssetsLibraryAccessUserDeniedError){
                                      
                                      [SSUtils setForbiddenAlbumAccess:TRUE];
                                      
                                      /*  [[NSNotificationCenter defaultCenter] postNotificationName:
                                       @"GotInformationsNotification" object:nil];*/

                                      
#if TestOUT==1
                                      NSLog(@"  Album forbidden Access");
#endif
                                  }
                                  
                                  
                                
                                                               }];
    
}


/*

-(void)readGAllery3{
    
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *needToStop) {
            
            if ( !self.isCancelled && result!=nil) {
                
                NSLog(@"%d",index);
                
                if(!self.isCancelled)
                    [dataArray addObject:result];
                      
            }else
            {
                // NSLog(@"  stoped");
                *needToStop = YES;
                
            }
            
        }];
    }
     
                              failureBlock:^(NSError *error) {
                                 // NSLog(@" enumerateAssetsWithOptions %@",error  );
                              }];
    
}
*/



@end
