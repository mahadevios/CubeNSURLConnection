//
//  AppDelegate.h
//  Cube
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) MBProgressHUD *hud;
@property(nonatomic)BOOL gotResponse;

@end

