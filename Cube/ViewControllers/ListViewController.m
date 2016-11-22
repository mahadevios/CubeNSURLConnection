 //
//  ListViewController.m
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ListViewController.h"
#import "PopUpCustomView.h"
#import "TransferredOrDeletedAudioDetailsViewController.h"
@interface ListViewController ()

@end

@implementation ListViewController
@synthesize segment;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
//                                          initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = 1.0; //seconds
//    lpgr.delegate = self;
 //   [self.tableView addGestureRecognizer:lpgr];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    
    self.navigationItem.title=@"List";
    
        Database* db=[Database shareddatabase];
        APIManager* app=[APIManager sharedManager];
    
    app.transferredListArray=[db getListOfTransferredOrDeletedFiles:@"Transferred"];
    app.deletedListArray=[db getListOfTransferredOrDeletedFiles:@"Deleted"];

    [self.tableView reloadData];
    
}

-(void)showUserSettings:(id)sender
{
    
    NSArray* subViewArray=[NSArray arrayWithObjects:@"User Settings", nil];
    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-170, self.view.frame.origin.y+20, 160, 40) andSubViews:subViewArray :self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];
    
}

-(void)UserSettings
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"] animated:YES completion:nil];
}
-(void)dismissPopView:(id)sender
{
    
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0)
    {
        APIManager* app=[APIManager sharedManager];
        return app.transferredListArray.count;
    }
    if (segment.selectedSegmentIndex==1)
    {
        APIManager* app=[APIManager sharedManager];
        return app.deletedListArray.count;
    }
    else
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* fileNameLabel=[cell viewWithTag:101];
    UILabel* timeLabel=[cell viewWithTag:102];
    UILabel* transferByLabel=[cell viewWithTag:103];
    UILabel* dateLabel=[cell viewWithTag:104];
    
    APIManager* app=[APIManager sharedManager];
    NSDictionary* dict;
    if (segment.selectedSegmentIndex==0)
    {
        dict= [app.transferredListArray objectAtIndex:indexPath.row];
    }
    else
    dict= [app.deletedListArray objectAtIndex:indexPath.row];
    
    fileNameLabel.text=[dict valueForKey:@"RecordItemName"];
    NSString* dateAndTimeString=[dict valueForKey:@"Date"];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    if (segment.selectedSegmentIndex==0) {
        timeLabel.text=[NSString stringWithFormat:@"Transferred %@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]]];

    }
    else
        timeLabel.text=[NSString stringWithFormat:@"Deleted %@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]]];

    
    //timeLabel.text=[NSString stringWithFormat:@"%@",@"Transferred 12:18:00 PM"];

    transferByLabel.text=[dict valueForKey:@"Department"];
    
    dateLabel.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    TransferredOrDeletedAudioDetailsViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
    vc.listSelected=segment.selectedSegmentIndex;
    //NSLog(@"%ld",vc.listSelected);
    vc.selectedRow=indexPath.row;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)segmentChanged:(UISegmentedControl*)sender
{
    APIManager* app=[APIManager sharedManager];
    Database* db=[Database shareddatabase];
   self.segment.selectedSegmentIndex= sender.selectedSegmentIndex;
     app.deletedListArray=[db getListOfTransferredOrDeletedFiles:@"Deleted"];
    app.transferredListArray=[db getListOfTransferredOrDeletedFiles:@"Transferred"];

    [self.tableView reloadData];
}
@end
