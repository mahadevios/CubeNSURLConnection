//
//  AppDelegate.m
//  Cube
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "PinRegistrationViewController.h"
#import "UIDevice+Identifier.h"
#import "SplashScreenViewController.h"
#import "AudioSessionManager.h"
#import "CAXException.h"
#import <AVFoundation/AVFoundation.h>


extern void ThreadStateInitalize();
extern void ThreadStateBeginInterruption();
extern void ThreadStateEndInterruption();
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize hud,window,gotResponse;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[AppPreferences sharedAppPreferences] startReachabilityNotifier];
    [APIManager sharedManager].userSettingsOpened=NO;
    //[[Database shareddatabase] updateDemo:@"MOB-495617757209"];

    //[Keychain setString:macId forKey:@"udid"];

       [self checkAndCopyDatabase];
  //  [[NSUserDefaults standardUserDefaults] setValue:timeLabel.text forKey:LOW_STORAGE_THRESHOLD];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:LOW_STORAGE_THRESHOLD]== NULL)
    {
          [[NSUserDefaults standardUserDefaults] setValue:@"512 MB" forKey:LOW_STORAGE_THRESHOLD];

    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:RECORD_ABBREVIATION]== NULL)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"MOB-" forKey:RECORD_ABBREVIATION];
        
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:SAVE_DICTATION_WAITING_SETTING]== NULL)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"15 min" forKey:SAVE_DICTATION_WAITING_SETTING];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoadedFirstTime"];

   // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOW_STORAGE_THRESHOLD]);
   // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:RECORD_ABBREVIATION]);


   // [[NSUserDefaults standardUserDefaults] setValue:@"MOB" forKey:RECORD_ABBREVIATION];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    ThreadStateInitalize();
    
    try {
        NSError *error = nil;
        
        // Configure the audio session
        AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
        
        // our default category -- we change this for conversion and playback appropriately
        [sessionInstance setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
        XThrowIfError(error.code, "couldn't set audio category");
        
        // add interruption handler
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:sessionInstance];
        
        // we don't do anything special in the route change notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRouteChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:sessionInstance];
        
        // the session must be active for offline conversion
        [sessionInstance setActive:YES error:&error];
        XThrowIfError(error.code, "couldn't set audio session active\n");
        
    } catch (CAXException e) {
        char buf[256];
        fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
        printf("You probably want to fix this before continuing!");
    }

    
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [application registerForRemoteNotifications];
//    }
//    else
//    {
//        // iOS < 8 Notifications
//        [application registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//    }
       return YES;
}


- (void) checkAndCopyDatabase
{
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cube_DB.sqlite"];
   // NSString *sourcepath=[[NSBundle mainBundle]pathForResource:@"Cube_DB" ofType:@"sqlite"];
    NSString *sourcepath=[[NSBundle mainBundle]pathForResource:@"Cube_DB" ofType:@"sqlite"];

    if(![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
    //  NSLog(@"%@",NSHomeDirectory());
      [[NSFileManager defaultManager] copyItemAtPath:sourcepath toPath:destpath error:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{

//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_RECORDING object:nil];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_AUDIO_PALYER object:nil];//to pause and remove audio player

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_RECORDING object:nil];//to pause audio player and save the recording from bg.we have change the setting for this in app capabilities setting to stop from the bg.


    if([AppPreferences sharedAppPreferences].userObj!=nil)
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoadedFirstTime"];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_RECORDING object:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"] && [AppPreferences sharedAppPreferences].userObj.userPin!=NULL)
    {
        LoginViewController* loginViewController=[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.window.rootViewController presentViewController:loginViewController animated:NO completion:nil];
    }
//    else
//    {
//            SplashScreenViewController *viewController = (SplashScreenViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
//            [self.window makeKeyAndVisible];
//        
//            [self.window.rootViewController presentViewController:viewController
//                                                         animated:NO
//                                                       completion:nil];
//
//    }

   


    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoadedFirstTime"];
    [AppPreferences sharedAppPreferences].userObj.userPin=nil;
    
    [[Database shareddatabase] updateUploadingFileDictationStatus];
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_RECORDING object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DELETE_RECORDING object:nil];//to pause and remove audio player
// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    printf("Session interrupted! --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
	   
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        ThreadStateBeginInterruption();
    }
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        // make sure we are again the active session
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        ThreadStateEndInterruption();
    }
}

#pragma mark -Audio Session Route Change Notification

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    printf("Route change:\n");
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"     NewDeviceAvailable");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"     OldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"     CategoryChange");
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            NSLog(@"     Override");
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            NSLog(@"     WakeFromSleep");
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            NSLog(@"     NoSuitableRouteForCategory");
            break;
        default:
            NSLog(@"     ReasonUnknown");
    }
    
    printf("\nPrevious route:\n");
    NSLog(@"%@", routeDescription);
}

//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSDictionary*)dd
//{
//    NSLog(@"%@",dd);
//}
//
//-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    NSLog(@"%@",error);
//}
@end
