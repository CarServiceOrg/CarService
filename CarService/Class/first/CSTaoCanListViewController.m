//
//  CSTaoCanListViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSTaoCanListViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "CSTaoCanDetailViewController.h"

static float CSTaoCanListViewController_title_font=12.0;

@interface CSTaoCanListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property(nonatomic,retain)NSMutableArray* m_dataArray;

@end

@implementation CSTaoCanListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment fontSize:(float)fontSize
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [superView addSubview:aLabel];
    [aLabel release];
}

-(void)initSelfView{
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectInset(frame, 5, 5)];
    [scrollView setTag:101];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    {
        float x, y, width, height;
        
        //套餐名称
        x=0; y=0; width=scrollView.frame.size.width; height=30;
        [self setUpLabel:scrollView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"套餐名称：" with_Alignment:NSTextAlignmentLeft fontSize:16.0];
        
        //截止日期
        y=y+height;
        [self setUpLabel:scrollView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"截止日期：" with_Alignment:NSTextAlignmentLeft fontSize:16.0];

        //套餐价格
        y=y+height;
        [self setUpLabel:scrollView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"套餐价格：" with_Alignment:NSTextAlignmentLeft fontSize:16.0];

        y=y+height+5;
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, scrollView.frame.size.height-y)];
        [imageView setTag:1004];
        [imageView setBackgroundColor:[UIColor lightGrayColor]];
        [scrollView release];
    }
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame{
    //表格背景 605*683
    frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
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
    
    _tableView=aTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineBg:self.view];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"会员套餐" withTarget:self with_action:@selector(backBtnClicked:)];
    [self initSetUpTableView:self.view.bounds];
    
    //网络获取数据
    [self startHttpRequest];
}

-(void)backBtnClicked:(UIButton*)sender
{
    if (self.m_isPresentBool) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.m_dataArray=nil;
    [super dealloc];
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_list];
    });
}

//
-(void)request_list
{
    NSString *urlStr = [URL_mall_list stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
       
        NSDictionary *requestDic =[[request responseString] JSONValue];
        MyNSLog(@"requestDic:%@",requestDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([requestDic objectForKey:@"status"]) {
                int status=[[requestDic objectForKey:@"status"] intValue];
                if (status==0) {
                    if ([requestDic objectForKey:@"list"]) {
                        self.m_dataArray=[requestDic objectForKey:@"list"];
                        
                        //更新
                        [_tableView reloadData];
                    }
                }else{
                    [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败！", nil) with_type:TSMessageNotificationTypeError];
                }
            }
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeError];
        });
    }];
    [request startAsynchronous];
}

-(void)showMessage:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type
{
    [TSMessage showNotificationInViewController:self
                                          title:titleStr
                                       subtitle:detailStr
                                          image:nil
                                           type:type
                                       duration:4.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_dataArray count];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    float x, y, width, height;
    //图片
    x=10; y=10; width=80; height=80;
    UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [aImageView setTag:1001];
    [cell.contentView addSubview:aImageView];
    [aImageView release];
    {
        aImageView.layer.borderWidth=2.0;
        aImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        aImageView.backgroundColor=[UIColor lightGrayColor];
    }
    
    //名称
    x=x+width+10; width=_tableView.frame.size.width-x-5; height=22;
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [titleLabel setTag:1002];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont systemFontOfSize:CSTaoCanListViewController_title_font]];
    [titleLabel setTextColor:[UIColor blackColor]];
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    //价格
    y=y+height;
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [addressLabel setTag:1003];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [addressLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:CSTaoCanListViewController_title_font]];
    [addressLabel setTextColor:[UIColor blackColor]];
    addressLabel.numberOfLines=0;
    addressLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:addressLabel];
    [addressLabel release];
    
    //有效日期
    y=y+height;
    UILabel* phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [phoneLabel setTag:1004];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setFont:[UIFont systemFontOfSize:CSTaoCanListViewController_title_font]];
    [phoneLabel setTextColor:[UIColor blackColor]];
    phoneLabel.numberOfLines=0;
    phoneLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:phoneLabel];
    [phoneLabel release];
    
    //套餐详情
    y=y+height;
    UILabel* detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 52, height)];
    [detailLabel setTag:1006];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [detailLabel setTextAlignment:NSTextAlignmentRight];
    [detailLabel setFont:[UIFont systemFontOfSize:CSTaoCanListViewController_title_font]];
    [detailLabel setTextColor:[UIColor blackColor]];
    detailLabel.numberOfLines=0;
    detailLabel.lineBreakMode=UILineBreakModeWordWrap;
    detailLabel.text=@"详情:";
    [cell.contentView addSubview:detailLabel];
    [detailLabel release];

    //[点击查看详情]
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTag:1005];
    [queryBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [queryBtn setTitle:@"[点击查看详情]" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:queryBtn];
    [queryBtn release];
    
    //taglabel
    UILabel* taglabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [taglabel setTag:2001];
    [cell.contentView addSubview:taglabel];
    [taglabel release];
}

-(void)phoneBtnClick:(UIButton*)sender
{
    UIView* superView=[sender superview];
    if (superView) {
        UILabel* taglabel=(UILabel*)[superView viewWithTag:2001];
        if (taglabel) {
            int index=[taglabel.text intValue];
            if (index<[self.m_dataArray count]) {
                NSDictionary* dict=[self.m_dataArray objectAtIndex:index];
                CSTaoCanDetailViewController* ctrler=[[CSTaoCanDetailViewController alloc] initWithNibName:dict];
                [self.navigationController pushViewController:ctrler animated:YES];
                [ctrler release];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //添加视图
        [self createViewForcell:cell atRow:indexPath];
    }

    if (self.m_dataArray && [self.m_dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.m_dataArray objectAtIndex:indexPath.row];
        NSString* url=[dict objectForKey:@"img"];
        NSString* mallname=[dict objectForKey:@"mallname"];
        NSString* price=[dict objectForKey:@"price"];
        NSString* expiration_date=[dict objectForKey:@"expiration_date"];
        
        //tag
        UILabel* taglabel=(UILabel*)[cell.contentView viewWithTag:2001];
        if (taglabel) {
            taglabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
        }
        
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"] options:SDWebImageRefreshCached];
        }
        
        //名称
        UILabel* titleLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (titleLabel) {
            titleLabel.text=[NSString stringWithFormat:@"套餐名称：%@",mallname];
        }
        
        //
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (addressLabel) {
            addressLabel.text=[NSString stringWithFormat:@"套餐价格：%@",price];
        }
        
        //
        UILabel* phoneLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (phoneLabel) {
            phoneLabel.text=[NSString stringWithFormat:@"有效日期：%@",expiration_date];
        }
    }

    NSInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
    NSInteger row = indexPath.row;
    if (rowCount==1) {
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_xialakuang.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_xialakuang.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
    }
    else if(rowCount>=2){
        if (row == 0) {
            cell.backgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaogetoubu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaogetoubu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
        }else if (row == rowCount-1){
            cell.backgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_dibu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_dibu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
        }else{
            cell.backgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]]autorelease];
        }
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
