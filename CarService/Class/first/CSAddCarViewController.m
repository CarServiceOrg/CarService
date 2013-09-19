//
//  CSAddCarViewController.m
//  CarService
//
//  Created by baidu on 13-9-20.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSAddCarViewController.h"
#import "TSMessage.h"

@interface CSAddCarViewController ()

@end

@implementation CSAddCarViewController

-(void)init_selfView
{
    float x, y, width, height;
    
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];
    
    x=0; y=0; width=320;
    if (Is_iPhone5) {
        height=1136/2.0;
    }else{
        height=960/2.0;
    }
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone5.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone4.png"]];
    }
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    //车牌号
    x=10; y=20; width=320-10*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"车牌号：" with_delegate:self];
    
    //车架号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"车架号：" with_delegate:self];
    
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
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"添加车辆";
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
                                           subtitle:NSLocalizedString(@"车架号不能为空！", nil)
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

    
    if (carSignStr!=nil && carStandStr!=nil) {
        NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:carSignStr, CSAddCarViewController_carSign, carStandStr, CSAddCarViewController_carStand, nil];
        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        NSMutableArray* array;
        if (alreadyAry) {
            BOOL flag=NO;
            for (NSDictionary* dict in alreadyAry) {
                NSString* carSign_dict=[dict objectForKey:CSAddCarViewController_carSign];
                NSString* carStand_dict=[dict objectForKey:CSAddCarViewController_carStand];
                if ([carSign_dict isEqualToString:carSignStr] && [carStand_dict isEqualToString:carStandStr]) {
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
        [array addObject:dict];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:CSAddCarViewController_carList];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
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
