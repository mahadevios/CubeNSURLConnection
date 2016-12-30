//
//  ShareViewController.m
//  MondExtension
//
//  Created by mac on 20/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//
//http://catthoughts.ghost.io/extensions-in-ios8-custom-views/        custom view
#import "ShareViewController.h"
//#import "ConfigurationViewController.h"


@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize audioFilePathString,fileName;
- (BOOL)isContentValid
{
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}
SLComposeSheetConfigurationItem *item;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton* copyAudioFileButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-30, 200, 50)];
    
    [copyAudioFileButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [copyAudioFileButton setTitle:@"Copy audio file to Cube" forState:UIControlStateNormal];
    
    UIView* navigationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(navigationView.center.x-100, navigationView.center.y-20, 200, 40)];
    
    titleLabel.font=[UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=@"Copy to Cube";
    
    titleLabel.textColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1.0];
    
    [navigationView addSubview:titleLabel];
    
    navigationView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    [self.view addSubview:navigationView];
    
    [self.view addSubview:copyAudioFileButton];
    
    [copyAudioFileButton addTarget:self action:@selector(copyAudioFileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    copyAudioFileButton.titleLabel.font=[UIFont systemFontOfSize:16];
    
    //    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.xanadutec.Mond"];
    //
    //    [sharedDefaults setObject:item forKey:@"sample"];
    //
    //    [sharedDefaults synchronize];
    //
    //    NSURL  *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.xanadutec.Mond"];
    
    
    
}
- (void)didSelectPost
{
    NSString *typeIdentifier = (NSString *)kUTTypeAudio;
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
 
    if ([itemProvider hasItemConformingToTypeIdentifier:typeIdentifier]) {
        [itemProvider loadItemForTypeIdentifier:typeIdentifier
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error)
         {
           
             
         }];
    }
    
}
//SLComposeSheetConfigurationItem *item1;

//-(void)saveImage:(NSURL*)url
//{
//    NSData* data=[NSData dataWithContentsOfURL:url];
//
//    UIImage* image=[UIImage imageWithData:data];
//
//    NSFileManager* fileManagaer=[NSFileManager defaultManager];
//
//    NSURL* url1= [fileManagaer containerURLForSecurityApplicationGroupIdentifier:@"group.com.xanadutec.Mond"];
//
//    NSString* uurr=[url1.path stringByAppendingPathComponent:@"images"] ;
//
//    BOOL isdir;
//    NSError *error = nil;
//    if (![fileManagaer fileExistsAtPath:uurr isDirectory:&isdir]) { //create a dir only that does not exists
//        if (![fileManagaer createDirectoryAtPath:uurr withIntermediateDirectories:YES attributes:nil error:&error]) {
//            NSLog(@"error while creating dir: %@", error.localizedDescription);
//        } else {
//            NSLog(@"dir was created....");
//        }
//    }
//    NSString* fileName=[url lastPathComponent];
//
//
//    NSString* dirr=[uurr stringByAppendingPathComponent:fileName];
//
//    NSData* data1= UIImagePNGRepresentation(image);
//
//    [data1 writeToFile:dirr atomically:YES];
//
//   // [data1 writeToURL:uurl atomically:YES];
//
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.xanadutec.Mond"];
////
//   NSString* value= [NSString stringWithFormat:@"%@",dirr];
//    [sharedDefaults setObject:value forKey:@"imageurl"];
//
//    NSArray* array=[NSArray new];
//    array=[sharedDefaults objectForKey:@"imageNamesArray"];
//    NSMutableArray* imageNamesArray=[NSMutableArray new];
//    if (array==NULL)
//    {
//
//        //
//
//        [imageNamesArray addObject:fileName];
//        //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [sharedDefaults setObject:imageNamesArray forKey:@"imageNamesArray"];
//
//    }
//    else
//    {
//      imageNamesArray= [array mutableCopy];
//        [imageNamesArray addObject:fileName];
//        //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [sharedDefaults setObject:imageNamesArray forKey:@"imageNamesArray"];
//
//    }
//   //    [userDefaults setObject:arrayOfText forKey:@"tableViewDataText"];
//   // [userDefaults synchronize];
////
//    [sharedDefaults synchronize];
//
//}

-(void)saveAudio:(NSURL*)url
{
    NSData* data=[NSData dataWithContentsOfURL:url];
    
    NSFileManager* fileManagaer=[NSFileManager defaultManager];
    
    NSURL* sharedGroupUrl= [fileManagaer containerURLForSecurityApplicationGroupIdentifier:@"group.com.coreFlexSolutions.CubeDictate"];
    
    NSString* audioFolderString=[sharedGroupUrl.path stringByAppendingPathComponent:@"audio"] ;
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coreFlexSolutions.CubeDictate"];
    
    [sharedDefaults setObject:audioFolderString forKey:@"audioFolderPath"];//set the folder path where file will b stored
    
    BOOL isdir;
    NSError *error = nil;
    if (![fileManagaer fileExistsAtPath:audioFolderString isDirectory:&isdir]) { //create a dir only that does not exists
        if (![fileManagaer createDirectoryAtPath:audioFolderString withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"error while creating dir: %@", error.localizedDescription);
        }
        else
        {
            NSLog(@"dir was created....");
        }
    }//create audio folder if not exist
    
    
    
    fileName=[url lastPathComponent];
    
    audioFilePathString=[audioFolderString stringByAppendingPathComponent:fileName];
    
    NSData* audioData= data;
    
    [audioData writeToFile:audioFilePathString atomically:YES];
    
    
    //    NSArray* array1=[NSArray new];
    //    array1=[sharedDefaults objectForKey:@"audioNamesArray"];
    //
    //    NSMutableArray* audioNamesArray=[NSMutableArray new];
    //
    //    if (array1==NULL)
    //    {
    //
    //        [audioNamesArray addObject:fileName];
    //        [sharedDefaults setObject:audioNamesArray forKey:@"audioNamesArray"];
    //
    //    }
    //    else
    //    {
    //        audioNamesArray= [array1 mutableCopy];
    //        [audioNamesArray addObject:fileName];
    //        [sharedDefaults setObject:audioNamesArray forKey:@"audioNamesArray"];
    //
    //    }
    
    
    [sharedDefaults synchronize];
    
    [self convertToWav];
    
}


-(void) convertToWav
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coreFlexSolutions.CubeDictate"];
    
    NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
    
    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
    
    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    
    
    NSString* sharedAudioFileNameString=fileName;
    
    NSURL* sharedAudioFolderPathUrl=[NSURL URLWithString:sharedAudioFolderPathString];
    
    
    NSString* sharedAudioFilePathString=[sharedAudioFolderPathUrl.path stringByAppendingPathComponent:sharedAudioFileNameString];
    
    
    NSData* sharedAudioFileData=[NSData dataWithContentsOfFile:sharedAudioFilePathString];
    
    NSString* homePathString=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[sharedAudioNamesArray lastObject]];
    
    NSError* err;
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:homePathString])
    {
        [[NSFileManager defaultManager] removeItemAtPath:homePathString error:&err];
    }
    BOOL write1= [sharedAudioFileData writeToFile:homePathString atomically:YES];
    
    //    NSArray* pathComponents = [NSArray arrayWithObjects:
    //                               NSHomeDirectory(),
    //                               @"Documents",
    //                               @"convertToWave.m4a",
    //                               nil];
    
    
    NSURL* newAssetUrl = [NSURL fileURLWithPath:sharedAudioFilePathString];
    
    NSError *assetError = nil;
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:newAssetUrl options:nil];
    
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                               error:&assetError]
    ;
    NSString* assetString=[NSString stringWithFormat:@"%@",assetError];
    
    [sharedDefaults setObject:[NSString stringWithFormat:@"%@",newAssetUrl] forKey:@"assetUrl"];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput: assetReaderOutput];
    
    
    if (assetError)
    {
        NSLog (@"error: %@", assetError);
        
        return;
    }
    
    NSString* audioFilePath=[sharedAudioFilePathString stringByDeletingPathExtension];
    
   // audioFilePath=[audioFilePath stringByAppendingPathExtension:@"wav"];
    
    NSString* waveFileName=[audioFilePath lastPathComponent];
    
    // [sharedDefaults setObject:waveFileName forKey:@"waveFileName"];
    
    if (!isFileAvailable)
    {
        NSArray* array1=[NSArray new];
        
        NSDictionary* dict1=[NSDictionary new];
        
        array1=[sharedDefaults objectForKey:@"audioNamesArray"];
        
        dict1=[sharedDefaults objectForKey:@"audioNamesAndDateDict"];

        NSMutableArray* audioNamesArray=[NSMutableArray new];
        
        NSMutableDictionary* audioNamesAndDatesDict=[NSMutableDictionary new];

        NSString* date=[self getDateAndTimeString];
        
        if (array1==NULL)
        {
            
            [audioNamesArray addObject:waveFileName];
            [sharedDefaults setObject:audioNamesArray forKey:@"audioNamesArray"];
            
            
            [audioNamesAndDatesDict setObject:date forKey:waveFileName];
            [sharedDefaults setObject:audioNamesAndDatesDict forKey:@"audioNamesAndDateDict"];

            
        }
        else
        {
            audioNamesArray= [array1 mutableCopy];
            [audioNamesArray addObject:waveFileName];
            [sharedDefaults setObject:audioNamesArray forKey:@"audioNamesArray"];
            
            audioNamesAndDatesDict=[dict1 mutableCopy];
            [audioNamesAndDatesDict setObject:date forKey:waveFileName];
            [sharedDefaults setObject:audioNamesAndDatesDict forKey:@"audioNamesAndDateDict"];

            
        }

    }
    
    
    
    NSString *wavFilePath = audioFilePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
    
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                          fileType:AVFileTypeWAVE
                                                             error:&assetError];
    if (assetError)
    {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput])
    {
        [assetWriter addInput:assetWriterInput];
    }
    else
    {
        NSLog (@"can't add asset writer input... die!");
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime: startTime];
    
    __block UInt64 convertedByteCount = 0;
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         
         while (assetWriterInput.readyForMoreMediaData)
         {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer)
             {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);
                 
                 CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
                 if (CMTIME_IS_NUMERIC(sampleDuration))
                     progressTime= CMTimeAdd(progressTime, sampleDuration);
                 float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
                 NSLog(@"%f",dProgress);
                 int pro=dProgress;
                 if (pro==1)
                 {
                     
                 }
             }
             else
             {
                 
                 [assetWriterInput markAsFinished];
                 //              [assetWriter finishWriting];
                 [assetReader cancelReading];
                 
             }
         }
     }];
    
    
    [sharedDefaults synchronize];
    
}
//-(void)setCompressAudio
//{
//    CFURLRef sourceURL;
//    CFURLRef destinationURL;
//    NSString* filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"WaveFile"]];
//
//    //     destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.recordedAudioFileName]];
//    // NSString *source = [[NSBundle mainBundle] pathForResource:@"sourceALAC" ofType:@"caf"];
//
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString* destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
//    NSError* error;
//
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
//
//    if (error)
//    {
//        printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)error.code);
//
//        return;
//    }
//
//
//    OSType   outputFormat;
//    Float64  sampleRate;
//
//
//    destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    outputFormat = kAudioFormatLinearPCM;
//
//    //  sampleRate = 44100.0;
//    sampleRate = 0;
//
//    OSStatus error1 = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
//    NSError* error2;
//
//    if (error) {
//        // delete output file if it exists since an error was returned during the conversion process
//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
//        }
//        NSString* destinationPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.wav",@"compressed"]];
//        [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] toPath:destinationPath error:&error];
//        printf("DoConvertFile failed! %d\n", (int)error1);
//
//        return;
//        // return false;
//    }
//    else
//    {
//        //NSLog(@"Converted");
//        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] error:&error2];
//        NSArray* pathComponents = [NSArray arrayWithObjects:
//                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//
//                                   [NSString stringWithFormat:@"%@.wav",@"compressed"],
//                                   nil];
//        //self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
//        //        [self saveAudioRecordToDatabase];
//        return;
//    }
//
//    // run audio file code in a background thread
//    // [self convertAudio];
//
//}
//
- (NSArray *)configurationItems
{
    
    item = [[SLComposeSheetConfigurationItem alloc] init];
    // Give your configuration option a title.
    [item setTitle:@"Item One"];
    // Give it an initial value.
    [item setValue:@"None"];
    // Handle what happens when a user taps your option.
    [item setTapHandler:^(void){
    }];
    
    //    ConfigurationViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ConfigurationViewController"];
    //    [self pushConfigurationViewController:vc];
    // Return an array containing your item.
    return @[item];
    
}
- (IBAction)saveToCubeButtonClicked:(id)sender
{
    NSLog(@"hello");
}

- (void)copyAudioFileButtonClicked:(id)sender
{
    NSString *typeIdentifier = (NSString *)kUTTypeAudio;
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    NSArray* arr= itemProvider.registeredTypeIdentifiers;
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coreFlexSolutions.CubeDictate"];

    [sharedDefaults setObject:arr forKey:@"array"];
    if ([itemProvider hasItemConformingToTypeIdentifier:typeIdentifier]) {
        [itemProvider loadItemForTypeIdentifier:typeIdentifier
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error)
         {
             NSURL *imageURL = (NSURL *)url;
             
             NSString* audioFileName=[imageURL lastPathComponent];
             
             NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coreFlexSolutions.CubeDictate"];
             
             NSArray* array1=[NSArray new];
             array1=[sharedDefaults objectForKey:@"audioNamesArray"];
             
             NSMutableArray* audioNamesArray=[NSMutableArray new];
             
             isFileAvailable=NO;
             if (array1==NULL)
             {
                 
                 //                 [audioNamesArray addObject:waveFileName];
                 //                 [sharedDefaults setObject:audioNamesArray forKey:@"audioNamesArray"];
                 
             }
             else
             {
                 
                 for (int i=0; i<array1.count; i++)
                 {
                     NSString * waveFileName=[array1 objectAtIndex:i];
                     
                     audioFileName=[audioFileName stringByDeletingPathExtension];
                     
                     //audioFileName=[audioFileName stringByAppendingPathExtension:@"wav"];
                     
                     if ([audioFileName isEqualToString:waveFileName])
                     {
                         isFileAvailable=YES;
                         
                         break;
                     }
                     if (isFileAvailable)
                     {
                         break;
                     }
                     
                 }
                 [sharedDefaults setBool:isFileAvailable forKey:@"is"];
                 
             }
             
             if (!isFileAvailable)
             {
                 [self saveAudio:imageURL];
                 [self.extensionContext completeRequestReturningItems:@[]
                                                    completionHandler:nil];
                 
             }
             else
             {
                 alertController = [UIAlertController alertControllerWithTitle:@"File already exist!"
                                                                       message:@"Replace file?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                 actionDelete = [UIAlertAction actionWithTitle:@"Replace"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [self saveAudio:imageURL];
                                     [self.extensionContext completeRequestReturningItems:@[]
                                                                        completionHandler:nil];
                                 }]; //You can use a block here to handle a press on this button
                 [alertController addAction:actionDelete];
                 
                 
                 actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                     [self.extensionContext completeRequestReturningItems:@[]
                                                                        completionHandler:nil];
                                 }]; //You can use a block here to handle a press on this button
                 [alertController addAction:actionCancel];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
             
             
            
             
             
            // [self saveAudio:imageURL];
             
             
         }];
    }
    
    else
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Unsupported file!"
                                                              message:@"Please select audio file to share"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                           
                            [self.extensionContext completeRequestReturningItems:@[]
                                                               completionHandler:nil];
                        }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionDelete];
        
        
//        actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
//                                                style:UIAlertActionStyleCancel
//                                              handler:^(UIAlertAction * action)
//                        {
//                            [alertController dismissViewControllerAnimated:YES completion:nil];
//                            [self.extensionContext completeRequestReturningItems:@[]
//                                                               completionHandler:nil];
//                        }]; //You can use a block here to handle a press on this button
//        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

-(NSString*)getDateAndTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd-yyyy HH:mm:ss";
    NSString* recordCreatedDateString = [formatter stringFromDate:[NSDate date]];
    return recordCreatedDateString;
}
@end
