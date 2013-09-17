//
//  CSInsuranceViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSInsuranceViewController.h"
#import "BlockAlertView.h"
#import "CSInsureAcknowledgeViewController.h"

@interface CSInsuranceViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@end

@implementation CSInsuranceViewController

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
    self.title=@"车辆保险";
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
    
    width=44/2.0; height=35/2.0; x=10; y=(45-height)/2.0;
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [imageView setTag:1001];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    x=x+width; y=10; width=0; height=20;
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textLabel setTag:1002];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    [textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview:textLabel];
    [textLabel release];
    
    x=x+width+10; y=12; width=120;
    UILabel* detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [detailLabel setTag:1003];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [detailLabel setTextAlignment:UITextAlignmentLeft];
    [detailLabel setFont:[UIFont systemFontOfSize:12.0]];
    [detailLabel setTextColor:[UIColor grayColor]];
    [detailLabel setText:@"（电话咨询）"];
    [cell.contentView addSubview:detailLabel];
    [detailLabel release];
    
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
    UILabel* detailLabel=(UILabel*)[cell.contentView viewWithTag:1003];
    if (imageView && textLabel) {
        switch (indexPath.row) {
            case 0:
            {
                float x, y, width, height;
                width=27/2.0; height=35/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoxian_baofeiyusuan.png"];
                textLabel.text=@"保费预算";
                textLabel.frame=CGRectMake(CGRectGetMinX(textLabel.frame), CGRectGetMinY(textLabel.frame), 3+15*textLabel.text.length+3, CGRectGetHeight(textLabel.frame));
                detailLabel.frame=CGRectMake(CGRectGetMaxX(textLabel.frame), CGRectGetMinY(detailLabel.frame), CGRectGetWidth(detailLabel.frame), CGRectGetHeight(textLabel.frame));
            }
                break;
            case 1:
            {
                float x, y, width, height;
                width=28/2.0; height=34/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoxian_baoxianzhishiku.png"];
                textLabel.text=@"保险知识库";
                textLabel.frame=CGRectMake(CGRectGetMinX(textLabel.frame), CGRectGetMinY(textLabel.frame), 3+15*textLabel.text.length+3, CGRectGetHeight(textLabel.frame));
                detailLabel.hidden=YES;
            }
                break;
            case 2:
            {
                float x, y, width, height;
                width=35/2.0; height=37/2.0; x=10; y=(45-height)/2.0;
                imageView.frame=CGRectMake(x, y, width, height);
                imageView.image=[UIImage imageNamed:@"cheliangbaoxian_baoxianzixun.png"];
                textLabel.text=@"保险咨询";
                textLabel.frame=CGRectMake(CGRectGetMinX(textLabel.frame), CGRectGetMinY(textLabel.frame), 3+15*textLabel.text.length+3, CGRectGetHeight(textLabel.frame));
                detailLabel.frame=CGRectMake(CGRectGetMaxX(textLabel.frame), CGRectGetMinY(detailLabel.frame), CGRectGetWidth(detailLabel.frame), CGRectGetHeight(textLabel.frame));
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
    [self actionStart:indexPath.row];
}

-(void)actionStart:(int)index
{
    switch (index) {
        case 0:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"保费预算" message:@"是否电话呼叫咨询？"];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert addButtonWithTitle:@"呼叫" block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",TELEPHONE_BaoFeiYuSuan]]];
            }];
            [alert show];
        }
            break;
        case 1:
        {
            CSInsureAcknowledgeViewController* ctrler=[[CSInsureAcknowledgeViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 2:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"保险咨询" message:@"是否电话呼叫咨询？"];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert addButtonWithTitle:@"呼叫" block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",TELEPHONE_BaoXianZiXun]]];
            }];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

@end
