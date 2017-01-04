//
//  ShareViewController.h
//  Copy to Cube
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ShareViewController : SLComposeServiceViewController<NSURLSessionDelegate,NSURLSessionDataDelegate>

{
    NSDictionary* result;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
    //bool isFileAvailable;
    NSURLSession *mySession;
    NSURL *url;
    NSString* fileNameForViewString;
    UILabel* fileNameLabel;
    
}
@property(nonatomic,strong)NSString* audioFilePathString;
@property(nonatomic,strong)NSString* fileName;
@property(nonatomic)BOOL isFileAvailable;
@end
