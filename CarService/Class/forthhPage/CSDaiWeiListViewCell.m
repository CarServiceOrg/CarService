//
//  CSDaiWeiListViewCell.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSDaiWeiListViewCell.h"
#import "CSFeedBackViewController.h"
#import "CSWoDeDaiWeiViewController.h"

@interface CSDaiWeiListViewCell ()

@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *projectNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *personNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *statusLabel;
@property (nonatomic,retain) IBOutlet UIButton *detailButton;
@property (nonatomic,retain) NSDictionary *infoDic;

- (IBAction)detailButtonPressed:(id)sender;

@end

@implementation CSDaiWeiListViewCell
@synthesize timeLabel;
@synthesize projectNameLabel;
@synthesize personNameLabel;
@synthesize statusLabel;
@synthesize detailButton;
@synthesize parentViewController;
@synthesize infoDic;

+ (CSDaiWeiListViewCell *)createCell
{
    CSDaiWeiListViewCell *cell = [[[[[NSBundle mainBundle] loadNibNamed:@"CSDaiWeiListViewCell" owner:nil options:nil] objectAtIndex:0] retain] autorelease];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)dealloc
{
    [timeLabel release];
    [projectNameLabel release];
    [personNameLabel release];
    [statusLabel release];
    [detailButton release];
    [infoDic release];
    [super dealloc];
}

- (void)reloadConetent:(NSDictionary *)dic
{
    /*
     {"cons_time":"2013.08.33","cons_address":"\u5317\u4eac\u6d77\u6dc0\u52a0\u6cb9\u7ad9","cons_type":"1","cons_num":"200"}
     */
    self.infoDic = dic;
    NSString *projectName;
    switch ([[dic objectForKey:@"serve_type"] integerValue])
    {
        case 1:
            projectName = @"洗车服务";
            break;
        case 2:
            projectName = @"修车服务";
            break;
        case 3:
            projectName = @"卖车服务";
            break;
        case 4:
            projectName = @"验车";
            break;
        default:
            break;
    }
    self.projectNameLabel.text = projectName;
    self.timeLabel.text = [dic objectForKey:@"order_time"];
    if ([[dic objectForKey:@"name"] isKindOfClass:[NSString class]])
    {
        self.personNameLabel.text = [dic objectForKey:@"name"];
    }
    else
    {
        self.personNameLabel.text = @"";
    }
    NSString *statusString ;
    switch ([[dic objectForKey:@"order_status"] integerValue])
    {
        case 0:
            statusString = @"未受理";
            self.detailButton.userInteractionEnabled = NO;
            break;
        case 1:
            statusString = @"正在处理";
            self.detailButton.userInteractionEnabled = YES;
            break;
        case 2:
            statusString = @"处理完毕";
            self.detailButton.userInteractionEnabled = YES;
            break;
    }
    self.statusLabel.text = statusString;
}

- (IBAction)detailButtonPressed:(id)sender
{
    if ([[self.infoDic objectForKey:@"order_status"] integerValue] == 1)
    {
        CSWoDeDaiWeiViewController *controller = [[CSWoDeDaiWeiViewController alloc] initWithOrderInfo:self.infoDic];
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if ([[self.infoDic objectForKey:@"order_status"] integerValue] == 2)
    {
        CSFeedBackViewController *controller = [[CSFeedBackViewController alloc] initWithOrderInfo:self.infoDic];
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else
    {
        CustomLog(@"error here");
    }
}

@end
