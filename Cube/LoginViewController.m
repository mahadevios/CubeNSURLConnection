//http://www.appcoda.com/customize-navigation-status-bar-ios-7/

//pixel to point conversion: http://endmemo.com/sconvert/pixelpoint.php

//provisioning profile ***: http://sharpmobilecode.com/making-sense-of-ios-provisioning/

//add provisioning profile**: http://docs.telerik.com/platform/appbuilder/cordova/code-signing-your-app/configuring-code-signing-for-ios-apps/create-ad-hoc-provisioning-profile

//property getter setter strong weak http://stackoverflow.com/questions/843632/is-there-a-difference-between-an-instance-variable-and-a-property-in-objecti

//strong reference concept ray wenderlich https://www.raywenderlich.com/5677/beginning-arc-in-ios-5-part-1

// about nsurlsession https://realm.io/news/gwendolyn-weston-ios-background-networking/

//about nsurlsession http://stackoverflow.com/questions/20390428/handleeventsforbackgroundurlsession-never-called-when-a-downloadtask-finished
//  ViewController.m
//  Cube
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "LoginViewController.h"
#import "DepartMent.h"
#import "MainTabBarViewController.h"
#import "NSData+AES256.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize pinCode1TextField,pinCode2TextField,pinCode3TextField,pinCode4TextField;
@synthesize hud;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated
{

    //self.navigationItem.title=@"Pin Login";
    //[self.navigationController.navigationBar setTitleTextAttributes:
    //@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
    //    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-Bold" size:30.0],NSFontAttributeName, nil];
    //
    //    self.navigationController.navigationBar.titleTextAttributes = size;
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"System-Bold" size:20]}];
    //
    //@{NSForegroundColorAttributeName:[UIColor orangeColor]}
    [pinCode1TextField becomeFirstResponder];
    pinCode1TextField.delegate=self;
    pinCode2TextField.delegate=self;
    pinCode3TextField.delegate=self;
    pinCode4TextField.delegate=self;
    
    pinCode1TextField.layer.cornerRadius=4.0f;
    pinCode1TextField.layer.masksToBounds=YES;
    pinCode1TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode1TextField.layer.borderWidth= 1.0f;
    
    pinCode2TextField.layer.cornerRadius=4.0f;
    pinCode2TextField.layer.masksToBounds=YES;
    pinCode2TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode2TextField.layer.borderWidth= 1.0f;
    
    pinCode3TextField.layer.cornerRadius=4.0f;
    pinCode3TextField.layer.masksToBounds=YES;
    pinCode3TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode3TextField.layer.borderWidth= 1.0f;
    
    pinCode4TextField.layer.cornerRadius=4.0f;
    pinCode4TextField.layer.masksToBounds=YES;
    pinCode4TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode4TextField.layer.borderWidth= 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validatePinResponseCheck:) name:NOTIFICATION_VALIDATE_PIN_API
                                               object:nil];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [pinCode4TextField resignFirstResponder];
    [pinCode1TextField resignFirstResponder];

}
-(void)validatePinResponseCheck:(NSNotification*)dictObj;
{
    NSDictionary* responseDict=dictObj.object;
    
    NSString* responseCodeString=  [responseDict valueForKey:RESPONSE_CODE];
    
    NSString* responsePinString=  [responseDict valueForKey:@"pinvalidflag"];
    
    if ([responseCodeString intValue]==401 && [responsePinString intValue]==0)
    {
        [hud hideAnimated:YES];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Incorrect PIN entered" withMessage:@"Please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        pinCode1TextField.text=@"";
        pinCode2TextField.text=@"";
        pinCode3TextField.text=@"";
        pinCode4TextField.text=@"";
        [pinCode1TextField becomeFirstResponder];
    }
    
    if ([responseCodeString intValue]==200 && [responsePinString intValue]==1)
    {

        [hud hideAnimated:YES];
        
        if([AppPreferences sharedAppPreferences].userObj == nil)
        {
            [AppPreferences sharedAppPreferences].userObj = [[User alloc] init];
        }
        
        NSString* pin=[NSString stringWithFormat:@"%@%@%@%@",pinCode1TextField.text,pinCode2TextField.text,pinCode3TextField.text,pinCode4TextField.text];

        [AppPreferences sharedAppPreferences].userObj.userPin = pin;
        
        

        NSArray* departmentArray=  [responseDict valueForKey:@"DepartmentList"];
        
        NSMutableArray* deptForDatabaseArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<departmentArray.count; i++)
        {
            DepartMent* deptObj=[[DepartMent alloc]init];
            
            NSDictionary* deptDict= [departmentArray objectAtIndex:i];
            
            deptObj.Id= [[deptDict valueForKey:@"ID"]longLongValue];
            
            deptObj.departmentName=[deptDict valueForKey:@"DeptName"];
            
            [deptForDatabaseArray addObject:deptObj];
        }

        Database *db=[Database shareddatabase];
        
        [db insertDepartMentData:deptForDatabaseArray];
        
        
        //get user firstname,lastname and userId for file prefix
        
        NSString* fileNamePrefix = [responseDict valueForKey:@"FileNamePrefix"];
        
        [[NSUserDefaults standardUserDefaults] setValue:fileNamePrefix forKey:@"FileNamePrefix"];
        
        [pinCode4TextField resignFirstResponder];
        
        [self dismissViewControllerAnimated:NO completion:nil];


        MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
        
        [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
        
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"])
        {
            
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"] animated:NO completion:nil];

        }
        else
            [self dismissViewControllerAnimated:NO completion:nil];
        
    }


}

- (void) checkAndDismissViewController
{
    id viewController = [self topViewController];
    if([viewController isKindOfClass:[LoginViewController class]]){
        //do something
        [viewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength==1)
    {
        [self performSelector:@selector(resignResponder:) withObject:textField afterDelay:0.0];
    }
    return newLength <= 1;
}

-(void)resignResponder:(id)sender
{
    if (sender==pinCode1TextField)
    {
        [pinCode2TextField becomeFirstResponder];
        
    }
    if (sender==pinCode2TextField)
    {
        [pinCode3TextField becomeFirstResponder];
        
    }
    if (sender==pinCode3TextField)
    {
        [pinCode4TextField becomeFirstResponder];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonCilcked:(id)sender
{
//    if ([AppPreferences sharedAppPreferences].isReachable)
//    {
   
    NSString* title;
    NSString* message;
    UIAlertController *alertController;
    UIAlertAction *actionOk;
    if ([pinCode1TextField.text isEqual:@""] || [pinCode2TextField.text isEqual:@""]|| [pinCode3TextField.text isEqual:@""] || [pinCode4TextField.text isEqual:@""])
    {
        title=@"Incomplete PIN code!";
        message=@"Please enter PIN code properly";
        alertController = [UIAlertController alertControllerWithTitle:title
                                                              message:message
                                                       preferredStyle:UIAlertControllerStyleAlert];
        actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        pinCode1TextField.text=@"";pinCode2TextField.text=@"";pinCode3TextField.text=@"";pinCode4TextField.text=@"";
                        [pinCode1TextField becomeFirstResponder];
                    }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        NSString* pin=[NSString stringWithFormat:@"%@%@%@%@",pinCode1TextField.text,pinCode2TextField.text,pinCode3TextField.text,pinCode4TextField.text];
        
        if([AppPreferences sharedAppPreferences].userObj != nil)
        {
            if([[AppPreferences sharedAppPreferences].userObj.userPin isEqualToString:pin])
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"])
                {
                    [pinCode4TextField resignFirstResponder];
                    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"] animated:NO completion:nil];
                }
                else
                {
                    [pinCode1TextField resignFirstResponder];
                    [pinCode4TextField resignFirstResponder];

                    [self dismissViewControllerAnimated:NO completion:nil];
                }

                return;
            }
            else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Incorrect pin entered" withMessage:@"Please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
                pinCode1TextField.text=@"";
                pinCode2TextField.text=@"";
                pinCode3TextField.text=@"";
                pinCode4TextField.text=@"";
                [pinCode1TextField becomeFirstResponder];
                return;
            }
        }
        
        else
        {
               if ([AppPreferences sharedAppPreferences].isReachable)
                {
                    //hud.label.text = NSLocalizedString(@"Please wait...", @"Validating credentials");
                    hud.minSize = CGSizeMake(150.f, 100.f);
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.label.text = @"Validating PIN";
                    hud.detailsLabel.text = @"Please wait";
                    NSString*     macId=[Keychain getStringForKey:@"udid"];

                    [pinCode4TextField resignFirstResponder];
                    //        [pinCode1TextField resignFirstResponder];
        
        
        
                    [[APIManager sharedManager] validatePinMacID:macId Pin:pin];
                    //[[APIManager sharedManager] authenticateUserMacID:@"68:FB:7E:9E:7D:51" password:@"d" username:@"SAN"];
                }
               else
               {
                   [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your inernet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
               }
        }
        
    }
//    }
//    else
//    {
//        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your inernet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//    }
    
  
}


- (IBAction)cancelButtonClicked:(id)sender
{
    pinCode1TextField.text=@"";
    pinCode2TextField.text=@"";
    pinCode3TextField.text=@"";
    pinCode4TextField.text=@"";
    [pinCode1TextField becomeFirstResponder];
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Hit home button to exit" withMessage:@"" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
}
@end
