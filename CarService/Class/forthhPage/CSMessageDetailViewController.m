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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"消息内容";
    CGSize size = [[self.infoDic objectForKey:@"content"] sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 1000)];
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y,self.contentLabel.frame.size.width, size.height);
    self.sepratorView.frame = CGRectMake(self.sepratorView.frame.origin.x, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, self.sepratorView.frame.size.width, self.sepratorView.frame.size.height);
    self.timeLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, self.sepratorView.frame.origin.y + 8, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    self.contentLabel.text = [self.infoDic objectForKey:@"content"];
    self.timeLabel.text = [self.infoDic objectForKey:@"time"];
    
    self.scrollView.contentSize = CGSizeMake(320, MAX([UIScreen mainScreen].bounds.size.height - (20 + 44 + 49), self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10));
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
