//
//  UserSettingsViewController.h
//  Cube
//
//  Created by mac on 29/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettingsViewController : UIViewController<UIGestureRecognizerDelegate> 
{
    NSMutableArray* recordSettingsItemsarray;
    NSMutableArray* storageManagementItemsArray;
    NSMutableArray* PlaybackAutoRewindByArray;
    NSMutableArray* popUpOptionsArray;
    NSMutableArray* radioButtonArray;
    UITapGestureRecognizer* tap;
    UITapGestureRecognizer* tap1;

    UIView* abbreviationPopupView;
    AppPreferences* app;
}
@property (weak, nonatomic) IBOutlet UITableView *poUpTableView;
@property (weak, nonatomic) IBOutlet UITableView *userSettingsTableView;
- (IBAction)backButtonPressed:(id)sender;
@end
