//
//  CSOrderListCell.m
//  CarService
//
//  Created by baidu on 13-9-24.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSOrderListCell.h"
#import "CSCommentViewController.h"

@interface CSOrderListCell ()

@property (nonatomic,retain) IBOutlet UIImageView *backImageView;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *projectNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *projectPersonLabel;
@property (nonatomic,retain) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) IBOutlet UIButton *rateButton;
@property (nonatomic,retain) NSDictionary *infoDic;

- (IBAction)rateButtonPressed:(id)sender;

@end

@implementation CSOrderListCell
@synthesize backImageView;
@synthesize projectNameLabel;
@synthesize timeLabel;
@synthesize projectPersonLabel;
@synthesize stateLabel;
@synthesize rateButton;
@synthesize infoDic;

+ (CSOrderListCell *)createCell
{
    CSOrderListCell *cell = [[[[[NSBundle mainBundle] loadNibNamed:@"CSOrderListCell" owner:nil options:nil] objectAtIndex:0] retain] autorelease];
    return cell;
}

- (void)dealloc
{
    [backImageView release];
    [projectNameLabel release];
    [projectPersonLabel release];
    [stateLabel release];
    [timeLabel release];
    [rateButton release];
    [super dealloc];
}

- (void)reloadConetent:(NSDictionary *)dic
{
    /*
 {"id":"23","order_sn":"AC123123133343","order_time":"2013-09-17","serve_type":"4","order_status":"1","name":"\u9a6c\u4e91\u9f99",”server_id”,”3”}
     */
    self.infoDic = dic;
    self.projectPersonLabel.text = @"name";
    self.timeLabel.text = [dic objectForKey:@"order_time"];
    
    //1为洗车服务 2为修车服务 3为卖车服务 4为验车
    switch ([[dic objectForKey:@"serve_type"] intValue]) {
        case 1:
            self.projectNameLabel.text = @"洗车";
            break;
        case 2:
            self.projectNameLabel.text = @"修车";
            break;
        case 3:
            self.projectNameLabel.text = @"卖车";
            break;
        case 4:
            self.projectNameLabel.text = @"验车";
            break;
        default:
            break;
    }
    
    // 0 未受理 1 正在处理 2 处理完毕
    if ([[dic objectForKey:@"order_status"] intValue] == 2)
    {
        self.stateLabel.text = [dic objectForKey:@"评分"];
        self.rateButton.userInteractionEnabled = YES;
    }
    else
    {
        self.stateLabel.text = [dic objectForKey:@"进行中"];
        self.rateButton.userInteractionEnabled = NO;
    }
}

- (void)setBackgroundImage:(UIImage *)newImage
{
    self.backImageView.image = newImage;
}

- (IBAction)rateButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RateOrderNotification object:nil userInfo:self.infoDic];
}

@end
