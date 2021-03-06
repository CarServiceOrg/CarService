//
//  CSMessageViewController.m
//  CarService
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMessageViewController.h"
#import "CSMessageDetailViewController.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"

@interface CSMessageViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    UITableView* _tableView;
    UIButton* _rightBtn;
}

@property(readonly,assign)MBProgressHUD *alertView;
@property (nonatomic,retain) NSMutableArray *m_dataArray;

@end

@implementation CSMessageViewController
@synthesize alertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.m_dataArray=nil;
    [super dealloc];
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

- (void)backButtonPressed:(id)sender
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor blackColor];
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
        
        [ApplicationPublic selfDefineNavigationBar:self.view title:@"我的消息" withTarget:self with_action:@selector(backButtonPressed:) rightBtn:addCarBtn];
    }
    [self initSetUpTableView:self.view.bounds];
    //网络获取数据
    [self startHttpRequest];
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
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"station_news",@"action",uid,@"user_id",sessionId,@"session_id", nil];
    NSString *jsonArg = [(NSString*)[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];

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
                        if (_tableView) {
                            [_tableView reloadData];
                        }
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
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"del_my_news",@"action",uid,@"id", nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_dataArray count];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    float x, y, width, height;

    //名称
    x=10; y=10; width=_tableView.frame.size.width-x-5-80; height=22;
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [titleLabel setTag:1001];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    //时间
    x=x+width+5; width=80;
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [addressLabel setTag:1002];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [addressLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:12.0]];
    [addressLabel setTextColor:[UIColor grayColor]];
    [cell.contentView addSubview:addressLabel];
    [addressLabel release];
    
    //删除按钮
    width=30; height=30; x=((320-10*2)-5*2)-width-5; y=3;
    UIButton* deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [deleteBtn setTag:1003];
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
    [taglabel setTag:2001];
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
            if ([superView viewWithTag:2001]) {
                int index=[[(UILabel*)[superView viewWithTag:2001] text] intValue];
                if (_tableView && index<[self.m_dataArray count]) {
                    
                    {
                        self.alertView.mode = MBProgressHUDModeText;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //添加视图
        [self createViewForcell:cell atRow:indexPath];
    }
    
    if (self.m_dataArray && [self.m_dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.m_dataArray objectAtIndex:indexPath.row];
        NSString* content=[dict objectForKey:@"content"];
        NSString* time=[dict objectForKey:@"addtime"];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:[time intValue]];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* formatStr=[formatter stringFromDate:date];
        
        //tag
        UILabel* taglabel=(UILabel*)[cell.contentView viewWithTag:2001];
        if (taglabel) {
            taglabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
        }
        
        //名称
        UILabel* titleLabel=(UILabel*)[cell.contentView viewWithTag:1001];
        if (titleLabel) {
            titleLabel.text=[NSString stringWithFormat:@"%@",content];
        }
        
        //
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (addressLabel) {
            addressLabel.text=[NSString stringWithFormat:@"%@",formatStr];
        }
        
        
        UIButton* deleteBtn=(UIButton*)[cell.contentView viewWithTag:1003];
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
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.m_dataArray objectAtIndex:indexPath.row];
    
    CSMessageDetailViewController *controller = [[CSMessageDetailViewController alloc] initWithContent:dic];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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
