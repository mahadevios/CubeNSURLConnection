//
//  PopUpCustomView.m
//  Cube
//
//  Created by mac on 06/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "PopUpCustomView.h"

@implementation PopUpCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView*)initWithFrame:(CGRect)frame andSubViews:(NSArray*)subViewNamesArray :(id)sender
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
   overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=111;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];

    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 0, 0)];
        for (int i=0; i<subViewNamesArray.count; i++)
        {
        
        userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(20, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, 100, 20)];
        [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
        [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
        NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
           selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
        [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
        
        //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
        [self addSubview:userSettingsButton];
//            selectSetting
        }
        [overlay addSubview:self];
    }
    return overlay;
}

-(UIView*)initWithFrame:(CGRect)frame  sender:(id)sender
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(disMissPopView:)];
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=121;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIView* borderView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+10, frame.origin.y+10, frame.size.width-20, frame.size.height-60)];
    borderView.layer.borderWidth=1.0f;
    borderView.layer.cornerRadius=7.0f;
    borderView.layer.borderColor=[UIColor grayColor].CGColor;

    if (self)
    {
        UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, borderView.frame.size.width-20, 20)];
        label1.text=@"Set your recordings abbreviation";
        label1.font=[UIFont systemFontOfSize:14];
        UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(15, label1.frame.origin.y+label1.frame.size.height+10, borderView.frame.size.width-20, 20)];
        label2.text=@"(Max 5 characters)";
        label2.font=[UIFont systemFontOfSize:14];

        UITextField* abbreviationTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, label2.frame.origin.y+label2.frame.size.height+10, borderView.frame.size.width-30, 40)];
        abbreviationTextField.layer.borderWidth=1.0f;
        abbreviationTextField.layer.cornerRadius=7.0f;
        abbreviationTextField.layer.borderColor=[UIColor grayColor].CGColor;
        
        UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, frame.size.height-36, 80, 20)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [cancelButton addTarget:sender action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, frame.size.height-36, 80, 20)];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];

        [saveButton addTarget:sender action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:cancelButton];
        [self addSubview:saveButton];
        [borderView addSubview:label1];
        [borderView addSubview:label2];
        [borderView addSubview:abbreviationTextField];
    }
    [overlay addSubview:self];
    [overlay addSubview:borderView];
    return overlay;


}

@end
