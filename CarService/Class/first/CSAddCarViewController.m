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
#import "ActionSheetStringPicker.h"
#import "MBProgressHUD.h"

@interface CSAddCarViewController ()<UITextFieldDelegate, MBProgressHUDDelegate>
{
    
}

@property(readonly,assign)MBProgressHUD *alertView;
@property(nonatomic,retain)NSArray* m_dataArray;
@property(nonatomic,assign)int m_selectedIndex;

@end

@implementation CSAddCarViewController
@synthesize alertView;

-(void)init_selfView
{
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    float x, y, width, height;
    
    //选择省份
    x=frame.origin.x+5; y=frame.origin.y+5; width=frame.size.width-5*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:100 with_placeHolder:@"选择省份" with_delegate:self];
    {
        UITextField* aField=(UITextField*)[self.view viewWithTag:100];
        if (aField) {
            [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaogetoubu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
            [aField setEnabled:YES];
            [ApplicationPublic setLeftView:aField text:@"选择省份：" flag:YES fontSize:15.0];
        }
    }
    
    //车牌号
    y=y+height+15;
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CarCityList" ofType:@"plist"];
    self.m_dataArray=[NSArray arrayWithContentsOfFile:filePath];
    self.m_selectedIndex=-1;

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
    //省份
    NSString* cityStr=nil;
    NSString* lsprefix=nil;
    if (self.m_selectedIndex!=-1) {
        UITextField* cityField=(UITextField*)[self.view viewWithTag:100];
        if (cityField) {
            cityStr=cityField.text;

            if (self.m_selectedIndex<[self.m_dataArray count]) {
                NSDictionary* dict=[self.m_dataArray objectAtIndex:self.m_selectedIndex];
                if ([dict objectForKey:@"lsprefix"]) {
                    lsprefix=[NSString stringWithFormat:@"%@",[dict objectForKey:@"lsprefix"]];
                }
            }
        }
    }
    
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

    if ([cityStr length]==0  || [lsprefix length]==0) {
        [TSMessage showNotificationInViewController:self
                                              title:NSLocalizedString(@"错误", nil)
                                           subtitle:NSLocalizedString(@"不请选择省份！", nil)
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
    
    if (carSignStr!=nil && carStandStr!=nil && carDateStr!=nil && cityStr!=nil && lsprefix!=nil) {
        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        NSMutableArray* array;
        if (alreadyAry) {
            BOOL flag=NO;
            for (NSDictionary* dict in alreadyAry) {
                NSString* carSign_dict=[dict objectForKey:CSAddCarViewController_carSign];
                NSString* carStand_dict=[dict objectForKey:CSAddCarViewController_carStand];
                NSString* carDate_dict=[dict objectForKey:CSAddCarViewController_carDate];
                NSString* carCity_dict=[dict objectForKey:CSAddCarViewController_carCity];
                NSString* carLsprefix_dict=[dict objectForKey:CSAddCarViewController_carLsprefix];

                if ([carSign_dict isEqualToString:carSignStr] && [carStand_dict isEqualToString:carStandStr] && [carDate_dict isEqualToString:carDateStr] && [carCity_dict isEqualToString:cityStr] && [carLsprefix_dict isEqualToString:lsprefix]) {
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
                               cityStr,CSAddCarViewController_carCity,
                               lsprefix,CSAddCarViewController_carLsprefix,
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
    if (textField.tag==100) {
        {
            {
                self.alertView.mode = MBProgressHUDModeText;
                self.alertView.color=[UIColor darkGrayColor];
                self.alertView.labelText = NSLocalizedString(@"加载中...", nil);
                [self.alertView show:YES];
            }
            
            //获取列表
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alertView hide:YES];
                    if ([self.m_dataArray count]==0) {
                        [ApplicationPublic showMessage:self with_title:@"错误" with_detail:@"加载数据失败！" with_type:TSMessageNotificationTypeError with_Duration:2.0];
                    }else{
                        //可选列表
                        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                            if (textField) {
                                self.m_selectedIndex=selectedIndex;
                                textField.text=[NSString stringWithFormat:@"%@",(NSString*)selectedValue];
                                {
                                    UITextField* carFiled=(UITextField*)[self.view viewWithTag:101];
                                    if (carFiled) {
                                        UIView* leftView=carFiled.leftView;
                                        if (leftView) {
                                            UIImageView* imageView=(UIImageView*)[leftView viewWithTag:1001];
                                            if (imageView) {
                                                UILabel* alabel=(UILabel*)[imageView viewWithTag:10001];
                                                if (alabel) {
                                                    if (selectedIndex<[self.m_dataArray count]) {
                                                        NSDictionary* dict=[self.m_dataArray objectAtIndex:selectedIndex];
                                                        if ([dict objectForKey:@"lsprefix"]) {
                                                            alabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"lsprefix"]];
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        };
                        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
                            
                        };
                        NSInteger selectedIndex=0;
                        NSMutableArray* strArray=[NSMutableArray arrayWithCapacity:3];
                        for (NSDictionary* dict in self.m_dataArray) {
                            if ([dict objectForKey:@"city"]) {
                                [strArray addObject:[dict objectForKey:@"city"]];
                            }
                        }
                        [ActionSheetStringPicker showPickerWithTitle:@"选择地区" rows:strArray initialSelection:selectedIndex
                                                           doneBlock:done cancelBlock:cancel origin:textField];
                    }
                });
                
            });
            
            return NO;
        }
    }else if (textField.tag==103)
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
