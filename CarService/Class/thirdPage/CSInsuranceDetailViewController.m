//
//  CSInsuranceDetailViewController.m
//  CarService
//
//  Created by baidu on 13-9-20.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSInsuranceDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "TSMessage.h"

@interface CSInsuranceDetailViewController ()
{
    
}

@property(nonatomic,retain) NSString* m_idStr;

@end

@implementation CSInsuranceDetailViewController
@synthesize m_idStr;

#define CSInsuranceDetailViewController_font_title 14.0
#define CSInsuranceDetailViewController_font_text 13.0

-(id)initwithID:(NSString*)idStr
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.m_idStr=idStr;
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
    //返回按钮
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];
    
    //标题
    [self setUpAttributeLabel:self.view with_frame:CGRectZero with_tag:101 with_firstLineIndent:0];
    
    //详情文本
    UITextView* detailTextView=[[UITextView alloc] initWithFrame:CGRectZero];
    [detailTextView setTag:102];
    [detailTextView setBackgroundColor:[UIColor clearColor]];
    [detailTextView setFont:[UIFont systemFontOfSize:13.0]];
    [detailTextView setEditable:NO];
    [self.view addSubview:detailTextView];
    [detailTextView release];
}

-(void)setUpAttributeLabel:(UIView*)superView  with_frame:(CGRect)frame with_tag:(int)tag with_firstLineIndent:(float)firstLineIndent
{
    //详情文本
    TTTAttributedLabel* summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:frame];
    if (tag>0) {
        [summaryLabel setTag:tag];
    }
    [summaryLabel setBackgroundColor:[UIColor clearColor]];
    summaryLabel.textColor = [UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1];
    summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
    summaryLabel.numberOfLines = 0;
    summaryLabel.textAlignment=NSTextAlignmentLeft;
    summaryLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    summaryLabel.firstLineIndent=firstLineIndent;
    summaryLabel.verticalAlignment=TTTAttributedLabelVerticalAlignmentCenter;
    summaryLabel.leading=8.0;
    [superView addSubview:summaryLabel];
    [summaryLabel release];
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"详情";
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];
    [self init_selfView];
    //发起网络请求
    [self startHttpRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.m_idStr=nil;
    [super dealloc];
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_InsuranceDetail];
    });
}

//保险知识库
-(void)request_InsuranceDetail
{
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"show_safeknow", @"action", self.m_idStr, @"id", nil];
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->CSInsureAcknowledgeViewController-->request_InsuranceKnowledge-->urlStr:%@",urlStr);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        //NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //CustomLog(@"<<Chao-->CSInsuranceDetailViewController-->testResponseString:%@",testResponseString);
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSInsuranceDetailViewController-->requestDic:%@",requestDic);
        if ([requestDic objectForKey:@"status"]) {
            if ([[requestDic objectForKey:@"status"] intValue]==1) {
                [ApplicationPublic showMessage:self with_title:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败！", nil) with_type:TSMessageNotificationTypeError with_Duration:2.0];
                return;
            }else if ([[requestDic objectForKey:@"status"] intValue]==0){
                if ([requestDic objectForKey:@"list"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary* dict=[requestDic objectForKey:@"list"];
                        NSString* title=[dict objectForKey:@"title"];
                        NSString* content=[dict objectForKey:@"content"];
                        
                        float x, y, width, height;
                        TTTAttributedLabel* summaryLabel=(TTTAttributedLabel*)[self.view viewWithTag:101];
                        if (summaryLabel) {
                            x=10, y=15, width=self.view.bounds.size.width-x*2,
                            height=[self heigtForString:title with_height:30 with_labelWidth:width with_fontSize:14.0 with_isBold:YES];
                            [summaryLabel setFrame:CGRectMake(x, y, width, height)];
                            [summaryLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
                            [summaryLabel setText:title];
                        }
                        
                        UITextView* detailTextView=(UITextView*)[self.view viewWithTag:102];
                        if (detailTextView) {
                            x=10, y=y+height+10, width=self.view.bounds.size.width-x*2,
                            height=self.view.bounds.size.height-(55+40)-y-10;
                            [detailTextView setFrame:CGRectMake(x, y, width, height)];
                            [detailTextView setText:content];
                        }
                        
                    });
                }
            }
        }
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationPublic showMessage:self with_title:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeWarning with_Duration:2.0];
        });
    }];
    [request startAsynchronous];
}


-(float)heigtForString:(NSString*)string with_height:(float)height with_labelWidth:(float)labelWidth with_fontSize:(float)fontsize with_isBold:(BOOL)isBold
{
    CGSize strSize;
    UIFont* font;
    if (isBold) {
        font=[UIFont boldSystemFontOfSize:fontsize];
    }else{
        font=[UIFont systemFontOfSize:fontsize];
    }
    strSize=[string sizeWithFont:font];
    int remainder = (int)strSize.width%(int)labelWidth;
    int line=(int)strSize.width/(int)labelWidth;
    if (remainder!=0) {
        line=line+1;
    }
    float temp=(fontsize+4)*line;
    if (temp>height) {
        height=temp;
    }
    return height;
}

@end
