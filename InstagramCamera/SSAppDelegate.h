//
//  SSAppDelegate.h
//  SmartStuffSwap
//
//  Created by Alex on 6/7/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUtils.h"

@interface SSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
