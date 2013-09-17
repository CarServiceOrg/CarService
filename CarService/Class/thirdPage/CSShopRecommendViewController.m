//
//  CSShopRecommendViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSShopRecommendViewController.h"
#import "UIImage_Extensions.h"
#import "ActionSheetStringPicker.h"

@interface CSShopRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSShopRecommendViewController
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
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame
{
	UITableView *aTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [aTableView setTag:101];
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
    
    UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setTag:102];
    [headerView setBackgroundColor:[UIColor clearColor]];
    {
        UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:headerView.bounds];
        [bgImgView setImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"dianputuijian_title_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 10)].CGImage scale:2.0 orientation:UIImageOrientationUp]];
        [headerView addSubview:bgImgView];
        [bgImgView release];
        
        //定位图标
        float x, y, width, height;
        width=17/2.0+2.5; height=23/2.0+4.5; x=10; y=(CGRectGetHeight(headerView.bounds)-height)/2.0;
        UIImageView* locationImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [locationImgView setImage:[UIImage imageNamed:@"shouye_location.png"]];
        [headerView addSubview:locationImgView];
        [locationImgView release];
        //定位城市
        x=x+width+3; y=10; width=220; height=22;
        [self setUpLabel:headerView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"北京市海淀区" with_Alignment:NSTextAlignmentLeft];
        
        //更多区域选择
        width=110; height=CGRectGetHeight(headerView.bounds); x=320-width; y=0;
        UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [queryBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [queryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [queryBtn setTitle:@"更换区域" forState:UIControlStateNormal];
        [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [queryBtn setImageEdgeInsets:UIEdgeInsetsMake(5, width-15,0, 30)];
        [queryBtn setImage:[[UIImage imageNamed:@"baoxianzhishiku_sanjiao.png"] imageRotatedByRadians:M_PI_2] forState:UIControlStateNormal];
        {
            queryBtn.backgroundColor=[UIColor clearColor];
            queryBtn.titleLabel.backgroundColor=[UIColor clearColor];
            queryBtn.imageView.backgroundColor=[UIColor clearColor];
        }
        [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:queryBtn];
        [queryBtn release];
    }    
    aTableView.tableHeaderView=headerView;
    [headerView release];
}

-(void)queryBtnClick:(UIButton*)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->selectedIndex:%d",selectedIndex);
        NSLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->selectedValue:%@",(NSString*)selectedValue);
        if (sender) {
            UIView* superView=sender.superview;
            if (superView) {
                UILabel* aLabel=(UILabel*)[superView viewWithTag:1001];
                if (aLabel) {
                    [aLabel setText:[NSString stringWithFormat:@"北京市%@",(NSString*)selectedValue]];
                }
            }
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->Block Picker Canceled");
    };
    NSArray *dataAry = [NSArray arrayWithObjects:@"朝阳", @"丰台", @"石景山", @"海淀", @"门头沟", @"房山", @"通州",@"顺义",@"昌平",@"大兴",@"怀柔",@"平谷",@"密云",@"延庆", nil];
    NSInteger selectedIndex=1;
    [ActionSheetStringPicker showPickerWithTitle:@"选择地区" rows:dataAry initialSelection:selectedIndex
                                       doneBlock:done cancelBlock:cancel origin:sender];
    
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
    [aLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"店铺推荐";
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
    [self initSetUpTableView:CGRectMake(0, 0, 320, self.view.bounds.size.width)];
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
    
    width=540/2.0; height=7/2.0; x=(CGRectGetWidth(cell.bounds)-width)/2.0; y=20+89/2.0+5-height;
    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineImageView.image=[UIImage imageNamed:@"dianputuijian_line.png"];
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
