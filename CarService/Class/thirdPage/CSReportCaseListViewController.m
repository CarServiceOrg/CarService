//
//  CSReportCaseListViewController.m
//  CarService
//
//  Created by baidu on 14-1-11.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSReportCaseListViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "NSObject+SBJSON.h"
#import "MBProgressHUD.h"

static float CSTaoCanListViewController_title_font=12.0;

//
#define CSTaoCanListViewController_cell_Image_length  100
//标题长度
#define CSTaoCanListViewController_cell_title_length  40
//时间 地点 违法行为 积分 罚款
#define CSTaoCanListViewController_cell_text_width    (([UIScreen mainScreen].bounds.size.width-10*2)-10*2)-CSTaoCanListViewController_cell_Image_length-CSTaoCanListViewController_cell_title_length
//默认行高
#define CSTaoCanListViewController_cell_height  30

@interface CSReportCaseListViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    UITableView *_tableView;
    UIButton* _rightBtn;
}

@property(readonly,assign)MBProgressHUD *alertView;
@property(nonatomic,retain)NSMutableArray* m_dataArray;

@end

@implementation CSReportCaseListViewController
@synthesize alertView;

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
    {
        //添加按钮
        float x, y, width, height;
        x=0; y=0; width=82/2.0+4; height=26;
        UIButton* addCarBtn=[[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
        _rightBtn=addCarBtn;
        [addCarBtn setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.4]];
        [addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [addCarBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
        [addCarBtn setTitleColor:[UIColor colorWithWhite:0.0 alpha:1.0] forState:UIControlStateSelected];
        [addCarBtn setTitle:@"编 辑" forState:UIControlStateNormal];
        [addCarBtn setTitle:@"完 成" forState:UIControlStateSelected];
        {
            addCarBtn.layer.cornerRadius=8.0;
        }
        //[addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        //[addCarBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [ApplicationPublic selfDefineNavigationBar:self.view title:@"报案记录" withTarget:self with_action:@selector(backBtnClicked:) rightBtn:addCarBtn];
    }
    [self initSetUpTableView:self.view.bounds];
    
    //网络获取数据
    [self startHttpRequest];
}

-(void)backBtnClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addCarBtnClicked:(UIButton*)sender
{
    sender.selected=!sender.isSelected;
    if (_tableView) {
        [_tableView reloadData];
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
    NSString *urlStr = [[NSString stringWithFormat:@"%@?json={\"action\":\"accident_report_list\",\"user_id\":\"%@\"}",
                         ServerAddress,
                         [[[Util sharedUtil] getUserInfo] objectForKey:@"id"]
                         ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

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
                    //[self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败！", nil) with_type:TSMessageNotificationTypeError];
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

//
-(BOOL)request_delete:(NSDictionary*)dict
{
    __block BOOL flag=NO;
    NSString *uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"del_accident_report",@"action",uid,@"id", nil];
    NSString *jsonArg = [(NSString*)[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        MyNSLog(@"requestDic:%@",requestDic);
        //
        if ([requestDic objectForKey:@"status"]) {
            int status=[[requestDic objectForKey:@"status"] intValue];
            if (status==0) {
                flag=YES;
                
            }else if(status==1){
                
            }else if(status==2){
                
            }else{
                
            }
        }
    }];
    [request setFailedBlock:^{
        flag=NO;
    }];
    [request startSynchronous];
    
    return flag;
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

-(float)heigtForString:(NSString*)string  with_width:(float)width
{
    float height=CSTaoCanListViewController_cell_height;
    int labelWidth=width;
    CGSize fontSize;
    fontSize=[string sizeWithFont:[UIFont systemFontOfSize:CSTaoCanListViewController_title_font]];
    int remainder = (int)fontSize.width%labelWidth;
    int line=(int)fontSize.width/(int)labelWidth;
    if (remainder!=0) {
        line=line+1;
    }
    float temp=(CSTaoCanListViewController_title_font+4)*line;
    if (temp>height) {
        height=temp;
    }
    return height;
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
    [aLabel setFont:[UIFont boldSystemFontOfSize:CSTaoCanListViewController_title_font]];
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=UILineBreakModeWordWrap;
    [superView addSubview:aLabel];
    [aLabel release];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    //图片
    UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [aImageView setTag:1001];
    [cell.contentView addSubview:aImageView];
    [aImageView release];
    {
        aImageView.layer.borderWidth=2.0;
        aImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        aImageView.backgroundColor=[UIColor lightGrayColor];
    }
    
    //时间
    [self setUpLabel:cell.contentView with_tag:2001 with_frame:CGRectMake(0, 0, CSTaoCanListViewController_cell_title_length, CSTaoCanListViewController_cell_height) with_text:@"时间：" with_Alignment:NSTextAlignmentRight];
    if ([cell.contentView viewWithTag:2001]) {
        [(UILabel*)[cell.contentView viewWithTag:2001] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1002 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //地址
    [self setUpLabel:cell.contentView with_tag:2002 with_frame:CGRectMake(0, 0, CSTaoCanListViewController_cell_title_length, CSTaoCanListViewController_cell_height) with_text:@"地点：" with_Alignment:NSTextAlignmentRight];
    if ([cell.contentView viewWithTag:2002]) {
        [(UILabel*)[cell.contentView viewWithTag:2002] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1003 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];
    
    //备注
    [self setUpLabel:cell.contentView with_tag:2003 with_frame:CGRectMake(0, 0, CSTaoCanListViewController_cell_title_length, CSTaoCanListViewController_cell_height) with_text:@"备注：" with_Alignment:NSTextAlignmentRight];
    if ([cell.contentView viewWithTag:2003]) {
        [(UILabel*)[cell.contentView viewWithTag:2003] setTextColor:[UIColor grayColor]];
    }
    [self setUpLabel:cell.contentView with_tag:1004 with_frame:CGRectZero with_text:@"" with_Alignment:NSTextAlignmentLeft];

    //删除按钮
    float x, y, width,height;
    width=30; height=30; x=((320-10*2)-5*2)-width-5; y=3;
    UIButton* deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [deleteBtn setTag:1005];
    deleteBtn.backgroundColor=[UIColor clearColor];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"new_baoanzixun_shanchuanniu.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteBtn];
    [deleteBtn release];
    if (_rightBtn.isSelected) {
        deleteBtn.hidden=NO;
    }else{
        deleteBtn.hidden=YES;
    }
    
    //taglabel
    UILabel* taglabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [taglabel setTag:3001];
    [cell.contentView addSubview:taglabel];
    [taglabel release];
}

-(void)deleteBtnClick:(UIButton*)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"是否删除当前记录？"];
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert setDestructiveButtonWithTitle:@"确定" block:^{
        UIView* superView=sender.superview;
        if (superView) {
            if ([superView viewWithTag:3001]) {
                int index=[[(UILabel*)[superView viewWithTag:3001] text] intValue];
                if (_tableView && index<[self.m_dataArray count]) {
                    
                    {
                        self.alertView.mode = MBProgressHUDModeText;
                        self.alertView.color=[UIColor darkGrayColor];
                        self.alertView.labelText = NSLocalizedString(@"删除中...", nil);
                        [self.alertView show:YES];
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        BOOL flag=[self request_delete:[self.m_dataArray objectAtIndex:index]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (flag) {
                                self.alertView.labelText = NSLocalizedString(@"删除成功", nil);
                                [self.alertView show:YES];
                                [self.alertView hide:YES afterDelay:1.5];
                                
                                //更新数据
                                [self.m_dataArray removeObjectAtIndex:index];
                                
                                //动画更新列表
                                NSMutableArray* indexPaths = [[[NSMutableArray alloc] init] autorelease];
                                [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                                [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                            }else{
                                self.alertView.labelText = NSLocalizedString(@"删除失败", nil);
                                [self.alertView show:YES];
                                [self.alertView hide:YES afterDelay:1.5];
                            }
                        });
                    });
                }
            }
        }
    }];
    [alert show];
}

-(void)phoneBtnClick:(UIButton*)sender
{
    UIView* superView=[sender superview];
    if (superView) {
        UILabel* taglabel=(UILabel*)[superView viewWithTag:2001];
        if (taglabel) {
            int index=[taglabel.text intValue];
            if (index<[self.m_dataArray count]) {
                
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
        NSString* time=[dict objectForKey:@"addtime"];
        NSString* content=[dict objectForKey:@"content"];
        NSString* desc=[dict objectForKey:@"desc"];
        
        //tag
        UILabel* taglabel=(UILabel*)[cell.contentView viewWithTag:3001];
        if (taglabel) {
            taglabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
        }
        
        float x, y, width, height;
        x=0; y=0; width=0; height=0;
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"] options:SDWebImageRefreshCached];
            
            x=10;
            width=CSTaoCanListViewController_cell_Image_length-x*2;
            height=CSTaoCanListViewController_cell_Image_length-x*2;
            y=([self heightForCell:indexPath]-width)/2.0;
            aImageView.frame=CGRectMake(x, y, width, height);
        }
        
        //时间
        UILabel* timeLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (timeLabel) {
            //NSDate* date=[NSDate dateWithTimeIntervalSince1970:[time intValue]];
            //NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
            //[formatter setDateFormat:@"yyyy-MM-dd"];
            //NSString* formatStr=[formatter stringFromDate:date];
            //timeLabel.text=[NSString stringWithFormat:@"%@",formatStr];
            timeLabel.text=[NSString stringWithFormat:@"%@",time];
            
            x=CSTaoCanListViewController_cell_Image_length+CSTaoCanListViewController_cell_title_length;
            y=0;
            width=CSTaoCanListViewController_cell_text_width;
            //height=[self heigtForString:formatStr with_width:CSTaoCanListViewController_cell_text_width];
            height=[self heigtForString:time with_width:CSTaoCanListViewController_cell_text_width];
            timeLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2001]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2001];
            titleLable.frame=CGRectMake(CSTaoCanListViewController_cell_Image_length, y, titleLable.frame.size.width, height);
        }
        
        //地址
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (addressLabel) {
            addressLabel.text=[NSString stringWithFormat:@"%@",content];
            y=y+height;
            height=[self heigtForString:content with_width:CSTaoCanListViewController_cell_text_width];
            addressLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2002]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2002];
            titleLable.frame=CGRectMake(CSTaoCanListViewController_cell_Image_length, y, titleLable.frame.size.width, height);
        }
        
        //
        UILabel* categoryLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (categoryLabel) {
            categoryLabel.text=desc;
            y=y+height;
            height= [self heigtForString:desc with_width:CSTaoCanListViewController_cell_text_width];
            categoryLabel.frame=CGRectMake(x, y, width, height);
        }
        if ([cell.contentView viewWithTag:2003]) {
            UILabel* titleLable=(UILabel*)[cell.contentView viewWithTag:2003];
            titleLable.frame=CGRectMake(CSTaoCanListViewController_cell_Image_length, y, titleLable.frame.size.width, height);
        }

        UIButton* deleteBtn=(UIButton*)[cell.contentView viewWithTag:1005];
        if (deleteBtn) {
            if (_rightBtn.isSelected) {
                deleteBtn.hidden=NO;
                [UIView animateWithDuration:0.5 animations:^{
                    deleteBtn.transform=CGAffineTransformMakeScale(1.2, 1.2);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        deleteBtn.transform=CGAffineTransformMakeScale(1.0, 1.0);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    deleteBtn.transform=CGAffineTransformMakeScale(1.2, 1.2);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        deleteBtn.transform=CGAffineTransformMakeScale(0.0, 0.0);
                    } completion:^(BOOL finished) {
                        deleteBtn.hidden=YES;
                    }];
                }];
            }
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
    if (self.m_dataArray && [self.m_dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.m_dataArray objectAtIndex:indexPath.row];
        NSString* time=[dict objectForKey:@"addtime"];
        NSString* address=[dict objectForKey:@"content"];
        NSString* category=[dict objectForKey:@"desc"];
        
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:[time intValue]];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* formatStr=[formatter stringFromDate:date];
        
        float time_h = [self heigtForString:formatStr with_width:CSTaoCanListViewController_cell_text_width];
        float address_h = [self heigtForString:address with_width:CSTaoCanListViewController_cell_text_width];
        float category_h = [self heigtForString:category with_width:CSTaoCanListViewController_cell_text_width];
        
        return time_h+address_h+category_h;
    }
    return CSTaoCanListViewController_cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAX([self heightForCell:indexPath], 100);
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        [alertView release],alertView = nil;
    }
}
- (MBProgressHUD*) alertView
{
    if (alertView==nil) {
        id delegate = [UIApplication sharedApplication].delegate;
        UIWindow *window = [delegate window];
        alertView = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alertView];
        alertView.dimBackground = YES;
        alertView.labelText = NSLocalizedString(@"加载中", @"");
        alertView.delegate = self;
    }
    return alertView;
}

@end
