//
//  RegistrationViewController.m
//  Cube
//
//  Created by mac on 12/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize IDTextField,passwordTextfield;
@synthesize submitButton,cancelButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    submitButton.layer.cornerRadius=7.0f;
    cancelButton.layer.cornerRadius=7.0f;
    IDTextField.layer.cornerRadius=7.0f;
    passwordTextfield.layer.cornerRadius=7.0f;
    IDTextField.layer.borderColor=[UIColor grayColor].CGColor;
    passwordTextfield.layer.borderColor=[UIColor grayColor].CGColor;
    IDTextField.layer.borderWidth=1.0f;
    passwordTextfield.layer.borderWidth=1.0f;

    // Do any additional setup after loading the view.
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

- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
