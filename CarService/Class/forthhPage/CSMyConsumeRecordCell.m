//
//  CSMyConsumeRecordCell.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMyConsumeRecordCell.h"

@interface CSMyConsumeRecordCell ()

@property (nonatomic,retain) IBOutlet UIImageView *backImageView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *locationlabel;
@property (nonatomic,retain) IBOutlet UILabel *costLabel;

@end

@implementation CSMyConsumeRecordCell
@synthesize backImageView;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize locationlabel;
@synthesize costLabel;

+ (CSMyConsumeRecordCell *)createCell
{
    CSMyConsumeRecordCell *cell = [[[[[NSBundle mainBundle] loadNibNamed:@"CSMyConsumeRecordCell" owner:nil options:nil] objectAtIndex:0] retain] autorelease];
    return cell;
}

- (void)dealloc
{
    [backImageView release];
    [nameLabel release];
    [locationlabel release];
    [costLabel release];
    [timeLabel release];
    [super dealloc];
}

- (void)reloadConetent:(NSDictionary *)dic
{
    /*
     {"cons_time":"2013.08.33","cons_address":"\u5317\u4eac\u6d77\u6dc0\u52a0\u6cb9\u7ad9","cons_type":"1","cons_num":"200"}
     */
    self.nameLabel.text = @"cons_type";
    self.timeLabel.text = [dic objectForKey:@"cons_time"];
    self.locationlabel.text = [dic objectForKey:@"cons_address"];
    self.costLabel.text = [dic objectForKey:@"cons_num"];
}

- (void)setBackgroundImage:(UIImage *)newImage
{
    self.backImageView.image = newImage;
}

@end
