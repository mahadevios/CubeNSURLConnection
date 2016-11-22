//
//  SelectDepartmentViewController.m
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "SelectDepartmentViewController.h"
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "DepartMent.h"
#import "RegistrationViewController.h"
#import "MainTabBarViewController.h"

@interface SelectDepartmentViewController ()

@end

@implementation SelectDepartmentViewController
@synthesize tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Select Department";
    self.navigationItem.hidesBackButton=YES;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Database* db=[Database shareddatabase];
    departmentNameArray= [db getDepartMentNames];
    return departmentNameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* departmentNameLabel=[cell viewWithTag:101];
    departmentNameLabel.text=[departmentNameArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    UITableViewCell* cell=[tableview cellForRowAtIndexPath:indexPath];
    UILabel* departmentNameLabel= [cell viewWithTag:101];
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    // LoginViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    // [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES completion:nil];
    //[vc dismissViewControllerAnimated:YES completion:nil];
   DepartMent* deptObj= [[Database shareddatabase] getDepartMentFromDepartmentName:departmentNameLabel.text];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deptObj];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SELECTED_DEPARTMENT_NAME];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoadedFirstTime"];

    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];

    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
   // [self dismissViewControllerAnimated:NO completion:^{[self checkAndDismissViewController];}];
    
    //    [self performSelector:@selector(checkAndDismissViewController) withObject:nil afterDelay:0.5];
    //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"] animated:YES];
    //NSLog(@"%@",self.navigationController);
    
}

- (void) checkAndDismissViewController
{
    [self.view endEditing:YES];
    id viewController = [self topViewController];
    if([viewController isKindOfClass:[LoginViewController class]]){
        //do something
        [viewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
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
