//
//  APIManager.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadMetaDataJob.h"
#import "NSData+AES256.h"
@interface APIManager : NSObject<NSURLSessionDelegate>
{
    NSDictionary* result;
    NSString* filnameString;
    
}

+(APIManager *) sharedManager;

@property(nonatomic,strong) NSMutableArray* inCompleteFileTransferNamesArray;
@property(nonatomic,strong) NSMutableArray* awaitingFileTransferNamesArray;
@property(nonatomic,strong) NSMutableArray* todaysFileTransferNamesArray;
@property(nonatomic,strong) NSMutableArray* failedTransferNamesArray;

@property(nonatomic,strong) NSMutableArray* deletedListArray;
@property(nonatomic,strong) NSMutableArray* transferredListArray;

@property(nonatomic)int awaitingFileTransferCount;
@property(nonatomic)int todaysFileTransferCount;
@property(nonatomic)int transferFailedCount;
@property(nonatomic)int incompleteFileTransferCount;
@property(nonatomic)bool  userSettingsOpened;
@property(nonatomic)bool  userSettingsClosed;

@property(nonatomic)NSMutableDictionary* responsesData;
@property(nonatomic,strong)NSString* taskId;

//-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString;
-(NSString*)getMacId;//get macid of current device
-(uint64_t)getFreeDiskspace;

//-(void) validateUser:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)DeviceId;

-(void) checkDeviceRegistrationMacID:(NSString*) macID;

//-(void) checkDeviceRegistrationMacIDEncr:(NSData*) macID;

-(void) authenticateUserMacID:(NSString*) macID password:(NSString*) password username:(NSString* )username;

-(void) acceptPinMacID:(NSString*) macID Pin:(NSString*)pin;

-(void) validatePinMacID:(NSString*) macID Pin:(NSString*)pin;

-(void)mobileDictationsInsertMobileStatus:(NSString* )mobilestatus OriginalFileName:(NSString*)OriginalFileName andMacID:(NSString*)macID;

-(void)mobileDataSynchronisationMobileStatus:(NSString*)mobilestatus OriginalFileName:(NSString*)OriginalFileName macID:(NSString*)macid DeleteFlag:(NSString*)DeleteFlag;

//-(void)uploadFileFilename:(NSString*)filename macID:(NSString*)macID fileSize:(NSString*)filesize;

-(void)changePinOldPin:(NSString*)oldpin NewPin:(NSString*)newpin macID:(NSString*)macID;

-(NSString*)getDateAndTimeString;

-(uint64_t)getFileSize:(NSString*)filePath;

-(BOOL)deleteFile:(NSString*)fileName;

-(void)uploadFileToServer:(NSString*)str;





@end
