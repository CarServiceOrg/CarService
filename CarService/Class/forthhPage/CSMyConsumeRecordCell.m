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
    //fake data
    self.nameLabel.text = @"加油";
    self.timeLabel.text = @"213-08-30";
    self.locationlabel.text = @"清河加油站";
    self.costLabel.text = @"500";
}

- (void)setBackgroundImage:(UIImage *)newImage
{
    self.backImageView.image = newImage;
}

@end
