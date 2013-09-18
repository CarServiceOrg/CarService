//
//  CSDelegateBookViewController.m
//  CarService
//
//  Created by baidu on 13-9-18.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSDelegateBookViewController.h"
#import "GCPlaceholderTextView.h"
#import "ActionSheetDatePicker.h"

@interface CSDelegateBookViewController ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation CSDelegateBookViewController

-(id)initWithBookType:(CSDelegateServiceType) type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _type=type;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_selfView
{
    float x, y, width, height;
    
    //返回按钮
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
    
    NSString* firstHolderStr=@"";
    NSString* secondtHolderStr=@"";
    NSString* thirdHolderStr=@"";
    switch (_type) {
        case CSDelegateServiceType_wash:
        {
            self.navigationItem.title=@"我要洗车";
            firstHolderStr=@"预约时间：";
            secondtHolderStr=@"地点";
            thirdHolderStr=@"备注：";
        }
            break;
        case CSDelegateServiceType_check:
        {
            self.navigationItem.title=@"我要验车";
            firstHolderStr=@"时间：";
            secondtHolderStr=@"地点";
            thirdHolderStr=@"备注：";

        }
            break;
        case CSDelegateServiceType_fix:
        {
            self.navigationItem.title=@"我要修车";
            firstHolderStr=@"预约时间：";
            secondtHolderStr=@"地点";
            thirdHolderStr=@"备注：";
        }
            break;
        case CSDelegateServiceType_sale:
        {
            self.navigationItem.title=@"我要卖车";
            firstHolderStr=@"车型：";
            secondtHolderStr=@"电话";
            thirdHolderStr=@"备注：";
        }
            break;
        default:
            break;
    }
    
    //车牌号
    x=10; y=20; width=320-10*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:firstHolderStr with_delegate:self];
    
    //发动机号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:secondtHolderStr with_delegate:self];

    y=y+height+15; height=80;
    {
        UIImageView* textViewBg=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [textViewBg setBackgroundColor:[UIColor clearColor]];
        [textViewBg setImage:[[UIImage imageNamed:@"black_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self.view addSubview:textViewBg];
        [textViewBg release];
    }    
    GCPlaceholderTextView* textView=[[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textView setTag:103];
    [textView setDelegate:self];
    [textView setBackgroundColor:[UIColor clearColor]];
    textView.placeholderColor=[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    textView.placeholder=thirdHolderStr;
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setTextColor:[UIColor whiteColor]];
    [self.view addSubview:textView];
    [textView release];
    
    //查询
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+30; height=48/2.0+10;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    [queryBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
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

-(void)queryBtnClick:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate

// 选择查询日期
-(void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (selectedDate!=nil && element!=nil) {
        UITextField* textField = (UITextField*)element;
        if (textField) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString* formatStr=[formatter stringFromDate:selectedDate];
            [formatter release];
            [textField setText:formatStr];
        }
    }
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==101) {
        switch (_type) {
            case CSDelegateServiceType_wash:
            case CSDelegateServiceType_check:
            case CSDelegateServiceType_fix:
            {
                [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
                return NO;
            }
                break;
            case CSDelegateServiceType_sale:
            {
            }
                break;
            default:
                break;
        }
    }
    
    return YES;
}

//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, Is_iPhone5?0:-120, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    GCPlaceholderTextView* textView=(GCPlaceholderTextView*)[self.view viewWithTag:103];
    if ([aTextField isFirstResponder] || [bTextField isFirstResponder] || [textView isFirstResponder]) {
        [aTextField resignFirstResponder];
        [bTextField resignFirstResponder];
        [textView resignFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

@end
