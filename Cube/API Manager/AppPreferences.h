//
//  AppPreferences.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "User.h"

@protocol AppPreferencesDelegate;

@interface AppPreferences : NSObject 
{
    id<AppPreferencesDelegate> alertDelegate;
}

@property (nonatomic,strong)    id<AppPreferencesDelegate> alertDelegate;

@property (nonatomic)           int     currentSelectedItem;

@property (nonatomic,assign)    BOOL                        isReachable;

@property(nonatomic,strong) NSString* bsackUpAudioFileName;

@property (nonatomic,assign)    BOOL                        recordNew;
@property (nonatomic,assign)    BOOL                        recordingNew;
@property (nonatomic)    int                                selectedTabBarIndex;
@property (nonatomic,assign)    BOOL                        isRecordView;
@property (nonatomic,assign)    BOOL                        fileUploading;
@property (nonatomic,strong) NSMutableArray*                importedFilesAudioDetailsArray;
@property (nonatomic, strong) User *userObj;
@property(nonatomic,strong)NSURLSessionUploadTask *uploadTask;
+(AppPreferences *) sharedAppPreferences;

-(void) showAlertViewWithTitle:(NSString *) title withMessage:(NSString *) message withCancelText:(NSString *) cancelText withOkText:(NSString *) okText withAlertTag:(int) tag;
-(void) showNoInternetMessage;

-(void) startReachabilityNotifier;
@end


@protocol AppPreferencesDelegate

@optional
-(void) appPreferencesAlertButtonWithIndex:(int) buttonIndex withAlertTag:(int) alertTag;
@end
