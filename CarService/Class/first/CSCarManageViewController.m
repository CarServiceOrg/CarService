//
//  CSCarManageViewController.m
//  CarService
//
//  Created by baidu on 13-9-19.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCarManageViewController.h"
#import "BlockAlertView.h"

@interface CSCarManageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSCarManageViewController
@synthesize dataArray;

#define CSCarManageViewController_cell_hegight 80

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
    
    //添加按钮
    x=0; y=0; width=82/2.0+4; height=26;
    UIButton* addCarBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [addCarBtn setTitleColor:[UIColor colorWithRed:13/255.0 green:43/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [addCarBtn setTitle:@"添 加" forState:UIControlStateNormal];
    [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:addCarBtn] autorelease];
    [addCarBtn release];

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

-(void)addCarBtnClicked:(id)sender
{
    
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

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont systemFontOfSize:14]];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"车辆管理";
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    {
        self.dataArray=[NSMutableArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111111", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111112", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111113", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111114", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111115", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111116", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111117", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111118", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111119", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111110", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111121", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111122", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111123", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111124", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111125", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111126", @"carSign", @"236985478", @"carStand", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"京：11111127", @"carSign", @"236985478", @"carStand", nil],
                        nil];
    }
    
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(0, 10, 320, self.view.bounds.size.height-40-55 -10*2)];
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

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    float x, y, width, height;
    //图片
    x=10; y=5; width=320-x*2; height=CSCarManageViewController_cell_hegight-y*2;
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [bgImageView setImage:[UIImage imageNamed:@"tianjiacheliang_cell_bg.png"]];
    [cell.contentView addSubview:bgImageView];
    [bgImageView release];

    //图片
    x=x+5; y=y+5; width=70; height=CSCarManageViewController_cell_hegight-y*2;
    UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [aImageView setTag:1001];
    [cell.contentView addSubview:aImageView];
    [aImageView release];
    
    //车牌
    x=x+width+10; width=320-x-10; height=(CSCarManageViewController_cell_hegight-y*2)/2.0;
    [self setUpLabel:cell.contentView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
    //车架号
    y=y+height; y=y+1;
    [self setUpLabel:cell.contentView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];

    //删除按钮
    width=22; height=25; x=CGRectGetMaxX(bgImageView.frame)-width; y=bgImageView.frame.origin.y-3;
    UIButton* deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"tianjiacheliang_close.png"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"tianjiacheliang_close_press.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteBtn];
    [deleteBtn release];

}

-(void)deleteBtnClick:(UIButton*)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"是否删除当前车辆信息？"];
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert setDestructiveButtonWithTitle:@"确定" block:^{
        UIView* superView=sender.superview;
        if (superView) {
            NSString* carSign=@"";
            NSString* carStand=@"";
            //车牌号
            UILabel* carSignLabel=(UILabel*)[superView viewWithTag:1002];
            if (carSignLabel) {
                carSign=[carSignLabel.text substringFromIndex:4];
            }
            //车架号
            UILabel* carStandLabel=(UILabel*)[superView viewWithTag:1003];
            if (carStandLabel) {
                carStand=[carStandLabel.text substringFromIndex:4];
            }
            
            int index=0;
            for (NSDictionary* dict in self.dataArray) {
                NSString* carSign_dict=[dict objectForKey:@"carSign"];
                NSString* carStand_dict=[dict objectForKey:@"carStand"];
                if ([carSign_dict isEqualToString:carSign] && [carStand_dict isEqualToString:carStand]) {
                    UITableView* tableView=(UITableView*)[self.view viewWithTag:101];
                    if (tableView) {
                        //更新数据
                        [self.dataArray removeObjectAtIndex:index];
                        //动画更新列表
                        NSMutableArray* indexPaths = [[[NSMutableArray alloc] init] autorelease];
                        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }else{
                    index++;
                }
            }
        }
    }];
    [alert show];
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
        NSString* carSign=[dict objectForKey:@"carSign"];
        NSString* carStand=[dict objectForKey:@"carStand"];
        
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"]];
        }
        
        //车牌号
        UILabel* carSignLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (carSignLabel) {
            carSignLabel.text=[NSString stringWithFormat:@"车牌号：%@",carSign];
        }
        
        //车架号
        UILabel* carStandLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (carStandLabel) {
            carStandLabel.text=[NSString stringWithFormat:@"车驾号：%@",carStand];
        }
     }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
