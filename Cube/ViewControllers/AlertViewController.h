//
//  AlertViewController.h
//  Cube
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewController : UIViewController
{
    Database* db;
    APIManager* app;
    int badgeCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
