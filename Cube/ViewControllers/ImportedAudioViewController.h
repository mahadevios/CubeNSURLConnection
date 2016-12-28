//
//  ImportedAudioViewController.h
//  Cube
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioSessionManager.h"

@interface ImportedAudioViewController : UIViewController
{
    NSURL *exportURL;
    int nextCount;
    NSString *destinationFilePath;
    CFURLRef sourceURL;
    CFURLRef destinationURL;
    OSType   outputFormat;
    
    Float64  sampleRate;
}

@property(nonatomic,strong)AVAudioPlayer* player;
- (IBAction)playAudioButtonClicked:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
