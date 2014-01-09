//
//  CSCarManageViewController.m
//  CarService
//
//  Created by baidu on 13-9-19.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCarManageViewController.h"
#import "BlockAlertView.h"
#import "CSAddCarViewController.h"

@interface CSCarManageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSCarManageViewController
@synthesize dataArray;

#define CSCarManageViewController_cell_hegight 80
#define CSCarManageViewController_CarSign   @"车牌号："
#define CSCarManageViewController_CarStand  @"车架号："

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
    CSAddCarViewController* ctrler=[[CSAddCarViewController alloc] init];
    [self.navigationController pushViewController:ctrler animated:YES];
    [ctrler release];
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
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineBg:self.view];
    //添加按钮
    float x, y, width, height;
    x=0; y=0; width=82/2.0+4; height=26;
    UIButton* addCarBtn=[[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
    [addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [addCarBtn setTitleColor:[UIColor colorWithRed:13/255.0 green:43/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [addCarBtn setTitle:@"添 加" forState:UIControlStateNormal];
    [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"车辆管理" withTarget:self with_action:@selector(backBtnClick:) rightBtn:addCarBtn];
    [self initSetUpTableView:CGRectMake(0, 10, 320, self.view.bounds.size.height-40-55 -10*2)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
    if (alreadyAry) {
        self.dataArray=[NSMutableArray arrayWithArray:alreadyAry];
    }
    UITableView* tableView=(UITableView*)[self.view viewWithTag:101];
    if (tableView) {
        [tableView reloadData];
    }
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
    bgImageView.hidden=YES;

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
    width=20; height=20; x=((320-10*2)-5*2)-width-5; y=3;
    UIButton* deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    deleteBtn.backgroundColor=[UIColor clearColor];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"new_baoanzixun_shanchuanniu.png"] forState:UIControlStateNormal];
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
                carSign=[carSignLabel.text substringFromIndex:[[NSString stringWithFormat:@"%@",CSCarManageViewController_CarSign] length]];
            }
            //车架号
            UILabel* carStandLabel=(UILabel*)[superView viewWithTag:1003];
            if (carStandLabel) {
                carStand=[carStandLabel.text substringFromIndex:[[NSString stringWithFormat:@"%@",CSCarManageViewController_CarStand] length]];
            }
            
            int index=0;
            for (NSDictionary* dict in self.dataArray) {
                NSString* carSign_dict=[dict objectForKey:CSAddCarViewController_carSign];
                NSString* carStand_dict=[dict objectForKey:CSAddCarViewController_carStand];
                if ([carSign_dict isEqualToString:carSign] && [carStand_dict isEqualToString:carStand]) {
                    UITableView* tableView=(UITableView*)[self.view viewWithTag:101];
                    if (tableView) {
                        //更新数据
                        [self.dataArray removeObjectAtIndex:index];
                        //更新记录
                        if ([self.dataArray count]) {
                            [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:CSAddCarViewController_carList];
                        }else{
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:CSAddCarViewController_carList];
                        }
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
        NSString* carSign=[dict objectForKey:CSAddCarViewController_carSign];
        NSString* carStand=[dict objectForKey:CSAddCarViewController_carStand];
        
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"]];
        }
        
        //车牌号
        UILabel* carSignLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (carSignLabel) {
            carSignLabel.text=[NSString stringWithFormat:@"%@%@", CSCarManageViewController_CarSign, carSign];
        }
        
        //车架号
        UILabel* carStandLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (carStandLabel) {
            carStandLabel.text=[NSString stringWithFormat:@"%@%@",CSCarManageViewController_CarStand, carStand];
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
