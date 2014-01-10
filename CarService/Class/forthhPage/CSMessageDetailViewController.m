//
//  CSMessageDetailViewController.m
//  CarService
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMessageDetailViewController.h"

@interface CSMessageDetailViewController ()

@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UIImageView *sepratorView;
@property (nonatomic,retain) NSDictionary *infoDic;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;

@end

@implementation CSMessageDetailViewController
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize sepratorView;
@synthesize infoDic;
@synthesize scrollView;

- (id)initWithContent:(NSDictionary *)dic
{
    self = [super initWithNibName:@"CSMessageDetailViewController" bundle:nil];
    if (self)
    {
        self.infoDic = dic;
    }
    return self;
}

- (void)dealloc
{
    [contentLabel release];
    [timeLabel release];
    [sepratorView release];
    [infoDic release];
    [scrollView release];
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
    
    frame=CGRectInset(frame, 5, 5);
    self.scrollView.frame = frame;
    self.scrollView.backgroundColor=[UIColor clearColor];
    CGSize size = [[self.infoDic objectForKey:@"content"] sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 1000)];
    self.contentLabel.frame = CGRectMake(0, 0,frame.size.width, 5+size.height+5);
    self.sepratorView.frame = CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, frame.size.width, self.sepratorView.frame.size.height);
    self.timeLabel.frame = CGRectMake(0, self.sepratorView.frame.origin.y + 8, frame.size.width, self.timeLabel.frame.size.height);
    
    self.contentLabel.text = [self.infoDic objectForKey:@"content"];
    NSString* time=[self.infoDic objectForKey:@"addtime"];
    NSDate* date=[NSDate dateWithTimeIntervalSince1970:[time intValue]];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* formatStr=[formatter stringFromDate:date];
    self.timeLabel.text = formatStr;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MAX(self.scrollView.frame.size.height, CGRectGetMaxX(self.timeLabel.frame)+20));

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor blackColor];
    [ApplicationPublic selfDefineBg:self.view];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"消息内容" withTarget:self with_action:@selector(backButtonPressed:)];
    [self initSetUpTableView:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
