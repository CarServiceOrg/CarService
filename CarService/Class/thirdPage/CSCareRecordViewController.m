//
//  CSCareRecordViewController.m
//  CarService
//
//  Created by baidu on 13-9-18.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCareRecordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CSCareRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSCareRecordViewController
@synthesize dataArray;

#define CSCareRecordViewController_time     85
#define CSCareRecordViewController_address  95
#define CSCareRecordViewController_category 70
#define CSCareRecordViewController_cost  50
#define CSCareRecordViewController_height  30
//字体
#define CSCareRecordViewController_font_text  12

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
    
    UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(10, 15, 320-10*2, 35)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    {
        //时间
        x=0; y=0; width=CSCareRecordViewController_time; height=headerView.frame.size.height;
        [self setUpButton:headerView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"时间"];
        //地址
        x=x+width; width=CSCareRecordViewController_address;
        [self setUpButton:headerView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"地点"];
        //项目
        x=x+width; width=CSCareRecordViewController_category;
        [self setUpButton:headerView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"项目"];
        //费用
        x=x+width; width=CSCareRecordViewController_cost;
        [self setUpButton:headerView with_tag:1004 with_frame:CGRectMake(x, y, width, height) with_text:@"费用"];
    }
    [self.view addSubview:headerView];
    [headerView release];
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
    [categoryBtn setTitleColor:[UIColor colorWithRed:0xc2/255.0f green:0xca/255.0f blue:0xd0/255.0f alpha:1] forState:UIControlStateSelected];
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
            [self sortDescriptorWithKey:@"time" withArray:self.dataArray ascending:isAscend];
            break;
        case 1002:
            [self sortDescriptorWithKey:@"address" withArray:self.dataArray ascending:isAscend];
            break;
        case 1003:
            [self sortDescriptorWithKey:@"category" withArray:self.dataArray ascending:isAscend];
            break;
        case 1004:
            [self sortDescriptorWithKey:@"cost" withArray:self.dataArray ascending:isAscend];
            break;
        default:
            break;
    }
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"店铺推荐";
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    {
        self.dataArray=[NSMutableArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-12", @"time", @"清河小营奥迪4S店清河小营奥河小营奥迪4", @"address", @"洗车", @"category", @"20", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-13", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-14", @"time", @"清河小营奥迪4S店清河小营奥河小营奥迪4", @"address", @"洗车", @"category", @"2004", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-15", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-16", @"time", @"清河小营奥迪4S店清河小营奥河小营奥迪4河小营奥迪4", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-17", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-18", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车1洗车2洗车3洗车4洗车5洗车6洗车7", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-19", @"time", @"清河小营奥迪4S店清河小营奥河小营奥迪4河小营奥迪4", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-20", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"200", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"2103-09-21", @"time", @"清河小营奥迪4S店清河小营奥", @"address", @"洗车", @"category", @"209900", @"cost", nil],

                        nil];
    }
    
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
    [aLabel setFont:[UIFont boldSystemFontOfSize:CSCareRecordViewController_font_text]];
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
    [self setUpLabel:cell.contentView with_tag:1001 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentCenter];
     
    //地址
    [self setUpLabel:cell.contentView with_tag:1002 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //项目
    [self setUpLabel:cell.contentView with_tag:1003 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentCenter];

    //费用
    [self setUpLabel:cell.contentView with_tag:1004 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
}

-(float)heigtForString:(NSString*)string  with_width:(float)width
{
    float height=CSCareRecordViewController_height;
    int labelWidth=width;
    CGSize fontSize;
    fontSize=[string sizeWithFont:[UIFont systemFontOfSize:CSCareRecordViewController_font_text]];
    int remainder = (int)fontSize.width%labelWidth;
    int line=(int)fontSize.width/(int)labelWidth;
    if (remainder!=0) {
        line=line+1;
    }
    float temp=(CSCareRecordViewController_font_text+4)*line;
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
        NSString* time=[dict objectForKey:@"time"];
        NSString* address=[dict objectForKey:@"address"];
        NSString* category=[dict objectForKey:@"category"];
        NSString* cost=[dict objectForKey:@"cost"];
        
        float x, y, width, height;
        height=[self heightForCell:indexPath];
        //时间
        UILabel* timeLabel=(UILabel*)[cell.contentView viewWithTag:1001];
        if (timeLabel) {
            timeLabel.text=time;
            x=0; y=0; width=CSCareRecordViewController_time;
            timeLabel.frame=CGRectMake(x, y, width, height);
        }

        //地址
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (addressLabel) {
            addressLabel.text=address;
            x=x+width; width=CSCareRecordViewController_address;
            addressLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //项目
        UILabel* categoryLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (categoryLabel) {
            categoryLabel.text=category;
            x=x+width; width=CSCareRecordViewController_category;
            categoryLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //费用
        UILabel* costLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (costLabel) {
            costLabel.text=cost;
            x=x+width; width=CSCareRecordViewController_cost;
            costLabel.frame=CGRectMake(x, y, width, height);
        }
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIImage* bgImage;
    if (indexPath.row%2==0) {
        bgImage=[[UIImage imageNamed:@"cell_bg_01.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }else{
        bgImage=[[UIImage imageNamed:@"cell_bg_02.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    cell.backgroundView = [[[UIImageView alloc] initWithImage:bgImage] autorelease];
    return cell;
}

-(CGFloat)heightForCell:(NSIndexPath*)indexPath
{
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* time=[dict objectForKey:@"time"];
        NSString* address=[dict objectForKey:@"address"];
        NSString* category=[dict objectForKey:@"category"];
        NSString* cost=[dict objectForKey:@"cost"];

        float temp = [self heigtForString:time with_width:CSCareRecordViewController_time];
        if (temp<[self heigtForString:address with_width:CSCareRecordViewController_address]) {
            temp=[self heigtForString:address with_width:CSCareRecordViewController_address];
        }
        if (temp<[self heigtForString:category with_width:CSCareRecordViewController_category]) {
            temp=[self heigtForString:category with_width:CSCareRecordViewController_category];
        }
        if (temp<[self heigtForString:cost with_width:CSCareRecordViewController_cost]) {
            temp=[self heigtForString:cost with_width:CSCareRecordViewController_cost];
        }
        
        if (temp>CSCareRecordViewController_height) {
            return temp;
        }else{
            return CSCareRecordViewController_height;
        }
    }
    return CSCareRecordViewController_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCell:indexPath];
}

@end
