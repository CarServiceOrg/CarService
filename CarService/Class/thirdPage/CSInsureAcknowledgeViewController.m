//
//  CSInsureAcknowledgeViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSInsureAcknowledgeViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "TSMessage.h"
#import "CSInsuranceDetailViewController.h"

@interface CSInsureAcknowledgeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSInsureAcknowledgeViewController
@synthesize dataArray;

#define CSInsureAcknowledgeViewController_text_font 12

#define CSInsureAcknowledgeViewController_title_width (320-10*2-10-10)
#define CSInsureAcknowledgeViewController_content_width (320-10*2)

#define CSInsureAcknowledgeViewController_text_height 20

#define CSInsureAcknowledgeViewController_key_title     @"title"
#define CSInsureAcknowledgeViewController_key_content   @"content"

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

    //搜索输入框
    x=10; y=25; width=320-10-(105/2.0+10)-10-10; height=35;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"请输入关键字" with_delegate:self];
    {
        UITextField* textField=(UITextField*)[self.view viewWithTag:101];
        if (textField) {
            textField.background=[UIImage imageWithCGImage:[[UIImage imageNamed:@"baoxianzhishiku_sousuokuang.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15].CGImage scale:2.0 orientation:UIImageOrientationUp];
            [textField setTextColor:[UIColor blackColor]];
            UIView* holderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(textField.bounds))];
            [holderView setBackgroundColor:[UIColor clearColor]];
            textField.leftViewMode=UITextFieldViewModeAlways;
            textField.leftView=holderView;
            [holderView release];
        }
    }
    
    //搜索
    x=x+width+10; y=y+2; width=105/2.0+10; height=30;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [queryBtn setTitle:@"搜 索" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"baoxianzhishiku_sousuo.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"baoxianzhishiku_sousuo_press.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    [queryBtn release];
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)queryBtnClick:(id)sender
{
    UITextField* textField=(UITextField*)[self.view viewWithTag:101];
    if (textField) {
        [textField resignFirstResponder];
    }
    
    [self.dataArray removeAllObjects];
    UITableView* tableView=(UITableView*)[self.view viewWithTag:102];
    if (tableView) {
        [tableView reloadData];
    }
    [self startHttpRequest];
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame{
	UITableView *aTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [aTableView setTag:102];
    [aTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[aTableView setSeparatorColor:[UIColor clearColor]];
	[aTableView setBackgroundColor:[UIColor clearColor]];
	[aTableView setShowsVerticalScrollIndicator:YES];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
	[self.view addSubview:aTableView];
    [aTableView release];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
	aTableView.tableFooterView = foot;
	[foot release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"保险知识库";
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(0, 25+40+10, 320, self.view.bounds.size.height-40-55-(25+40+10)-10)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.dataArray=nil;
    [super dealloc];
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_InsuranceKnowledge];
    });
}

//保险知识库
-(void)request_InsuranceKnowledge
{
    NSString* searchStr=@"";
    UITextField* textField=(UITextField*)[self.view viewWithTag:101];
    if (textField) {
        searchStr=textField.text;
    }
    
    //搜索内容无 则表示全部内容
    //if (searchStr.length==0) {
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [ApplicationPublic showMessage:self with_title:@"提示" with_detail:@"请输入搜索关键字！" with_type:TSMessageNotificationTypeWarning with_Duration:1.5];
    //    });
    //    return;
    //}
    
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"safeknow", @"action", searchStr, @"search", nil];
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->CSInsureAcknowledgeViewController-->request_InsuranceKnowledge-->urlStr:%@",urlStr);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CustomLog(@"<<Chao-->CSInsureAcknowledgeViewController-->request_InsuranceKnowledge-->testResponseString:%@",testResponseString);
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSInsureAcknowledgeViewController-->request_InsuranceKnowledge-->requestDic:%@",requestDic);
        if ([requestDic objectForKey:@"status"]) {
            if ([[requestDic objectForKey:@"status"] intValue]==1) {
                [ApplicationPublic showMessage:self with_title:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败！", nil) with_type:TSMessageNotificationTypeError with_Duration:2.0];
                return;
            }else if ([[requestDic objectForKey:@"status"] intValue]==0){
                if ([requestDic objectForKey:@"list"]) {
                    self.dataArray=[requestDic objectForKey:@"list"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITableView* tableView=(UITableView*)[self.view viewWithTag:102];
                        if (tableView) {
                            [tableView reloadData];
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

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    UIImageView* questionImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [questionImageView setTag:1001];
    questionImageView.image=[UIImage imageNamed:@"baoxianzhishiku_sanjiao.png"];
    [cell.contentView addSubview:questionImageView];
    [questionImageView release];
    
    //问题
    [self setUpLabel:cell.contentView with_tag:1002 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
        
    //答案
    [self setUpLabel:cell.contentView with_tag:1003 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];

    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [lineImageView setTag:1004];
    lineImageView.image=[UIImage imageNamed:@"baoxianzhishiku_line.png"];
    [cell.contentView addSubview:lineImageView];
    [lineImageView release];
}

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [aLabel setTextColor:[UIColor grayColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=UILineBreakModeWordWrap;
    [superView addSubview:aLabel];
    [aLabel release];
}

-(float)heigtForString:(NSString*)string with_labelwidth:(float)labelWidth
{
    float height=CSInsureAcknowledgeViewController_text_height;
    CGSize fontSize;
    fontSize=[string sizeWithFont:[UIFont systemFontOfSize:CSInsureAcknowledgeViewController_text_font]];
    int remainder = (int)fontSize.width%(int)labelWidth;
    int line=(int)fontSize.width/(int)labelWidth;
    if (remainder!=0) {
        line=line+1;
    }
    float temp=(CSInsureAcknowledgeViewController_text_font+4)*line;
    if (temp>height) {
        height=temp;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //添加视图
        [self createViewForcell:cell atRow:indexPath];
    }

    if (self.dataArray && [self.dataArray count]>indexPath.row)
    {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* title=[dict objectForKey:@"title"];
        NSString* content=[dict objectForKey:@"content"];
        
        float x, y, width, height;

        //三角
        UIImageView* questionImgView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (questionImgView) {
            x=10; y=10; width=7; height=14;
            questionImgView.frame=CGRectMake(x, y, width, height);
        }
        
        //标题
        UILabel* titleLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (titleLabel) {
            titleLabel.text=title;
            x=x+width+10; width=CSInsureAcknowledgeViewController_title_width;
            height=[self heigtForString:title with_labelwidth:width];
            titleLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //内容
        UILabel* contenLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (contenLabel) {
            contenLabel.text=content;
            x=10; y=y+height; width=CSInsureAcknowledgeViewController_content_width;
            height=[self heigtForString:content with_labelwidth:width];
            contenLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //line
        UIImageView* lineImgView=(UIImageView*)[cell.contentView viewWithTag:1004];
        if (lineImgView) {
            x=10; height=2;; width=320-10*2; y=[self heightForCell:indexPath]-height;
            lineImgView.frame=CGRectMake(x, y, width, height);
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)heightForCell:(NSIndexPath*)indexPath
{
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* title=[dict objectForKey:@"title"];
        NSString* content=[dict objectForKey:@"content"];
        
        float temp =10+[self heigtForString:title with_labelwidth:CSInsureAcknowledgeViewController_title_width]
                    +[self heigtForString:content with_labelwidth:CSInsureAcknowledgeViewController_content_width]
                    +10;
        if (temp>CSInsureAcknowledgeViewController_text_height*2) {
            return temp;
        }else{
            return CSInsureAcknowledgeViewController_text_height*2;
        }
    }
    return CSInsureAcknowledgeViewController_text_height*2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCell:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
    if (dict && [dict objectForKey:@"id"]) {
        CSInsuranceDetailViewController* ctrler=[[CSInsuranceDetailViewController alloc] initController:self.navigationItem.title with_id:[dict objectForKey:@"id"]];
        [self.navigationController pushViewController:ctrler animated:YES];
        [ctrler release];
    }
}

#pragma mark - UITextFieldDelegate
//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
