//
//  AlertViewController.m
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AlertViewController.h"
#import "PopUpCustomView.h"
@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];

 self.navigationItem.title=@"Alert";

}
-(void)showUserSettings:(id)sender
{
 
    NSArray* subViewArray=[NSArray arrayWithObjects:@"User Setting", nil];
    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-170, self.view.frame.origin.y+20, 160, 35) andSubViews:subViewArray :self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];

}

-(void)UserSetting
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
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* inCompleteDictationLabel=[cell viewWithTag:101];
    UILabel* noDictationLabel=[cell viewWithTag:102];
    if (indexPath.row==0)
    {
        inCompleteDictationLabel.text=@"Incomplete Dictations";

    }
    else
    inCompleteDictationLabel.text=@"No Dictation";
    noDictationLabel.text=@"0";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"InCompleteDictationViewController"] animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];

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
