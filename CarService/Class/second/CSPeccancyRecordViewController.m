//
//  CSPeccancyRecordViewController.m
//  CarService
//
//  Created by baidu on 13-9-27.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSPeccancyRecordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CSPeccancyRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSPeccancyRecordViewController
@synthesize dataArray;

//标题长度
#define CSPeccancyRecordViewController_cell_title_length  55
//时间 地点 违法行为 积分 罚款
#define CSPeccancyRecordViewController_time     (([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSPeccancyRecordViewController_cell_title_length
#define CSPeccancyRecordViewController_address  (([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSPeccancyRecordViewController_cell_title_length
#define CSPeccancyRecordViewController_category (([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSPeccancyRecordViewController_cell_title_length
#define CSPeccancyRecordViewController_mark     ((([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSPeccancyRecordViewController_cell_title_length)/2.0-20
#define CSPeccancyRecordViewController_cost     ((([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSPeccancyRecordViewController_cell_title_length)/2.0-20
//默认行高
#define CSPeccancyRecordViewController_height  30
//字体
#define CSPeccancyRecordViewController_font_text  12

////网站抓取数据
//static NSString* key_time = @"time";
//static NSString* key_address = @"address";
//static NSString* key_content = @"category";
//static NSString* key_score = @"mark";
//static NSString* key_price = @"cost";

//接口数据
static NSString* key_time=@"time";
static NSString* key_address=@"address";
static NSString* key_content=@"content";
static NSString* key_score=@"score";
static NSString* key_price=@"price";

- (id)initWithDataArray:(NSMutableArray *)aArray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
//        self.dataArray=[NSMutableArray arrayWithCapacity:3];
//        for (NSArray* indexAry in aArray) {
//            if ([indexAry count]==8) {
//                NSMutableDictionary* dict_index=[NSMutableDictionary dictionaryWithCapacity:3];
//                [dict_index setObject:[indexAry objectAtIndex:1] forKey:@"time"];
//                [dict_index setObject:[indexAry objectAtIndex:2] forKey:@"address"];
//                [dict_index setObject:[indexAry objectAtIndex:3] forKey:@"category"];
//                [dict_index setObject:[indexAry objectAtIndex:4] forKey:@"mark"];
//                [dict_index setObject:[indexAry objectAtIndex:5] forKey:@"cost"];
//                self.dataArray addObject:dict_index];
//            }
//        }
        self.dataArray=[NSMutableArray arrayWithArray:aArray];
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
    [self.view sendSubviewToBack:bgImageView];
    [bgImageView release];
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpButton:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text
{
    UIButton* categoryBtn=[[UIButton alloc] initWithFrame:frame];
    if (tag>0) {
        [categoryBtn setTag:tag];
    }
    [categoryBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [categoryBtn setTitle:text forState:UIControlStateNormal];
    [categoryBtn setBackgroundImage:[UIImage imageNamed:@"black_bg.png"] forState:UIControlStateNormal];
    [categoryBtn setTitleColor:[UIColor colorWithRed:0xf3/255.0 green:0xe9/255.0 blue:0xe2/255.0 alpha:1] forState:UIControlStateNormal];
    [categoryBtn setTitleColor:[UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1] forState:UIControlStateSelected];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    categoryBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryBtn.layer.borderWidth=0.5;
    [superView addSubview:categoryBtn];
    [categoryBtn release];
}

-(void)sortDescriptorWithKey:(NSString *)key  withArray:(NSMutableArray *)array ascending:(BOOL)ascending{
    UITableView* tableView=(UITableView*)[self.view viewWithTag:101];
    if (tableView) {
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
        [array sortUsingDescriptors:sortDescriptors];
        //更新
        [tableView reloadData];
    }
}

-(void)categoryBtnClick:(UIButton*)sender
{
    UIView* superView=[sender superview];
    if (superView) {
        for (UIButton* aBtn in superView.subviews) {
            if (aBtn!=sender && aBtn.selected) {
                aBtn.selected=NO;
            }
        }
    }
    
    BOOL isAscend=YES;
    if (sender.selected) {
        isAscend=NO;
    }
    sender.selected=!sender.isSelected;
    
    switch (sender.tag) {
        case 1001:
            [self sortDescriptorWithKey:key_time withArray:self.dataArray ascending:isAscend];
            break;
        case 1002:
            [self sortDescriptorWithKey:key_address withArray:self.dataArray ascending:isAscend];
            break;
        case 1003:
            [self sortDescriptorWithKey:key_content withArray:self.dataArray ascending:isAscend];
            break;
        case 1004:
            [self sortDescriptorWithKey:key_score withArray:self.dataArray ascending:isAscend];
            break;
        case 1005:
            [self sortDescriptorWithKey:key_price withArray:self.dataArray ascending:isAscend];
            break;
        default:
            break;
    }
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame
{
    frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
   
	UITableView *aTableView = [[UITableView alloc] initWithFrame:CGRectInset(frame, 5, 5) style:UITableViewStylePlain];
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineBg:self.view];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"违章记录" withTarget:self with_action:@selector(backBtnClick:)];
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(10, 15+35+3, 300, self.view.bounds.size.height-40-55-(15+35+3+8))];
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
    return [self.dataArray count];
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
    [aLabel setFont:[UIFont boldSystemFontOfSize:CSPeccancyRecordViewController_font_text]];
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=UILineBreakModeWordWrap;
    [superView addSubview:aLabel];
    [aLabel release];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    //时间
    [self setUpLabel:cell.contentView with_tag:2001 with_frame:CGRectMake(0, 0, CSPeccancyRecordViewController_cell_title_length, CSPeccancyRecordViewController_height) with_text:@"时间：" with_Alignment:NSTextAlignmentCenter];
    if ([cell.contentView viewWithTag:2001]) {
        [(UILabel*)[cell.contentView viewWithTag:2001] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1001 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //地址
    [self setUpLabel:cell.contentView with_tag:2002 with_frame:CGRectMake(0, 0, CSPeccancyRecordViewController_cell_title_length, CSPeccancyRecordViewController_height) with_text:@"地点：" with_Alignment:NSTextAlignmentCenter];
    if ([cell.contentView viewWithTag:2002]) {
        [(UILabel*)[cell.contentView viewWithTag:2002] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1002 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //违法行为
    [self setUpLabel:cell.contentView with_tag:2003 with_frame:CGRectMake(0, 0, CSPeccancyRecordViewController_cell_title_length, CSPeccancyRecordViewController_height) with_text:@"违章：" with_Alignment:NSTextAlignmentCenter];
    if ([cell.contentView viewWithTag:2003]) {
        [(UILabel*)[cell.contentView viewWithTag:2003] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1003 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //扣
    UIImageView* kouImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [kouImgView setTag:1006];
    [kouImgView setImage:[UIImage imageNamed:@"new_weichangchaxun_kou.png"]];
    [cell.contentView addSubview:kouImgView];
    [kouImgView release];
    //计分
    [self setUpLabel:cell.contentView with_tag:1004 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];

    //罚
    UIImageView* faImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [faImgView setTag:1007];
    [faImgView setImage:[UIImage imageNamed:@"new_weizhangchaxun_fa_tubiao.png"]];
    [cell.contentView addSubview:faImgView];
    [faImgView release];
    //费用
    [self setUpLabel:cell.contentView with_tag:1005 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
}

-(float)heigtForString:(NSString*)string  with_width:(float)width
{
    float height=CSPeccancyRecordViewController_height;
    int labelWidth=width;
    CGSize fontSize;
    fontSize=[string sizeWithFont:[UIFont systemFontOfSize:CSPeccancyRecordViewController_font_text]];
    int remainder = (int)fontSize.width%labelWidth;
    int line=(int)fontSize.width/(int)labelWidth;
    if (remainder!=0) {
        line=line+1;
    }
    float temp=(CSPeccancyRecordViewController_font_text+4)*line;
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
    
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* time=[dict objectForKey:key_time];
        NSString* address=[dict objectForKey:key_address];
        NSString* category=[dict objectForKey:key_content];
        NSString* mark=[dict objectForKey:key_score];
        NSString* cost=[dict objectForKey:key_price];
        
        float x, y, width, height;
        x=0; y=0; width=0; height=0;
        //时间
        UILabel* timeLabel=(UILabel*)[cell.contentView viewWithTag:1001];
        if (timeLabel) {
            timeLabel.text=time;
            x=CSPeccancyRecordViewController_cell_title_length;
            y=0;
            width=CSPeccancyRecordViewController_time;
            height=[self heigtForString:time with_width:CSPeccancyRecordViewController_time];
            timeLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2001]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2001];
            titleLable.frame=CGRectMake(0, y, titleLable.frame.size.width, height);
        }
        
        //地址
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (addressLabel) {
            addressLabel.text=address;
            y=y+height;
            width=CSPeccancyRecordViewController_address;
            height=[self heigtForString:address with_width:CSPeccancyRecordViewController_address];
            addressLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2002]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2002];
            titleLable.frame=CGRectMake(0, y, titleLable.frame.size.width, height);
        }
        
        //违法记录
        UILabel* categoryLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (categoryLabel) {
            categoryLabel.text=category;
            y=y+height;
            width=CSPeccancyRecordViewController_category;
            height= [self heigtForString:category with_width:CSPeccancyRecordViewController_category];
            categoryLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2003]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2003];
            titleLable.frame=CGRectMake(0, y, titleLable.frame.size.width, height);
        }
        
        //扣
        UIImageView* kouImgView=(UIImageView*)[cell.contentView viewWithTag:1006];
        {
            y=y+height+(CSPeccancyRecordViewController_height-kouImgView.frame.size.height)/2.0;
            width=kouImgView.frame.size.width;
            height=kouImgView.frame.size.height;
            kouImgView.frame=CGRectMake(x, y, width, kouImgView.frame.size.height);
        }
        //计分
        UILabel* markLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (markLabel) {
            markLabel.text=mark;
            x=x+width;
            width=CSPeccancyRecordViewController_mark;
            markLabel.frame=CGRectMake(x+5, y, width, height);
        }
        
        //罚
        UIImageView* faImgView=(UIImageView*)[cell.contentView viewWithTag:1007];
        {
            x=x+width;
            width=faImgView.frame.size.width;
            faImgView.frame=CGRectMake(x, y, width, kouImgView.frame.size.height);
        }
        //罚款
        UILabel* costLabel=(UILabel*)[cell.contentView viewWithTag:1005];
        if (costLabel) {
            costLabel.text=cost;
            x=x+width;
            width=CSPeccancyRecordViewController_cost;
            costLabel.frame=CGRectMake(x+5, y, width, height);
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

-(CGFloat)heightForCell:(NSIndexPath*)indexPath
{
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* time=[dict objectForKey:key_time];
        NSString* address=[dict objectForKey:key_address];
        NSString* category=[dict objectForKey:key_content];
        
        float time_h = [self heigtForString:time with_width:CSPeccancyRecordViewController_time];
        float address_h = [self heigtForString:address with_width:CSPeccancyRecordViewController_address];
        float category_h = [self heigtForString:category with_width:CSPeccancyRecordViewController_category];
        float kouAndFa_h = CSPeccancyRecordViewController_height;

        return time_h+address_h+category_h+kouAndFa_h;
    }
    return CSPeccancyRecordViewController_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCell:indexPath];
}

@end