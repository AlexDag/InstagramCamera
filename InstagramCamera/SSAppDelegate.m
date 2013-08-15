//
//  SSAppDelegate.m
//  SmartStuffSwap
//
//  Created by Alex on 6/7/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSAssetLibraryFactory.h"
#import "SSUtils.h"




@implementation SSAppDelegate{
    
    SSAssetLibraryFactory *assetFactory;
}





void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"Call Stack: %@", exception.callStackSymbols);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        
   
    
    
   return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   [[SSAssetLibraryFactory sharedManager]startLoadAsset];
    

    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    
    
}



#pragma mark - Core Data stack



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
