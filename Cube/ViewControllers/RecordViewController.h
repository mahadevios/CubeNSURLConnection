//
//  RecordViewController.h
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpCustomView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioSessionManager.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>

// helpers
//#include "CAXException.h"
//#include "CAStreamBasicDescription.h"
//#include "ExtAudioFileConvert.mm"

@interface RecordViewController : UIViewController<UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
{
    int i;
    UITapGestureRecognizer* tap;
    UIView* popupView;
    UIView* editPopUp;
    PopUpCustomView* forTableViewObj;
    UITableViewCell *cell;
    NSArray* departmentNamesArray;
    UISlider* audioRecordSlider;
    Database* db;
    APIManager* app;
    bool recordingPauseAndExit;
    bool recordingPausedOrStoped;
    bool isRecordingStarted;

    UILabel* cirecleTimerLAbel;
    NSTimer*  stopTimer;
    int circleViewTimerMinutes;
    int circleViewTimerSeconds;
    UILabel* currentDuration;
    UILabel* totalDuration;

    NSString* selectedDepartment;
    //for dictation wauting by setting
    NSString* maxRecordingTimeString;
    int dictationTimerSeconds;

    //for alertview
    NSDictionary* result;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
    BOOL deleted;
    NSDictionary* audiorecordDict;
    
    //for audio compression
    
    NSString *destinationFilePath;
    CFURLRef sourceURL;
    CFURLRef destinationURL;
    OSType   outputFormat;

    Float64  sampleRate;
    
    BOOL paused;
    BOOL stopped;
    UIBackgroundTaskIdentifier task;
    
    int minutesValue;
    BOOL recordingNew;
    
    NSString* recordedAudioFileName;

}
@property (nonatomic,strong)     AVAudioPlayer       *player;
@property (nonatomic,strong)     AVAudioRecorder     *recorder;
@property (nonatomic,strong)     NSString            *recordedAudioFileName;
@property (nonatomic,strong)     NSURL               *recordedAudioURL;
@property (nonatomic,strong)     NSString              *recordCreatedDateString;
@property (weak, nonatomic) MBProgressHUD *hud;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)moreButtonPressed:(id)sender;
- (IBAction)deleteRecording:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
