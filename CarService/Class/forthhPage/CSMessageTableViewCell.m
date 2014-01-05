//
//  CSMessageTableViewCell.m
//  CarService
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMessageTableViewCell.h"

@interface CSMessageTableViewCell ()

@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;

@end

@implementation CSMessageTableViewCell
@synthesize contentLabel;
@synthesize timeLabel;

+ (CSMessageTableViewCell *)createCell
{
    CSMessageTableViewCell *cell = [[[[[NSBundle mainBundle] loadNibNamed:@"CSMessageTableViewCell" owner:nil options:nil] objectAtIndex:0] retain] autorelease];
    return cell;
}

- (void)dealloc
{
    [contentLabel release];
    [timeLabel release];
    [super dealloc];
}

- (void)reloadConetent:(NSDictionary *)dic
{
    //fake data
    self.contentLabel.text = [dic objectForKey:@"content"];
    self.timeLabel.text = [dic objectForKey:@"addtime"];
}

@end
