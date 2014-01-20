//
//  CSAddCarViewController.m
//  CarService
//
//  Created by baidu on 13-9-20.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSAddCarViewController.h"
#import "TSMessage.h"
#import "ActionSheetDatePicker.h"

@interface CSAddCarViewController ()

@end

@implementation CSAddCarViewController

-(void)init_selfView
{
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    float x, y, width, height;
    
    //车牌号
    x=frame.origin.x+5; y=frame.origin.y+5; width=frame.size.width-5*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"车牌号：" with_delegate:self];
    
    //车架号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"发动机号：" with_delegate:self];
    
    //车架号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:103 with_placeHolder:@"车辆初次登记日期：" with_delegate:self];

    //查询
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+30; height=48/2.0+10;
    UIButton* doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [doneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [ApplicationPublic selfDefineBg:self.view];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"添加车辆" withTarget:self with_action:@selector(backBtnClick:)];
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnClick:(id)sender
{
    NSString* carSignStr=nil;
    UITextField* sign=(UITextField*)[self.view viewWithTag:101];
    if (sign) {
        carSignStr=sign.text;
    }
    
    NSString* carStandStr=nil;
    UITextField* stand=(UITextField*)[self.view viewWithTag:102];
    if (stand) {
        carStandStr=stand.text;
    }
    
    NSString* carDateStr=nil;
    UITextField* date=(UITextField*)[self.view viewWithTag:103];
    if (date) {
        carDateStr=date.text;
    }

    if ([carSignStr length]==0) {
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"错误", nil)
                                           subtitle:NSLocalizedString(@"车牌号不能为空！", nil)
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:2.0
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                                canBeDismisedByUser:YES];
        return;
    }
    
    if ([carStandStr length]==0) {
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"错误", nil)
                                           subtitle:NSLocalizedString(@"发动机号不能为空！", nil)
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:2.0
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                                canBeDismisedByUser:YES];
        return;
    }

    if ([carDateStr length]==0) {
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"错误", nil)
                                           subtitle:NSLocalizedString(@"请选择车辆初次登记日期！", nil)
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:2.0
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                                canBeDismisedByUser:YES];
        return;
    }
    
    if (carSignStr!=nil && carStandStr!=nil && carDateStr!=nil) {
        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        NSMutableArray* array;
        if (alreadyAry) {
            BOOL flag=NO;
            for (NSDictionary* dict in alreadyAry) {
                NSString* carSign_dict=[dict objectForKey:CSAddCarViewController_carSign];
                NSString* carStand_dict=[dict objectForKey:CSAddCarViewController_carStand];
                NSString* carDate_dict=[dict objectForKey:CSAddCarViewController_carDate];

                if ([carSign_dict isEqualToString:carSignStr] && [carStand_dict isEqualToString:carStandStr] && [carDate_dict isEqualToString:carDateStr]) {
                    flag=YES;
                    break;
                }else{
                    
                }
            }            
            
            if (flag) {
                //已经存在 则提示
                [TSMessage showNotificationInViewController:self
                                                      title:NSLocalizedString(@"提示", nil)
                                                   subtitle:NSLocalizedString(@"此记录已经存在，无需重复添加！", nil)
                                                      image:nil
                                                       type:TSMessageNotificationTypeWarning
                                                   duration:2.0
                                                   callback:nil
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionTop
                                        canBeDismisedByUser:YES];

                return;
            }else{
                array=[NSMutableArray arrayWithArray:alreadyAry];
            }
        }else{
            array=[NSMutableArray arrayWithCapacity:1];
        }
        
        NSDictionary* dictNew=[NSDictionary dictionaryWithObjectsAndKeys:
                               carSignStr, CSAddCarViewController_carSign,
                               carStandStr, CSAddCarViewController_carStand,
                               carDateStr, CSAddCarViewController_carDate,
                               nil];
        [array addObject:dictNew];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:CSAddCarViewController_carList];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
// 选择查询日期
-(void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (selectedDate!=nil && element!=nil) {
        UITextField* textField = (UITextField*)element;
        if (textField) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString* formatStr=[formatter stringFromDate:selectedDate];
            [formatter release];
            [textField setText:formatStr];
        }
    }
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==103)
    {
        [textField resignFirstResponder];
        [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
        return NO;
    }
    
    return YES;
}

//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    if ([aTextField isFirstResponder] || [bTextField isFirstResponder]) {
        [aTextField resignFirstResponder];
        [bTextField resignFirstResponder];
    }
}

@end
