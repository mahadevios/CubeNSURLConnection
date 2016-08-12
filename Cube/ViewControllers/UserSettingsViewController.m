//
//  UserSettingsViewController.m
//  Cube
//
//  Created by mac on 29/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "SwitchCreation.h"
#import "PopUpCustomView.h"

@interface UserSettingsViewController ()

@end

@implementation UserSettingsViewController
@synthesize poUpTableView;
@synthesize userSettingsTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([[self.view viewWithTag:112] respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;

    app=[AppPreferences sharedPreferences];
    recordSettingsItemsarray=[[NSMutableArray alloc]initWithObjects:@"Save Dictation Waiting by",@"Confirm before saving",@"Alert before recording",@"Back to home after dictation",@"Record abbreviation", nil];
    storageManagementItemsArray=[[NSMutableArray alloc]initWithObjects:@"Low Storage Threshold",@"Purge Deleted Data", nil];
    PlaybackAutoRewindByArray=[[NSMutableArray alloc]initWithObjects:@"Change your password", nil];
    popUpOptionsArray=[[NSMutableArray alloc]init];
    radioButtonArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self.view viewWithTag:112] setHidden:YES];
    abbreviationPopupView.tag=121;
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissPopView:)];
    tap.delegate=self;
    [[self.view viewWithTag:112] addGestureRecognizer:tap];

    tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissPopView:)];
    tap1.delegate=self;

    self.navigationItem.title=@"User Settings";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"dictationTime"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lowStorageThreshold"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfDaysForDeletedData"]);

    
}
-(void)popViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"section");
    if ([tableView isEqual:self.poUpTableView])
    {
        return 1;
    }
    else
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSLog(@"viewforHeader");
    if ([tableView isEqual:self.userSettingsTableView])
    {
  
    UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 60)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 20, tableView.frame.size.width*0.5, 17)];
    [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [sectionHeaderView addSubview:sectionTitleLabel];
    
    //for upper undeline view of section
    if (section!=0)
    {
        UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        [sectionHeaderView addSubview:lineView];
    }
    
    //for lower underline view of section
    UIView* lineView1=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 60, tableView.frame.size.width, 1)];
    lineView1.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    [sectionHeaderView addSubview:lineView1];
    
    if (section==0)
    {
        sectionTitleLabel.text=@"Record Settings";
        return sectionHeaderView;
    }
    else
    if (section==1)
    {
        sectionTitleLabel.text=@"Storage Management";
        return sectionHeaderView;
    }
    else
    if (section==2)
    {
        sectionTitleLabel.text=@"Playback Auto-Rewind by";
        return sectionHeaderView;
    }
    else
        return sectionHeaderView;
    }
    else
    {
        UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 60)];
        UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 20, tableView.frame.size.width, 17)];
        [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
        UIFont *currentFont = sectionTitleLabel.font;
        UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
        sectionTitleLabel.font = newFont;
        [sectionHeaderView addSubview:sectionTitleLabel];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"00"])
        {
            sectionTitleLabel.text=@"Select Time";
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"04"])
        {
            sectionTitleLabel.text=@"";
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"10"])
        {
            sectionTitleLabel.text=@"Select low storage threshold";
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"11"])
        {
            sectionTitleLabel.text=@"Set number of days";
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"20"])
        {
            sectionTitleLabel.text=@"";
        }

        return sectionHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:poUpTableView])
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"10"])
        {
            return 40;
        }
        else
        return 50;
    }
    else
    return 60;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:poUpTableView])
    {
        return 40;
    }
    else
        return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([tableView isEqual:self.userSettingsTableView])
    {
   
     if (section==0)
     {
        return recordSettingsItemsarray.count;
     }
     else
     if (section==1)
     {
         return storageManagementItemsArray.count;
     }
     else
     if (section==2)
     {
        return PlaybackAutoRewindByArray.count;
     }
     else
        return 0;
    }
    else
        return popUpOptionsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableview isEqual:self.userSettingsTableView])
    {
        UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.tag=indexPath.row;
        if (indexPath.section==0)
        {
            UILabel* nameLabel= [cell viewWithTag:101];
            nameLabel.text=[recordSettingsItemsarray objectAtIndex:indexPath.row];
            
            if (indexPath.row!=0 && indexPath.row!=4)
            {
                SwitchCreation* switchobj=[SwitchCreation new];
                switchobj.tableview=tableview;
                switchobj.cell=cell;
                switchobj.label=nameLabel;
                [self performSelector:@selector(createSwitch:) withObject:switchobj afterDelay:0.0];
                
            }
           
            
        }
        //CGRectMake(self.view.frame.origin.x+10, self.view.frame.origin.y+20, self.view.frame.size.width-40, 200)
        //to remove underline of last row of section so that scetion view underline does not ger override
        if (indexPath.section==0 && indexPath.row==recordSettingsItemsarray.count-1)
        {
            UIView* vw=[cell viewWithTag:102];
            [vw removeFromSuperview];
        }
        if (indexPath.section==1 && indexPath.row==storageManagementItemsArray.count-1)
        {
            UIView* vw=[cell viewWithTag:102];
            [vw removeFromSuperview];
        }
        if (indexPath.section==1)
        {
            UILabel* nameLabel= [cell viewWithTag:101];
            nameLabel.text=[storageManagementItemsArray objectAtIndex:indexPath.row];
        }
        if (indexPath.section==2)
        {
            UILabel* nameLabel= [cell viewWithTag:101];
            nameLabel.text=[PlaybackAutoRewindByArray objectAtIndex:indexPath.row];
        }

     return cell;
    }
    else
    {
        UITableViewCell *cell1 = [tableview dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        UILabel* selectOptionLabel= [cell1 viewWithTag:114];
        selectOptionLabel.text=[popUpOptionsArray objectAtIndex:indexPath.row];
        
        if (radioButtonArray.count==0)
        {
            UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
            [button setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
            UIButton* button1=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
            [button1 setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
            UIButton* button2=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
            [button2 setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
            UIButton* button3=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
            [button3 setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
            radioButtonArray=[NSMutableArray arrayWithObjects:button,button1,button2,button3, nil];
            
            

        }
        

       
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"00"])
        {

            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"dictationTime"] isEqualToString:selectOptionLabel.text])
            {
                UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
                [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
                [radioButtonArray replaceObjectAtIndex:indexPath.row withObject:button];
            }
            

            [cell1 addSubview:[radioButtonArray objectAtIndex:indexPath.row]];

        }
        

        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"10"])
        {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"lowStorageThreshold"] isEqualToString:selectOptionLabel.text])
            {
                UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
                [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
                [radioButtonArray replaceObjectAtIndex:indexPath.row withObject:button];
            }
            
            [cell1 addSubview:[radioButtonArray objectAtIndex:indexPath.row]];
            
            
        }

        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"11"])
        {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfDaysForDeletedData"] isEqualToString:selectOptionLabel.text])
            {
                UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 19, 19)];
                [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
                [radioButtonArray replaceObjectAtIndex:indexPath.row withObject:button];
            }
            
                [cell1 addSubview:[radioButtonArray objectAtIndex:indexPath.row]];
                
            
        }

        //selectOptionLabel.text=@"asdssdjkkjjkjkiloljlklkkkjklkljkljkljkljkl";
        return cell1;
    }
}

-(void)createSwitch:(SwitchCreation*)sender
{
    BOOL flag=false;
    for (UIView* subview in sender.cell.subviews)
    {
        if ([subview isKindOfClass:[UISwitch class]])
        {
            flag=true;
        }
    }
    
    if (flag==false)
    {
        UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectMake(sender.tableview.frame.size.width-80,sender.label.frame.origin.y-7, 0, 0)];
        onoff.tag=sender.cell.tag;
        [onoff addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
        [sender.cell addSubview:onoff];
    }

}

-(void)flip:(UISwitch*)sender
{
 
    NSLog(@"%ld",sender.tag);

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:userSettingsTableView])
    {
   
        
        if ((indexPath.section==0 && indexPath.row==0) || indexPath.section==1)
        {
            [[[[UIApplication sharedApplication] keyWindow] viewWithTag:112] setHidden:NO];

            [[self.view viewWithTag:112] setFrame:[[UIScreen mainScreen] bounds]];

            [[self.view viewWithTag:112] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    
            if (indexPath.section==0)
            {
                if (indexPath.row==0)
                {
                    popUpOptionsArray=nil;
                    popUpOptionsArray=[[NSMutableArray alloc]initWithObjects:@"15 min",@"30 min",@"40 min", nil];
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] forKey:@"selectedRowAndSection"];
                    [self.poUpTableView reloadData];
                }
                
            }
            if (indexPath.section==1)
            {
                if (indexPath.row==0)
                {
                    popUpOptionsArray=nil;
                    popUpOptionsArray=[[NSMutableArray alloc]initWithObjects:@"512 MB",@"1 GB",@"2 GB",@"3 GB", nil];
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] forKey:@"selectedRowAndSection"];
                    [self.poUpTableView reloadData];
                }
                if (indexPath.row==1)
                {
                    popUpOptionsArray=nil;
                    popUpOptionsArray=[[NSMutableArray alloc]initWithObjects:@"15 days",@"30 days",@"45 days", nil];
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] forKey:@"selectedRowAndSection"];
                    [self.poUpTableView reloadData];
                }
            }
      
        }
        
        if (indexPath.section==0 && indexPath.row==4)
        {
            
                abbreviationPopupView=  [[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+100, self.view.frame.size.width-40, 200) sender:self];
            [abbreviationPopupView addGestureRecognizer:tap1];
            abbreviationPopupView.tag=121;
                [[[UIApplication sharedApplication] keyWindow] addSubview:abbreviationPopupView];
           
        }
        if (indexPath.section==2 && indexPath.row==0)
        {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"] animated:YES completion:nil];
        }
    }
    
    else
    {
        UITableViewCell* selectedCell=   [tableView cellForRowAtIndexPath:indexPath];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"00"])
        {
            UILabel* timeLabel= [selectedCell viewWithTag:114];
            [[NSUserDefaults standardUserDefaults] setValue:timeLabel.text forKey:@"dictationTime"];
            
            UIButton* button = [radioButtonArray objectAtIndex:indexPath.row];
            [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
            for (int i=0; i<radioButtonArray.count; i++)
            {
                if (i==indexPath.row)
                {
                    UIButton* button = [radioButtonArray objectAtIndex:indexPath.row];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];

                }
                else
                {
                    UIButton* button = [radioButtonArray objectAtIndex:i];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];

                }
            }
          
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"10"])
        {
            UILabel* timeLabel= [selectedCell viewWithTag:114];
            [[NSUserDefaults standardUserDefaults] setValue:timeLabel.text forKey:@"lowStorageThreshold"];

            
            for (int i=0; i<radioButtonArray.count; i++)
            {
                if (i==indexPath.row)
                {
                    UIButton* button = [radioButtonArray objectAtIndex:indexPath.row];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    UIButton* button = [radioButtonArray objectAtIndex:i];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
                    
                }
            }
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRowAndSection"] isEqualToString:@"11"])
        {
            UILabel* timeLabel= [selectedCell viewWithTag:114];
            [[NSUserDefaults standardUserDefaults] setValue:timeLabel.text forKey:@"numberOfDaysForDeletedData"];
            
            for (int i=0; i<radioButtonArray.count; i++)
            {
                if (i==indexPath.row)
                {
                    UIButton* button = [radioButtonArray objectAtIndex:indexPath.row];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    UIButton* button = [radioButtonArray objectAtIndex:i];
                    [button setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
                    
                }
            }

        }
        [self performSelector:@selector(hideTableView) withObject:nil afterDelay:0.2];

    }
    

}

-(void)hideTableView
{
    radioButtonArray=nil;
    radioButtonArray=[[NSMutableArray alloc]init];
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:112] setHidden:YES];//
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.poUpTableView.superview != nil)
    {
        if ([touch.view isDescendantOfView:self.poUpTableView])
        {
            return NO;
        }
    }
//    if (abbreviationPopupView.superview != nil)
//    {
//        if ([touch.view isDescendantOfView:abbreviationPopupView])
//        {
//            return NO;
//        }
//    }
    return YES; // handle the touch
}

-(void)disMissPopView:(id)sender
{
   // [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"selectedRowAndSection"];
   // [poUpTableView reloadData];
    
    

    radioButtonArray=nil;
    radioButtonArray=[[NSMutableArray alloc]init];
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:112] setHidden:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:121] removeFromSuperview];

}

-(void)save:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:121] removeFromSuperview];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
