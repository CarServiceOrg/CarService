//
//  CSInsureAcknowledgeViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSInsureAcknowledgeViewController.h"

@interface CSInsureAcknowledgeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSInsureAcknowledgeViewController
@synthesize dataArray;

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
    
    //隐藏返回键
    self.navigationItem.hidesBackButton=YES;
    //返回按钮
    x=10; y=8; width=82/2.0+4; height=26;
    UIButton* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn setTitleColor:[UIColor colorWithRed:13/255.0 green:43/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    [backBtn release];

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
    
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame{
	UITableView *aTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    {
        self.dataArray=[NSMutableArray arrayWithObjects:
                        @"单保车损险的话，保险公司有一定比例的免赔范围",
                        @"车主必须自己掏出一部分的钱为事故买单",
                        @"买了不计免赔险的话，就可以让保险公司全额赔付了",
                        @"所以建议消费者再为爱车购买车险时",
                        nil];
    }
    
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(0, 25+40+10, 320, self.view.bounds.size.width-(25+40+10))];
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

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    float x, y, width, height;
    
    x=10; y=(40-14)/2.0; width=7; height=14;
    UIImageView* triangleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    triangleImageView.image=[UIImage imageNamed:@"baoxianzhishiku_sanjiao.png"];
    [cell.contentView addSubview:triangleImageView];
    [triangleImageView release];

    x=x+width+5; y=0; width=(320-x-10); height=40;
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textLabel setTag:1001];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    [textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.contentView addSubview:textLabel];
    [textLabel release];
        
    x=10; y=40-2; width=320-10*2; height=2;
    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineImageView.image=[UIImage imageNamed:@"baoxianzhishiku_line.png"];
    [cell.contentView addSubview:lineImageView];
    [lineImageView release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //添加视图
        [self createViewForcell:cell atRow:indexPath];
    }
    
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        UILabel* textLabel=(UILabel*)[cell.contentView viewWithTag:1001];
        if (textLabel) {
            textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
