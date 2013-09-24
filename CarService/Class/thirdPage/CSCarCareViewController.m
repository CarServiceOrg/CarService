//
//  CSCarCareViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCarCareViewController.h"
#import "CSShopRecommendViewController.h"
#import "CSCareRecordViewController.h"
#import "CSCareReferViewController.h"
#import "CSCareKnowledgeViewController.h"

@interface CSCarCareViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}


@end

@implementation CSCarCareViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.view sendSubviewToBack:bgImageView];
    [bgImageView release];
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame{
	UITableView *aTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [aTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[aTableView setSeparatorColor:[UIColor darkGrayColor]];
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
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.title=@"车辆保养";
    [self init_selfView];
    [self initSetUpTableView:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    float x, y, width, height;
    
    width=26/2.0; height=37/2.0; x=10; y=(45-height)/2.0;
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [imageView setTag:1001];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    x=x+width+10; y=10; width=120; height=20;
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textLabel setTag:1002];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    [textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview:textLabel];
    [textLabel release];
    
    width=12/2.0+3; height=24/2.0+4.5; x=CGRectGetWidth(cell.bounds)-20-width; y=(45-height)/2.0;
    UIImageView* triangleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    triangleImageView.image=[UIImage imageNamed:@"membercenter_arrow.png"];
    [cell.contentView addSubview:triangleImageView];
    [triangleImageView release];

    x=40; y=45-2; width=320; height=2;
    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineImageView.image=[UIImage imageNamed:@"black_bg.png"];
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
    
    UIImageView* imageView=(UIImageView*)[cell.contentView viewWithTag:1001];
    UILabel* textLabel=(UILabel*)[cell.contentView viewWithTag:1002];
    if (imageView && textLabel) {
        switch (indexPath.row) {
            case 0:
            {
                float x, y, width, height;
                width=26/2.0; height=37/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoyan_recommend.png"];
                textLabel.text=@"店铺推荐";
            }
                break;
            case 1:
            {
                float x, y, width, height;
                width=32/2.0; height=35/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoyang_acknowledge.png"];
                textLabel.text=@"保养常识";
            }
                break;
            case 2:
            {
                float x, y, width, height;
                width=32/2.0; height=33/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoyang_question.png"];
                textLabel.text=@"保养咨询";
            }
                break;
            case 3:
            {
                float x, y, width, height;
                width=33/2.0; height=33/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoyang_record.png"];
                textLabel.text=@"保养记录";
            }
                break;
            default:
                break;
        }
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tianjiacheliang_cell_bg.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:25]]autorelease];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self actionStart:indexPath.row];
}

-(void)actionStart:(int)index
{
    switch (index) {
        case 0:
        {
            CSShopRecommendViewController* ctrler=[[CSShopRecommendViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 1:
        {
            CSCareKnowledgeViewController* ctrler=[[CSCareKnowledgeViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 2:
        {
            CSCareReferViewController* ctrler=[[CSCareReferViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 3:
        {
            CSCareRecordViewController* ctrler=[[CSCareRecordViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        default:
            break;
    }
}

@end
