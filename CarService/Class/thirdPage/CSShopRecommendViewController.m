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
#import "UIImageView+WebCache.h"
#import "BlockAlertView.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "TSMessage.h"
#import "LBSDataUtil.h"

@interface CSShopRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSShopRecommendViewController
@synthesize dataArray;

#define CSShopRecommendViewController_imgae_width 100.0
#define CSShopRecommendViewController_imgae_height 75.0
#define CSShopRecommendViewController_title_font 16.0
#define CSShopRecommendViewController_text_font 12.0
#define CSShopRecommendViewController_cell_default 95.0

#define CSShopRecommendViewController_key_imageUrl  @"imageUrl"
#define CSShopRecommendViewController_key_shopname  @"shopname"
#define CSShopRecommendViewController_key_address   @"address"
#define CSShopRecommendViewController_key_tel       @"tel"

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
    //返回按钮
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];
    
    UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
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
        [self setUpLabel:headerView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"北京市" with_Alignment:NSTextAlignmentLeft];
        {
            UILabel* aLabel=(UILabel*)[headerView viewWithTag:1001];
            if (aLabel) {
                NSString* city=[LBSDataUtil shareUtil].m_addrResult.addressComponent.city;
                NSString* district=[LBSDataUtil shareUtil].m_addrResult.addressComponent.district;
                if (city && district) {
                    [aLabel setText:[NSString stringWithFormat:@"%@%@",city, district]];
                }else{
                    [aLabel setText:[LBSDataUtil shareUtil].address];
                }
            }
        }
        
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
    [self.view addSubview:headerView];
    [headerView release];
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
}

-(void)queryBtnClick:(UIButton*)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        CustomLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->selectedIndex:%d",selectedIndex);
        CustomLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->selectedValue:%@",(NSString*)selectedValue);
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
        CustomLog(@"<<Chao-->CSShopRecommendViewController-->queryBtnClick-->Block Picker Canceled");
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
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(0, 40+3, 320, self.view.bounds.size.height-40-40-3-55)];
    [self startHttpRequest];
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

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_recommend];
    });
}

//店铺推荐
//接口：?json={"action":"recommend_shop",”lon”:”$lon”,”lat”:”$lat”}
-(void)request_recommend
{
    double longitude=[LBSDataUtil shareUtil].m_addrResult.geoPt.longitude;
    double latitude=[LBSDataUtil shareUtil].m_addrResult.geoPt.latitude;
    
    NSDictionary *scrDic = [NSDictionary dictionaryWithObjectsAndKeys:@"recommend_shop", @"action", nil];
    NSMutableDictionary *argDic=[NSMutableDictionary dictionaryWithDictionary:scrDic];
    if (longitude!=0 && latitude!=0) {
        [argDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:longitude]] forKey:@"lon"];
        [argDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:latitude]] forKey:@"lat"];
    }
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->CSShopRecommendViewController-->request_InsuranceKnowledge-->urlStr:%@",urlStr);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CustomLog(@"<<Chao-->CSShopRecommendViewController-->request_InsuranceKnowledge-->testResponseString:%@",testResponseString);
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSShopRecommendViewController-->request_InsuranceKnowledge-->requestDic:%@",requestDic);
        if ([requestDic objectForKey:@"status"]) {
            if ([[requestDic objectForKey:@"status"] intValue]==1) {
                [ApplicationPublic showMessage:self with_title:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败！", nil) with_type:TSMessageNotificationTypeError with_Duration:2.0];
                return;
            }else if ([[requestDic objectForKey:@"status"] intValue]==0){
                if ([requestDic objectForKey:@"list"]) {
                    self.dataArray=[requestDic objectForKey:@"list"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITableView* tableView=(UITableView*)[self.view viewWithTag:101];
                        if (tableView) {
                            [tableView reloadData];
                        }
                    });
                }
            }
        }
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationPublic showMessage:self with_title:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeWarning with_Duration:2.0];
        });
    }];
    [request startAsynchronous];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    //图片
    UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [aImageView setTag:1001];
    [cell.contentView addSubview:aImageView];
    [aImageView release];
    
    //名称
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTag:1002];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont systemFontOfSize:CSShopRecommendViewController_title_font]];
    [titleLabel setTextColor:[UIColor blackColor]];
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    //地址
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [addressLabel setTag:1003];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [addressLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:CSShopRecommendViewController_text_font]];
    [addressLabel setTextColor:[UIColor blackColor]];
    addressLabel.numberOfLines=0;
    addressLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:addressLabel];
    [addressLabel release];

    //电话
    UILabel* phoneLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [phoneLabel setTag:1004];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setFont:[UIFont systemFontOfSize:CSShopRecommendViewController_text_font]];
    [phoneLabel setTextColor:[UIColor blackColor]];
    phoneLabel.numberOfLines=0;
    phoneLabel.lineBreakMode=UILineBreakModeWordWrap;
    [cell.contentView addSubview:phoneLabel];
    [phoneLabel release];

    //咨询
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectZero];
    [queryBtn setTag:1005];
    [queryBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [queryBtn setTitle:@"咨 询" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"dianpuzixun_zixun_80.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"dianpuzixun_zixun_press_80.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:queryBtn];
    [queryBtn release];
    
    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(cell.bounds)-540/2.0)/2.0, 0, 540/2.0, 7/2.0)];
    [lineImageView setTag:1006];
    lineImageView.image=[UIImage imageNamed:@"dianputuijian_line.png"];
    [cell.contentView addSubview:lineImageView];
    [lineImageView release];
}

-(void)phoneBtnClick:(UIButton*)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"店铺咨询" message:@"是否电话呼叫咨询？"];
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert addButtonWithTitle:@"呼叫" block:^{
        UIView* superView=sender.superview;
        if (superView) {
            UILabel* phoneLabel=(UILabel*)[superView viewWithTag:1004];
            if (phoneLabel) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneLabel.text]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneLabel.text]]];
                }else{
                    
                }
            }
        }
    }];
    [alert show];
}

-(float)heigtForString:(NSString*)string  withSize:(float)size
{
    float height=(CSShopRecommendViewController_cell_default-10*2)/3.0;
    int labelWidth=self.view.bounds.size.width-CSShopRecommendViewController_imgae_width-10-10*2;
    CGSize fontSize;
    if (size==CSShopRecommendViewController_title_font) {
        fontSize=[string sizeWithFont:[UIFont systemFontOfSize:size]];
        int remainder = (int)fontSize.width%labelWidth;
        int line=(int)fontSize.width/(int)labelWidth;
        if (remainder!=0) {
            line=line+1;
        }
        float temp=(CSShopRecommendViewController_title_font+4)*line;
        if (temp>height) {
            height=temp;
        }
    }else{
        fontSize=[string sizeWithFont:[UIFont systemFontOfSize:size]];
        int remainder = (int)fontSize.width%labelWidth;
        int line=(int)fontSize.width/(int)labelWidth;
        if (remainder!=0) {
            line=line+1;
        }
        float temp=(CSShopRecommendViewController_title_font+4)*line;
        if (temp>height) {
            height=temp;
        }
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
        NSString* url=[dict objectForKey:CSShopRecommendViewController_key_imageUrl];
        NSString* name=[dict objectForKey:CSShopRecommendViewController_key_shopname];
        NSString* address=[dict objectForKey:CSShopRecommendViewController_key_address];
        NSString* phone=[dict objectForKey:CSShopRecommendViewController_key_tel];

        float x, y, width, height;
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImageWithURL:[NSURL URLWithString:url]
                           placeholderImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"] options:SDWebImageRefreshCached];
            width=CSShopRecommendViewController_imgae_width; height=CSShopRecommendViewController_imgae_height; x=10; y=([self heightForCell:indexPath]-height)/2.0;
            aImageView.frame=CGRectMake(x, y, width, height);
        }

        //名称
        UILabel* titleLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (titleLabel) {
            titleLabel.text=name;
            x=x+width+10; y=10; width=(320-10-width-10-10); height=[self heigtForString:name withSize:CSShopRecommendViewController_title_font];
            titleLabel.frame=CGRectMake(x, y, width, height);
        }

        //地址
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (addressLabel) {
            addressLabel.text=address;
            y=y+height; height=[self heigtForString:address withSize:CSShopRecommendViewController_text_font];
            addressLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //电话
        UILabel* phoneLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (phoneLabel) {
            phoneLabel.text=phone;
            y=y+height; height=[self heigtForString:phone withSize:CSShopRecommendViewController_text_font];
            phoneLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //咨询
        UIButton* queryBtn=(UIButton*)[cell.contentView viewWithTag:1005];
        if (queryBtn) {
            width=50; height=45; x=320-10-width; y=[self heightForCell:indexPath]-height;
            queryBtn.frame=CGRectMake(x, y, width, height);
        }
                
        UIImageView* lineImageView=(UIImageView*)[cell.contentView viewWithTag:1006];
        if (lineImageView) {
            width=lineImageView.frame.size.width; height=lineImageView.frame.size.height;
            x=lineImageView.frame.origin.x; y=[self heightForCell:indexPath]-lineImageView.frame.size.height;
            lineImageView.frame=CGRectMake(x, y, width, height);
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)heightForCell:(NSIndexPath*)indexPath
{
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* name=[dict objectForKey:CSShopRecommendViewController_key_shopname];
        NSString* address=[dict objectForKey:CSShopRecommendViewController_key_address];
        NSString* phone=[dict objectForKey:CSShopRecommendViewController_key_tel];
        
        float temp = 10 + [self heigtForString:name withSize:CSShopRecommendViewController_title_font]+
        [self heigtForString:address withSize:CSShopRecommendViewController_text_font]+
        [self heigtForString:phone withSize:CSShopRecommendViewController_text_font] +10;
        if (temp>95) {
            return temp;
        }else{
            return 95;
        }
    }
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCell:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
