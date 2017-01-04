//
//  ImportedAudioViewController.m
//  Cube
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ImportedAudioViewController.h"
#import "AudioDetailsViewController.h"
extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@interface ImportedAudioViewController ()

@end

@implementation ImportedAudioViewController

@synthesize audioFilePath;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Imported Files";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateFileUploadResponse:) name:NOTIFICATION_FILE_UPLOAD_API
                                               object:nil];
    // Do any additional setup after loading the view.
}

-(void)validateFileUploadResponse:(NSNotification*)obj
{
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];

    [self.tableView reloadData];
}
-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    NSLog(@"%@",[sharedDefaults objectForKey:@"output"]);
//   // NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
//    
//    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
//    
//    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    int insertedFileCount = [[Database shareddatabase] getImportedFileCount];
//    
//    if (insertedFileCount<sharedAudioNamesArray.count)
//    {
//        //long unInsertedFileCount=sharedAudioNamesArray.count-insertedFileCount;
//        
//        [self setCompressAudio:insertedFileCount];
//        [self saveAudioRecordToDatabase:insertedFileCount];
//
//
//    }
//    
//    NSMutableDictionary* updatedFileDict=[sharedDefaults objectForKey:@"updatedFileDict"];
//
//    for (NSString* updatedFileNAme in [updatedFileDict allKeys])
//    {
//        NSString* updatedValue= [updatedFileDict objectForKey:updatedFileNAme];
//
//        if ([updatedValue isEqualToString:@"YES"])
//        {
//            NSLog(@"%@",updatedFileNAme);
//            [[Database shareddatabase] updateAudioFileDeleteStatus:@"NoDelete" fileName:updatedFileNAme];
//            [self setCompressAudioFileName:updatedFileNAme];
//
//        }
//    }
    
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];
    
    
    [self.tableView reloadData];
    
    
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
        
        audioFilePathString=[audioFilePathString stringByAppendingPathExtension:@"wav"];
        NSURL* newurl=[NSURL URLWithString:audioFolderPath];
        
        NSString* audioFilePath1=[newurl.path stringByAppendingPathComponent:audioFilePathString];
        
        NSData* audioData=[NSData dataWithContentsOfFile:audioFilePath1];
        
        
        NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
        
        //        dispatch_async(dispatch_get_main_queue(), ^
        //                       {
        //NSLog(@"Reachable");
        NSError* error;
       
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
       
        player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        
        [player play];
        
       // bool playing=[self.player isPlaying];
        NSLog(@"%@", error.localizedDescription);
        
        // });
        
    }
    
}



-(void)setCompressAudio:(int)insertedFileCount
{
    NSMutableArray* audioNamesArray=[NSMutableArray new];
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];

    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
    for (long i=0+insertedFileCount; i<audioNamesArray.count; i++)
    {
    
    NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
        
    NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
    
    NSString* audioFileNameString=[audioNamesArray objectAtIndex:i];
    
    NSString* audioFileNameForDestination= [NSString stringWithFormat:@"Copied%@",audioFileNameString];

    NSURL* newurl=[NSURL URLWithString:audioFolderPath];
    
    audioFilePath=[newurl.path stringByAppendingPathComponent:audioFileNameString];
    
//        NSError* error12;
//        bool copied=   [[NSFileManager defaultManager] copyItemAtPath:audioFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/copied.wav",AUDIO_FILES_FOLDER_NAME]] error:&error12];
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
}

-(void)setCompressAudioFileName:(NSString*)audioFileNameString
{
    NSMutableArray* audioNamesArray=[NSMutableArray new];
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
    
    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
   
        
        NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
        
        NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
    
        NSString* audioFileNameForDestination= [NSString stringWithFormat:@"Copied%@",audioFileNameString];
        
        NSURL* newurl=[NSURL URLWithString:audioFolderPath];
        
        audioFilePath=[newurl.path stringByAppendingPathComponent:audioFileNameString];
    
   
        
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

        
        return false;
    }
    else
    {
        NSLog(@"Converted");
        
        NSError* error;

        NSString* folderPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
        NSString* homeDirectoryFileName=[audioFilePath lastPathComponent];//store on same name as shared file name

          // [[NSFileManager defaultManager] moveItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]] error:&error1];
                if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]]])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]] error:nil];
                }

     bool copied=   [[NSFileManager defaultManager] copyItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]] error:&error1];

//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath])
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:&error];//remove temporary file which was used to store compression result
//        }
//        if ([[NSFileManager defaultManager] fileExistsAtPath:audioFilePath])
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:audioFilePath error:&error];//remove file stored at shared storage(i.e. in path extension) 
//        }
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];

        
        NSDictionary* copyDict=[sharedDefaults objectForKey:@"updatedFileDict"];
        
        NSMutableDictionary* updatedFileDict=[copyDict mutableCopy];
        
        [updatedFileDict setObject:@"NO" forKey:homeDirectoryFileName];
        
        [sharedDefaults setObject:updatedFileDict forKey:@"updatedFileDict"];
        
        [sharedDefaults synchronize];
        
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
        
        NSString* sharedAudioFilePathString= [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,fileName]];
        
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
        
        NSURL* fileURL=[NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL
                                                    options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithBool:YES],
                                                             AVURLAssetPreferPreciseDurationAndTimingKey,
                                                             nil]];
        
        NSTimeInterval durationInSeconds = 0.0;
        if (asset)
            durationInSeconds = CMTimeGetSeconds(asset.duration) ;
        
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
   
    
    
    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryAudioProcessing];
       // [recorder stop];
    
    NSData* audioData=[NSData dataWithContentsOfFile:filePath];
    
   
    //NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
    
    //        dispatch_async(dispatch_get_main_queue(), ^
    //                       {
    //NSLog(@"Reachable");
    NSError* error;
    
    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    
    player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
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
    NSDictionary* awaitingFileTransferDict;
    
    awaitingFileTransferDict=[[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* departmentNameLabel=[cell viewWithTag:101];
    departmentNameLabel.text=[[awaitingFileTransferDict valueForKey:@"RecordItemName"] stringByDeletingPathExtension];
    NSString* dateAndTimeString=[awaitingFileTransferDict valueForKey:@"RecordCreatedDate"];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    UILabel* recordingDurationLabel=[cell viewWithTag:102];
    int audioMinutes= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]/60;
    int audioSeconds= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]%60;
    
    recordingDurationLabel.text=[NSString stringWithFormat:@"%02d:%02d",audioMinutes,audioSeconds];
    
    UILabel* nameLabel=[cell viewWithTag:103];
    nameLabel.text=[awaitingFileTransferDict valueForKey:@"Department"];
    
    UILabel* statusLabel=[cell viewWithTag:106];
    if ([[awaitingFileTransferDict valueForKey:@"TransferStatus"] isEqualToString:@"Transferred"] && !([[awaitingFileTransferDict valueForKey:@"DictationStatus"] isEqualToString:@"RecordingFileUpload"]))
    {
        statusLabel.textColor=[UIColor colorWithRed:49/255.0 green:85/255.0 blue:25/255.0 alpha:1.0];
    }
    else
    {
        statusLabel.textColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1.0];

    }
    
    if ([[awaitingFileTransferDict valueForKey:@"DictationStatus"] isEqualToString:@"RecordingFileUpload"])
        
    {
        statusLabel.text=@"Uploading";

    }
    else
    statusLabel.text=[awaitingFileTransferDict valueForKey:@"TransferStatus"];
    
    UILabel* dateLabel=[cell viewWithTag:104];
    dateLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
    
    UILabel* timeLabel=[cell viewWithTag:105];
    timeLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]];

    
    return cell;
}
- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary* awaitingFileTransferDict;
   UITableViewCell* cell= [tableview cellForRowAtIndexPath:indexPath];
    
    UILabel* deleteStatusLabel=[cell viewWithTag:106];
    
    if(([deleteStatusLabel.text isEqual:@"Uploading"]))
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Alert?"
                                                              message:@"File is in use!"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionDelete];
        
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

    else
    {
    
    AudioDetailsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AudioDetailsViewController"];
    vc.selectedView=@"Imported";
    vc.selectedRow=indexPath.row;
    [self presentViewController:vc animated:YES completion:nil];
    }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
