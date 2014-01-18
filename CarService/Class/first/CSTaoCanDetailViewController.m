//
//  CSTaoCanDetailViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSTaoCanDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "CSTaoCanSubmitViewController.h"

@interface CSTaoCanDetailViewController ()
{
    UIScrollView* _scrollView;
}

@end

@implementation CSTaoCanDetailViewController

- (id)initWithNibName:(NSDictionary *)aDict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.m_dataDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
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
    [aLabel setTextColor:[UIColor blackColor]];
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
    _scrollView=scrollView;
    {
        NSString* mallname=[self.m_dataDict objectForKey:@"mallname"];
        NSString* price=[self.m_dataDict objectForKey:@"price"];
        NSString* expiration_date=[self.m_dataDict objectForKey:@"expiration_date"];
        
        float x, y, width, height;
        
        //套餐名称
        x=0; y=0; width=scrollView.frame.size.width; height=30;
        [self setUpLabel:scrollView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:[NSString stringWithFormat:@"套餐名称：%@",mallname] with_Alignment:NSTextAlignmentLeft fontSize:16.0];
        
        //截止日期
        y=y+height;
        [self setUpLabel:scrollView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:[NSString stringWithFormat:@"有效日期：%@",expiration_date] with_Alignment:NSTextAlignmentLeft fontSize:16.0];
        
        //套餐价格
        y=y+height;
        [self setUpLabel:scrollView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:[NSString stringWithFormat:@"套餐价格：%@",price] with_Alignment:NSTextAlignmentLeft fontSize:16.0];
        
        y=y+height+5;
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, scrollView.frame.size.height-y)];
        [imageView setTag:1004];
        [imageView setBackgroundColor:[UIColor lightGrayColor]];
        [scrollView addSubview:imageView];
        [imageView release];
        //更新
        [self updateImageViewAndContentSize:self.m_dataDict];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineBg:self.view];
    {
        //添加按钮
        float x, y, width, height;
        x=0; y=0; width=34; height=34;
        UIButton* addCarBtn=[[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
        [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"new_dinggou.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"new_dinggou_selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ApplicationPublic selfDefineNavigationBar:self.view title:@"套餐详情" withTarget:self with_action:@selector(backBtnClicked:) rightBtn:addCarBtn];
    }
    [self initSelfView];
    
    //网络获取数据
    [self startHttpRequest];
}

-(void)backBtnClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.m_dataDict=nil;
    [super dealloc];
}

-(void)addCarBtnClicked:(UIButton*)sender
{
    if (self.m_dataDict) {
        CSTaoCanSubmitViewController* ctrler=[[CSTaoCanSubmitViewController alloc] initWithNibName:self.m_dataDict];
        [self.navigationController pushViewController:ctrler animated:YES];
        [ctrler release];
    }
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_detail];
    });
}

//
-(void)request_detail
{
    NSString *urlStr = [[NSString stringWithFormat:@"%@?json={\"action\":\"mall_info\",\"id\":\"%@\"}",ServerAddress,[self.m_dataDict objectForKey:@"id"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
                        NSMutableArray* array=[requestDic objectForKey:@"list"];
                        NSDictionary* dict=[array objectAtIndex:0];
                        [self updateImageViewAndContentSize:dict];
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

-(void)updateImageViewAndContentSize:(NSDictionary*)dict
{
    NSString* keyStr=@"details";
    
    
    if (dict && [dict objectForKey:keyStr]) {
        NSString* urlStr=@"";
        //更新
        UIImageView* imgView=(UIImageView*)[_scrollView viewWithTag:1004];
        if (imgView) {
            
            NSRange rang1=[[dict objectForKey:keyStr] rangeOfString:@"&quot;"];
            if (rang1.length) {
                NSString* subStr=[[dict objectForKey:keyStr] substringFromIndex:rang1.location+rang1.length];
                NSRange rang2=[subStr rangeOfString:@"&quot;"];
                if (rang2.length) {
                    NSString* destStr=[subStr substringToIndex:rang2.location];
                    urlStr=[NSString stringWithFormat:@"%@%@",@"http://www.guluhui.com//.",destStr];
                }
            }
            
            [imgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (error==nil && image) {
                    CGSize imgSize=[image size];
                    imgView.frame=CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, imgView.frame.size.width, imgSize.height*(imgView.frame.size.width/imgSize.width));
                    
                    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, 30*3+5+imgView.frame.size.height+5);
                }
            }];
        }
    }
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

@end
