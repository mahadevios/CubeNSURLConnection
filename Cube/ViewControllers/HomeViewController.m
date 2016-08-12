//
//  HomeViewController.m
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "HomeViewController.h"
#import "TransferListViewController.h"
#import "PopUpCustomView.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize transferredView,transferFailedView,awaitingTransferView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
   
       // [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES completion:nil];
    
    NSLog(@"%@",self.navigationController);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    transferFailedView.layer.cornerRadius=4.0f;
    transferredView.layer.cornerRadius=4.0f;
    awaitingTransferView.layer.cornerRadius=4.0f;
    
    tapRecogniser=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList:)];
    tapRecogniser1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList:)];
    tapRecogniser2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList:)];
    [transferredView addGestureRecognizer:tapRecogniser];
    [awaitingTransferView addGestureRecognizer:tapRecogniser1];
    [transferFailedView addGestureRecognizer:tapRecogniser2];

}

-(void)showUserSettings:(id)sender
{
    [self addPopView];
}


-(void)addPopView
{
//    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopView:)];
//
//    overlayView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    [overlayView addGestureRecognizer:tap];
//    overlayView.tag=111;
//    
//    overlayView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.1];
//    
//    UIView* popUpView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-170, self.view.frame.origin.y+20, 160, 80)];
//    popUpView.backgroundColor=[UIColor whiteColor];
//    
//    UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 12, 100, 20)];
//    [userSettingsButton setTitle:@"User Settings" forState:UIControlStateNormal];
//    [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [userSettingsButton addTarget:self action:@selector(selectSetting:) forControlEvents:UIControlEventTouchUpInside];
//    [popUpView addSubview:userSettingsButton];
//    
//    UIButton* logoutButton=[[UIButton alloc]initWithFrame:CGRectMake(userSettingsButton.frame.origin.x, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height+10, 100, 20)];
//    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
//    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    logoutButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [logoutButton addTarget:self action:@selector(selectSetting:) forControlEvents:UIControlEventTouchUpInside];
//    [popUpView addSubview:logoutButton];
//    
//    [overlayView addSubview:popUpView];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:overlayView];
    
    NSArray* subViewArray=[NSArray arrayWithObjects:@"User Setting",@"Logout", nil];
    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-170, self.view.frame.origin.y+20, 160, 65) andSubViews:subViewArray :self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];


}
-(void)UserSetting
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"] animated:YES completion:nil];
}



-(void)Logout
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];

    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"RegistrationViewController"] animated:YES completion:nil];

}
-(void)dismissPopView:(id)sender
{
    
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}

-(void)showList:(UITapGestureRecognizer*)sender
{
    TransferListViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"TransferListViewController"];
    if (sender==tapRecogniser)
    {
        vc.currentViewName=@"Today's Transferred";
    }
    if (sender==tapRecogniser1)
    {
        vc.currentViewName=@"Awaiting Transfer";
    }
    if (sender==tapRecogniser2)
    {
        vc.currentViewName=@"Transfer failed";
    }
    [self.navigationController pushViewController:vc animated:YES];

    NSLog(@"%@",self.tabBarController);

}
- (void)didReceiveMemoryWarning
{
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

@end
