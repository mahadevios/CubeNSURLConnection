//
//  RecordViewController.m
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
// tag view 200 series are of storyboard reference Views
// tag with 300 series are of programmatically created actual circle Views

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    i=0;
    
    
    
    UIView* stopView= [self.view viewWithTag:201];
    [self performSelector:@selector(addView:) withObject:stopView afterDelay:0.0];
    
    UIView* pauseView= [self.view viewWithTag:202];
    [self performSelector:@selector(addView:) withObject:pauseView afterDelay:0.0];
    
    UIView* startRecordingView1= [self.view viewWithTag:203];
    [self performSelector:@selector(addView:) withObject:startRecordingView1 afterDelay:0.0];
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    UIImageView* counterLabel= [startRecordingView viewWithTag:503];
    [counterLabel setHidden:NO];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    self.navigationItem.title=@"Record";
    UILabel* fileNameLabel= [self.view viewWithTag:101];
    fileNameLabel.text=@"MOB-12633456787564344";
    UILabel* transferredByLabel= [self.view viewWithTag:102];
    transferredByLabel.text=@"Sanjay Ubale";
    UILabel* dateLabel= [self.view viewWithTag:103];
    dateLabel.text=@"3/08/2016";

}


-(void)addView:(UIView*)sender
{
    [self setRoundedView:sender toDiameter:sender.frame.size.width];
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    UIView* circleView=[[UIView alloc]init];
    NSLog(@"%f",self.view.frame.size.width);
    NSLog(@"%f",roundedView.frame.origin.x);;

    NSLog(@"%f",roundedView.center.x);
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    circleView.frame = newFrame;
    circleView.layer.cornerRadius = newSize / 2.0;
    circleView.tag=roundedView.tag+100;

    UIButton* viewClickbutton=[[UIButton alloc]init];
    viewClickbutton.frame=CGRectMake(0, 0, newSize, newSize);//button:subview of view hence 0,0
    
    UIImageView* startStopPauseImageview=[[UIImageView alloc]init];

    //--------set Images within the circle,add respective viewClickbutton targets-------//
    
    if (roundedView.tag==201)
    {
        startStopPauseImageview.image=[UIImage imageNamed:@"Stop"];
        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-8, 15, 15);

        circleView.backgroundColor=[UIColor grayColor];
        
        [viewClickbutton addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (roundedView.tag==202)
    {
        startStopPauseImageview.image=[UIImage imageNamed:@"Play"];
        startStopPauseImageview.frame=CGRectMake((newSize/2), (newSize/2)-8, 15, 15);
        startStopPauseImageview.tag=roundedView.tag+200;

        circleView.backgroundColor=[UIColor grayColor];
        [viewClickbutton addTarget:self action:@selector(pauseRecording:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    if (roundedView.tag==203)
    {
        startStopPauseImageview.image=[UIImage imageNamed:@"Record"];
        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-25, 30, 50);
        startStopPauseImageview.tag=roundedView.tag+200;

        circleView.layer.borderColor = [UIColor whiteColor].CGColor;
        circleView.layer.borderWidth = 3.0f;
        circleView.backgroundColor=[UIColor colorWithRed:194/255.0 green:19/255.0 blue:19/255.0 alpha:1];
        [viewClickbutton addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    //----------------------------------//
    
    [circleView addSubview:viewClickbutton];
    [circleView addSubview:startStopPauseImageview];
    [self.view addSubview:circleView];
}

-(void)stopRecording:(UIButton*)sender
{
  UIView* stopRecordingView = [self.view viewWithTag:301];
  UIView* pauseRecordingView =  [self.view viewWithTag:302];

    
    
    UIView* startRecordingView =  [self.view viewWithTag:303];
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1]])
    {
        [stopRecordingView setHidden:YES];
        [pauseRecordingView setHidden:YES];
        startRecordingView.backgroundColor=[UIColor blackColor];
        UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
        [startRecordingImageView setHidden:NO];
        [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-10, (startRecordingView.frame.size.height/2)-10, 15, 15)];
        startRecordingImageView.image=[UIImage imageNamed:@"Play"];
    }
    

}
-(void)pauseRecording:(UIButton*)sender
{
    UIView* pauseView=  [self.view viewWithTag:302];
    UIImageView* pauseImageView= [pauseView viewWithTag:402];
    if ( [pauseImageView.image isEqual:[UIImage imageNamed:@"Pause"]])
    {
        pauseImageView.image=[UIImage imageNamed:@"Play"];
    }
    else
    {
        pauseImageView.image=[UIImage imageNamed:@"Pause"];
    }
    
   // pauseImageView.image=[UIImage imageNamed:@"play"];
}
-(void)startRecording:(UIButton*)sender
{
    UIView* startRecordingView= [self.view viewWithTag:303];
    UIView* stopRecordingView = [self.view viewWithTag:301];
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    UILabel* recordingStatusLabel= [self.view viewWithTag:99];
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    UILabel* RecordingLabel=[self.view viewWithTag:603];

    
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1]] || [startRecordingView.backgroundColor isEqual:[UIColor blackColor]])
    {
        [stopRecordingView setHidden:YES];
        [pauseRecordingView setHidden:YES];
        [stopRecordingLabel setHidden:YES];
        [pauseRecordingLabel setHidden:YES];
        [RecordingLabel setHidden:YES];
        startRecordingView.backgroundColor=[UIColor blackColor];
        UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
        [startRecordingImageView setHidden:NO];
        [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-10, (startRecordingView.frame.size.height/2)-10, 15, 15)];
        if ([startRecordingImageView.image isEqual:[UIImage imageNamed:@"Play"]])
        {
            startRecordingImageView.image=[UIImage imageNamed:@"Pause"];

        }
        else
            startRecordingImageView.image=[UIImage imageNamed:@"Play"];
        
        //*-------------------for animated flipFromBottom subView---------------------*
        
        if (![[self.view viewWithTag:98] isDescendantOfView:self.view])
        {
       
        UIView* animatedView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2)];
        animatedView.tag=98;
        
        UISlider* audioRecordSlider=[[UISlider alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.15,animatedView.frame.size.height*0.01 , animatedView.frame.size.width*0.7, 30)];

            audioRecordSlider.minimumValue = 0.0;
            audioRecordSlider.maximumValue = 50.0;
            audioRecordSlider.continuous = YES;
            audioRecordSlider.value = 25.0;
            
        UIButton* uploadAudioButton=[[UIButton alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.1, animatedView.frame.size.height*0.2, animatedView.frame.size.width*0.8, 36)];
        uploadAudioButton.backgroundColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1];
        uploadAudioButton.userInteractionEnabled=YES;
        [uploadAudioButton setTitle:@"Upload Audio" forState:UIControlStateNormal];
        uploadAudioButton.titleLabel.font = [UIFont systemFontOfSize: 15];

        [uploadAudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadAudioButton.layer.cornerRadius=5.0f;
        
        UIButton* uploadLaterButton=[[UIButton alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.1, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 36)];
        uploadLaterButton.backgroundColor=[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
        [uploadLaterButton setTitle:@"Upload Later" forState:UIControlStateNormal];
        uploadLaterButton.titleLabel.font = [UIFont systemFontOfSize: 15];
        [uploadLaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadLaterButton.layer.cornerRadius=5.0f;
        
        UIButton* recordNewButton=[[UIButton alloc]initWithFrame:CGRectMake(uploadLaterButton.frame.origin.x+uploadLaterButton.frame.size.width+uploadAudioButton.frame.size.width*0.04, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 36)];
        recordNewButton.backgroundColor=[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
        [recordNewButton setTitle:@"Record New" forState:UIControlStateNormal];
        recordNewButton.titleLabel.font = [UIFont systemFontOfSize: 15];
        [recordNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        recordNewButton.layer.cornerRadius=5.0f;
        
        [animatedView addSubview:audioRecordSlider];
        [animatedView addSubview:uploadAudioButton];
        [animatedView addSubview:uploadLaterButton];
        [animatedView addSubview:recordNewButton];

        animatedView.backgroundColor=[UIColor whiteColor];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             animatedView.frame = CGRectMake(0, self.view.frame.size.height*0.6, self.view.frame.size.width, self.view.frame.size.height/2);
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:animatedView];
        
        }
        //*-------------------for animated flipFromBottom subView---------------------*

    }
    
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:194/255.0 green:19/255.0 blue:19/255.0 alpha:1]])
    {
        startRecordingView.backgroundColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1];
        recordingStatusLabel.text=@"Your audio is being recorded";

//        UILabel* timerLabel=[[UILabel alloc]initWithFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.width/2)-15, 30, 30)];
//        timerLabel.textAlignment=NSTextAlignmentCenter;
//        timerLabel.tag=503;
//        [startRecordingView addSubview:timerLabel];
        UIImageView* pauseRecordingImageView = [pauseRecordingView viewWithTag:402];
        pauseRecordingImageView.image=[UIImage imageNamed:@"Pause"];
        UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
        [startRecordingImageView setHidden:YES];
    }
   // NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTimer:) userInfo:nil repeats:YES];


}

//-(void)aTimer:(id)sender
//{
//    UIView* startRecordingView= [self.view viewWithTag:303];
//   UILabel* timerLabel= [startRecordingView viewWithTag:503];
//    timerLabel.text=[NSString stringWithFormat:@"%d",i++];
//}
-(void)showUserSettings:(id)sender
{
    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsNavigationController"] animated:YES completion:nil];
    // [self.navigationController pushViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"] animated:YES];
}



-(void)viewWillDisappear:(BOOL)animated
{
    UIView* startRecordingView= [self.view viewWithTag:303];
    UILabel* recordingStatusLabel=[self.view viewWithTag:99];
    recordingStatusLabel.text=@"Tap on recording to start recording your audio";
    startRecordingView.backgroundColor=[UIColor colorWithRed:194/255.0 green:19/255.0 blue:19/255.0 alpha:1];
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    UIImageView* counterLabel= [startRecordingView viewWithTag:503];
    
    [startRecordingImageView setHidden:NO];
    [counterLabel setHidden:YES];
    
    UIView* stopRecordingCircleView = [self.view viewWithTag:301];
    UIView* pauseRecordingCircleView =  [self.view viewWithTag:302];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    UILabel* recordingLabel=[self.view viewWithTag:603];

    
    [stopRecordingCircleView setHidden:NO];
    [pauseRecordingCircleView setHidden:NO];
    [stopRecordingLabel setHidden:NO];
    [pauseRecordingLabel setHidden:NO];
    [recordingLabel setHidden:NO];

    startRecordingImageView.image=[UIImage imageNamed:@"Record"];
    startRecordingImageView.frame=CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-25, 30, 50);

    UIView* animatedView=  [self.view viewWithTag:98];
    [animatedView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
