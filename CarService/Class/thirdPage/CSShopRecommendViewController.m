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

@interface CSShopRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,retain)NSMutableArray* dataArray;

@end

@implementation CSShopRecommendViewController
@synthesize dataArray;

#define CSShopRecommendViewController_imgae_width 100.0
#define CSShopRecommendViewController_imgae_height 750.0
#define CSShopRecommendViewController_title_font 16.0
#define CSShopRecommendViewController_text_font 12.0
#define CSShopRecommendViewController_cell_default 95.0

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
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120509154705", @"imageUrl", @"清河小营奥迪4S店清河小营奥", @"name", @"地址：海淀区清河小营桥西106号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/810/508/44805018:jpeg_preview_small.jpg?20120508125339", @"imageUrl", @"清河小营奥迪4S店", @"name", @"地址：海淀区清河小营桥西107号海淀区清河小营桥西107号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/282/467/44764282:jpeg_preview_small.jpg?20120507130637", @"imageUrl", @"清河小营奥迪4S店", @"name", @"地址：海淀区清河小营桥西108号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/833/347/44743338:jpeg_preview_small.jpg?20120509183004", @"imageUrl", @"清河小营奥迪4S店", @"name", @"地址：海淀区清河小营桥西109号海淀区清河小", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/142/746/44647241:jpeg_preview_small.jpg?20120504104451", @"imageUrl", @"清河小营奥迪4S店清河小营奥", @"name", @"地址：海淀区清河小营桥西110号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120507015022", @"imageUrl", @"清河小营奥迪4S店清河小营奥", @"name", @"地址：海淀区清河小营桥西111号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120507185251", @"imageUrl", @"清河小营奥迪4S店清河小营奥", @"name", @"地址：海淀区清河小营桥西112号海淀区清河小营桥西112号海淀区清河小营桥西112号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120505174152", @"imageUrl", @"清河小营奥迪4S店", @"name", @"地址：海淀区清河小营桥西113号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120507185251", @"imageUrl", @"清河小营奥迪4S店清河小营奥清河小营奥", @"name", @"地址：海淀区清河小营桥西114号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120503132132", @"imageUrl", @"清河小营奥迪4S店", @"name", @"地址：海淀区清河小营桥西115号海淀区清河小营桥西115号", @"address", @"电话：010-6025366", @"phone", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120501165940", @"imageUrl", @"清河小营奥迪4S店清河小营奥", @"name", @"地址：海淀区清河小营桥西116号", @"address", @"电话：010-6025366", @"phone", nil],
                        nil];
    }
    
    [self init_selfView];
    [self initSetUpTableView:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
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
    
    //图片
    UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [aImageView setTag:1001];
    [cell.contentView addSubview:aImageView];
    [aImageView release];
    
    //名称
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTag:1002];
    [titleLabel setBackgroundColor:[UIColor greenColor]];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setTextAlignment:UITextAlignmentLeft];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:CSShopRecommendViewController_title_font]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    //地址
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [addressLabel setTag:1003];
    [addressLabel setBackgroundColor:[UIColor redColor]];
    [addressLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [addressLabel setTextAlignment:UITextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:CSShopRecommendViewController_text_font]];
    [addressLabel setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:addressLabel];
    [addressLabel release];

    //电话
    UILabel* phoneLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [phoneLabel setTag:1004];
    [phoneLabel setBackgroundColor:[UIColor blueColor]];
    [phoneLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [phoneLabel setTextAlignment:UITextAlignmentLeft];
    [phoneLabel setFont:[UIFont systemFontOfSize:CSShopRecommendViewController_text_font]];
    [phoneLabel setTextColor:[UIColor blackColor]];
    [cell.contentView addSubview:phoneLabel];
    [phoneLabel release];

    //咨询
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectZero];
    [queryBtn setTag:1005];
    [queryBtn setTitle:@"咨 询" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
}

-(float)heigtForString:(NSString*)string  withSize:(float)size
{
    float height=(CSShopRecommendViewController_cell_default-10*2)/3.0;
    CGSize fontSize;
    if (size==CSShopRecommendViewController_title_font) {
        fontSize=[string sizeWithFont:[UIFont boldSystemFontOfSize:size]];
        int remainder = (int)fontSize.width%(int)(320-10-CSShopRecommendViewController_imgae_width-10-10);
        int line=(int)fontSize.width/(int)(320-10-CSShopRecommendViewController_imgae_width-10-10);
        if (remainder!=0) {
            line=line+1;
        }
        float temp=(CSShopRecommendViewController_title_font+4)*line;
        if (temp>height) {
            height=temp;
        }
    }else{
        fontSize=[string sizeWithFont:[UIFont systemFontOfSize:size]];
        int remainder = (int)fontSize.width%(int)(320-10-CSShopRecommendViewController_imgae_width-10-10);
        int line=(int)fontSize.width/(int)(320-10-CSShopRecommendViewController_imgae_width-10-10);
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
        NSString* url=[dict objectForKey:@"imageUrl"];
        NSString* name=[dict objectForKey:@"name"];
        NSString* address=[dict objectForKey:@"address"];
        NSString* phone=[dict objectForKey:@"phone"];

        float x, y, width, height;
        //图片
        UIImageView* aImageView=(UIImageView*)[cell.contentView viewWithTag:1001];
        if (aImageView) {
            [aImageView setImageWithURL:[NSURL URLWithString:url]
                           placeholderImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"] options:SDWebImageRefreshCached];
            width=100; height=80; x=10; y=([self heightForCell:indexPath]-height)/2.0;
            aImageView.frame=CGRectMake(x, y, width, height);
        }

        //名称
        UILabel* titleLabel=(UILabel*)[cell.contentView viewWithTag:1002];
        if (titleLabel) {
            titleLabel.text=name;
            x=x+width; y=y; width=(320-10-width-10-10); height=[self heigtForString:name withSize:CSShopRecommendViewController_title_font];
            titleLabel.frame=CGRectMake(x, y, width, height);
        }

        //地址
        UILabel* addressLabel=(UILabel*)[cell.contentView viewWithTag:1003];
        if (addressLabel) {
            addressLabel.text=address;
            y=y+height; height=[self heigtForString:name withSize:CSShopRecommendViewController_text_font];
            addressLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //电话
        UILabel* phoneLabel=(UILabel*)[cell.contentView viewWithTag:1004];
        if (phoneLabel) {
            phoneLabel.text=phone;
            y=y+height; height=[self heigtForString:name withSize:CSShopRecommendViewController_text_font];
            phoneLabel.frame=CGRectMake(x, y, width, height);
        }
        
        //咨询
        UIButton* queryBtn=(UIButton*)[cell.contentView viewWithTag:1005];
        if (queryBtn) {
            width=60; height=40; x=320-10-width; y=[self heightForCell:indexPath]-10-height;
            queryBtn.frame=CGRectMake(x, y, width, height);
        }
                
        UIImageView* lineImageView=(UIImageView*)[cell.contentView viewWithTag:1006];
        if (lineImageView) {
            width=lineImageView.frame.size.width; height=lineImageView.frame.size.height;
            x=lineImageView.frame.origin.x; y=[self heightForCell:indexPath]-lineImageView.frame.size.height;
            lineImageView.frame=CGRectMake(x, y, width, height);
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

-(CGFloat)heightForCell:(NSIndexPath*)indexPath
{
    if (self.dataArray && [self.dataArray count]>indexPath.row) {
        NSDictionary* dict=[self.dataArray objectAtIndex:indexPath.row];
        NSString* name=[dict objectForKey:@"name"];
        NSString* address=[dict objectForKey:@"address"];
        NSString* phone=[dict objectForKey:@"phone"];
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
