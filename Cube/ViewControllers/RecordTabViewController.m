//
//  RecordTabViewController.m
//  Cube
//
//  Created by mac on 12/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "RecordTabViewController.h"

@interface RecordTabViewController ()

@end

@implementation RecordTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"] animated:YES completion:nil];
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

@end
