//
//  ImportedAudioViewController.m
//  Cube
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ImportedAudioViewController.h"
extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@interface ImportedAudioViewController ()

@end

@implementation ImportedAudioViewController

@synthesize player;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Imported Files";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    // Do any additional setup after loading the view.
}
-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
    
   // NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
    
    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
    
    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    
    int insertedFileCount = [[Database shareddatabase] getImportedFileCount];
    
    if (insertedFileCount<sharedAudioNamesArray.count)
    {
        //long unInsertedFileCount=sharedAudioNamesArray.count-insertedFileCount;
        
        [self saveAudioRecordToDatabase:insertedFileCount];
    }
    
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];
    
    [self setCompressAudio];
    
}
- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showAudio
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
    
    NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
    
    NSMutableArray* audioNamesArray=[NSMutableArray new];
    
    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    
    NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
    if (nextCount<audioNamesArray.count)
    {
        //BOOL exist=[defaultManager fileExistsAtPath:audioFolderPath];
        NSString* audioFilePathString=[audioNamesArray objectAtIndex:nextCount];
        nextCount++;
        //NSString* audioFilePathString=[sharedDefaults objectForKey:@"waveFileName"];
        
        
        //audioFilePathString=[audioFilePathString stringByDeletingPathExtension];
        
        // audioFilePathString=[audioFilePathString stringByAppendingPathExtension:@"wav"];
        NSURL* newurl=[NSURL URLWithString:audioFolderPath];
        
        NSString* audioFilePath=[newurl.path stringByAppendingPathComponent:audioFilePathString];
        
        NSData* audioData=[NSData dataWithContentsOfFile:audioFilePath];
        
        
        NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
        
        //        dispatch_async(dispatch_get_main_queue(), ^
        //                       {
        //NSLog(@"Reachable");
        NSError* error;
       
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
       
        self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        
        [self.player play];
        
       // bool playing=[self.player isPlaying];
        NSLog(@"%@", error.localizedDescription);
        
        // });
        
    }
    
}


//-(void) convertToWav
//{
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
//    
//    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
//    
//    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    
//    NSString* sharedAudioFileNameString=[sharedAudioNamesArray lastObject];
//    
//    NSURL* sharedAudioFolderPathUrl=[NSURL URLWithString:sharedAudioFolderPathString];
//    
//    
//    NSString* sharedAudioFilePathString=[sharedAudioFolderPathUrl.path stringByAppendingPathComponent:sharedAudioFileNameString];
//    
//    
//    NSData* sharedAudioFileData=[NSData dataWithContentsOfFile:sharedAudioFilePathString];
//    
//    NSString* homePathString=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[sharedAudioNamesArray lastObject]];
//    
//    NSError* err;
//    
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:homePathString])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:homePathString error:&err];
//    }
//    BOOL write1= [sharedAudioFileData writeToFile:homePathString atomically:YES];
//    
//    //    NSArray* pathComponents = [NSArray arrayWithObjects:
//    //                               NSHomeDirectory(),
//    //                               @"Documents",
//    //                               @"convertToWave.m4a",
//    //                               nil];
//    
//    
//    NSURL* newAssetUrl = [NSURL fileURLWithPath:homePathString];
//    
//    NSError *assetError = nil;
//    
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:newAssetUrl options:nil];
//    
//    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
//                                                               error:&assetError]
//    ;
//    NSString* assetString=[NSString stringWithFormat:@"%@",assetError];
//    
//    [sharedDefaults setObject:assetString forKey:@"assetUrl"];
//    if (assetError) {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
//                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
//                                              audioSettings: nil];
//    if (! [assetReader canAddOutput: assetReaderOutput]) {
//        NSLog (@"can't add reader output... die!");
//        return;
//    }
//    [assetReader addOutput: assetReaderOutput];
//    
//    
//    if (assetError) {
//        NSLog (@"error: %@", assetError);
//        
//        return;
//    }
//    
//    NSString* audioFilePath=[homePathString stringByDeletingPathExtension];
//    
//    audioFilePath=[audioFilePath stringByAppendingPathExtension:@"wav"];
//    
//    NSString *wavFilePath = audioFilePath;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
//    }
//    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
//    
//    
//    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
//                                                          fileType:AVFileTypeWAVE
//                                                             error:&assetError];
//    if (assetError)
//    {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AudioChannelLayout channelLayout;
//    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
//                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
//                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
//                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
//                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
//                                    nil];
//    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
//                                                                              outputSettings:outputSettings];
//    if ([assetWriter canAddInput:assetWriterInput])
//    {
//        [assetWriter addInput:assetWriterInput];
//    }
//    else
//    {
//        NSLog (@"can't add asset writer input... die!");
//        return;
//    }
//    
//    assetWriterInput.expectsMediaDataInRealTime = NO;
//    
//    [assetWriter startWriting];
//    [assetReader startReading];
//    
//    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
//    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
//    [assetWriter startSessionAtSourceTime: startTime];
//    
//    __block UInt64 convertedByteCount = 0;
//    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
//    
//    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
//                                            usingBlock: ^
//     {
//         
//         while (assetWriterInput.readyForMoreMediaData)
//         {
//             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
//             if (nextBuffer)
//             {
//                 // append buffer
//                 [assetWriterInput appendSampleBuffer: nextBuffer];
//                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
//                 CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);
//                 
//                 CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
//                 if (CMTIME_IS_NUMERIC(sampleDuration))
//                     progressTime= CMTimeAdd(progressTime, sampleDuration);
//                 float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
//                 NSLog(@"%f",dProgress);
//                 int pro=dProgress;
//                 if (pro==1)
//                 {
//                     
//                 }
//             }
//             else
//             {
//                 
//                 [assetWriterInput markAsFinished];
//                 //              [assetWriter finishWriting];
//                 [assetReader cancelReading];
//                 
//             }
//         }
//     }];
//    [sharedDefaults synchronize];
//    
//}

-(void)setCompressAudio
{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
    
    NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
    
    NSMutableArray* audioNamesArray=[NSMutableArray new];
    
    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    
    NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
    
    NSString* audioFileNameString=[audioNamesArray objectAtIndex:0];
    
    NSString* audioFileNameForDestination= [NSString stringWithFormat:@"Copied%@",audioFileNameString];

    NSURL* newurl=[NSURL URLWithString:audioFolderPath];
    
    NSString* audioFilePath=[newurl.path stringByAppendingPathComponent:audioFileNameString];
    
    NSString* audioFilePathForDestination=[newurl.path stringByAppendingPathComponent:audioFileNameForDestination];
    
    destinationFilePath= [NSString stringWithFormat:@"%@",audioFilePathForDestination];
    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)audioFilePath, kCFURLPOSIXPathStyle, false);
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
    
    if (error)
    {
        printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)error.code);
        
        return;
    }
    
    
   
     [self convertAudio];
    
}
- (bool)convertAudio
{
    //    outputFormat = kAudioFormatLinearPCM;
    outputFormat = kAudioFormatLinearPCM;
    
      sampleRate = 8000.0;
    //sampleRate = 0;
    
    OSStatus error = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
    NSError* error1;
    
    if (error) {
        // delete output file if it exists since an error was returned during the conversion process
//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
//        }
//        NSString* destinationPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
//        [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] toPath:destinationPath error:&error1];
//        printf("DoConvertFile failed! %d\n", (int)error);
//        [self hideHud];
        
        return false;
    }
    else
    {
        NSLog(@"Converted");
          // [[NSFileManager defaultManager] moveItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]] error:&error1];
                if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]]]) {
                    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]] error:nil];
                }

        
        [[NSFileManager defaultManager] copyItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]] error:&error1];
//        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error1];
//        NSArray* pathComponents = [NSArray arrayWithObjects:
//                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                                   AUDIO_FILES_FOLDER_NAME,
//                                   [NSString stringWithFormat:@"%@.wav", self.recordedAudioFileName],
//                                   nil];
       // self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
        //        [self saveAudioRecordToDatabase];
       // [self hideHud];
        return true;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)saveAudioRecordToDatabase:(long) insertedFileCount
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];

    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
    
    NSMutableDictionary* sharedAudioNamesAndDateDict=[NSMutableDictionary new];

    
    NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];

    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    
    sharedAudioNamesAndDateDict=[sharedDefaults objectForKey:@"audioNamesAndDateDict"];

    NSLog(@"%ld",sharedAudioNamesAndDateDict.count);
    
//    if (insertedFileCount==0)
//    {
//        insertedFileCount=1;
//    }
    for (long i=0+insertedFileCount; i<sharedAudioNamesArray.count; i++)
    {
        NSString* fileName=[sharedAudioNamesArray objectAtIndex:i];
        
        APIManager* app=[APIManager sharedManager];
        
        //NSString* recordedAudioFileNamem4a=[NSString stringWithFormat:@"%@.wav",fileName];
        
        NSString* sharedAudioFilePathString= [sharedAudioFolderPathString stringByAppendingPathComponent:fileName];
        
        NSString* filePath=sharedAudioFilePathString;
        
        uint64_t freeSpaceUnsignLong= [[APIManager sharedManager] getFileSize:filePath];
        long fileSizeinKB=freeSpaceUnsignLong;
        
        [self prepareAudioPlayer:sharedAudioFilePathString];//initiate audio player with current recording to get currentAudioDuration
        
        NSString* recordCreatedDateString=[app getDateAndTimeString];//recording createdDate
        NSString* recordingDate=@"";//recording updated date
        
        int dictationStatus=5;
        //    if (recordingPauseAndExit)
        //    {
        //        dictationStatus=2;
        //    }
        int transferStatus=0;
        int deleteStatus=0;
        NSString* deleteDate=@"";
        NSString* transferDate=@"";
        
        //int duration= ceil(player.duration);
        NSString *currentDuration1=[NSString stringWithFormat:@"%f",player.duration];
        NSString* fileSize=[NSString stringWithFormat:@"%ld",fileSizeinKB];
        int newDataUpdate=5;
        int newDataSend=0;
        int mobileDictationIdVal;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
        DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //deptObj.departmentName=departmentNameLanel.text;
        //DepartMent *deptObj=[[NSUserDefaults standardUserDefaults] valueForKey:SELECTED_DEPARTMENT_NAME];
        //deptObj.departmentName;
        NSString* departmentName=[[Database shareddatabase] getDepartMentIdFromDepartmentName:deptObj.departmentName];
        
        NSDictionary* audioRecordDetailsDict=[[NSDictionary alloc]initWithObjectsAndKeys:fileName,@"recordItemName",recordCreatedDateString,@"recordCreatedDate",recordingDate,@"recordingDate",transferDate,@"transferDate",[NSString stringWithFormat:@"%d",dictationStatus],@"dictationStatus",[NSString stringWithFormat:@"%d",transferStatus],@"transferStatus",[NSString stringWithFormat:@"%d",deleteStatus],@"deleteStatus",deleteDate,@"deleteDate",fileSize,@"fileSize",currentDuration1,@"currentDuration",[NSString stringWithFormat:@"%d",newDataUpdate],@"newDataUpdate",[NSString stringWithFormat:@"%d",newDataSend],@"newDataSend",[NSString stringWithFormat:@"%d",mobileDictationIdVal],@"mobileDictationIdVal",departmentName,@"departmentName",nil];
        
        [[Database shareddatabase] insertRecordingData:audioRecordDetailsDict];
        //    if (recordingPauseAndExit)
        //    {
        //        int count= [db getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
        //        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",count] forKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
        //    }

    }
    
    
}
-(void)prepareAudioPlayer:(NSString*)filePath
{
   
    
    
    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
       // [recorder stop];
    NSError *audioError;
    
    NSData* audioData=[NSData dataWithContentsOfFile:filePath];
    
    
    //NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
    
    //        dispatch_async(dispatch_get_main_queue(), ^
    //                       {
    //NSLog(@"Reachable");
    NSError* error;
    
    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    //player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&audioError];
    //int maxValue= ceil(player.duration);

    //player.delegate = self;
    
    [player prepareToPlay];
    
}
- (IBAction)playAudioButtonClicked:(id)sender
{
    [self showAudio];
}




#pragma mark: tableView delegates adn datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSLog(@"%ld",[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count);
    return [AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APIManager* app=[APIManager sharedManager];
    NSDictionary* awaitingFileTransferDict;
    
    awaitingFileTransferDict=[[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* departmentNameLabel=[cell viewWithTag:101];
    departmentNameLabel.text=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
    NSString* dateAndTimeString=[awaitingFileTransferDict valueForKey:@"RecordCreatedDate"];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    UILabel* timeLabel=[cell viewWithTag:102];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]];
    
    UILabel* nameLabel=[cell viewWithTag:103];
    nameLabel.text=[awaitingFileTransferDict valueForKey:@"Department"];
    
    UILabel* deleteStatusLabel=[cell viewWithTag:105];
    
    UILabel* dateLabel=[cell viewWithTag:104];
    dateLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary* awaitingFileTransferDict;
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    APIManager* app=[APIManager sharedManager];
    
    [self.navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AudioDetailsViewController"] animated:YES completion:nil];
    
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
