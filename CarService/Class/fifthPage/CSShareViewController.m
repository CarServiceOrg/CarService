//
//  CSShareViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSShareViewController.h"

@interface CSShareViewController ()

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation CSShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ImageTypeCell = @"ManagerCell";
    
    UITableViewCell *cell;
    UIImageView *iconView;
    UILabel *title;
    
    cell = [tableView dequeueReusableCellWithIdentifier:ImageTypeCell];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageTypeCell]autorelease];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 20, 18)];
        iconView.tag = 1000;
        [cell.contentView addSubview:iconView];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 44)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:14];
        title.minimumFontSize = 10;
        title.adjustsFontSizeToFitWidth = YES;
        title.textAlignment = UITextAlignmentLeft;
        title.textColor = [UIColor colorWithRed:0x81/255.0f green:0x81/255.0f blue:0x81/255.0f alpha:1];
        title.tag = 100;
        [cell.contentView addSubview:title];
        [title release];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"membercenter_arrow.png"]];
        arrowView.frame = CGRectMake(258, 16, 8, 11);
        
        [cell.contentView addSubview:arrowView];
        [arrowView release];
    }
    
    title = (UILabel *)[cell.contentView viewWithTag:100];
    
    UIImage *normalImage = nil;
    UIImage *selectImage = nil;
    
    
    
    if (indexPath.row == 0)
    {
        normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaogetoubu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaogetoubu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        title.text = @"分享到新浪微博";
        UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
        if (nil != icon)
        {
            icon.image = [UIImage imageNamed:@"new_fenxiangruanjian_xinlangweibo.png"];
            icon.frame = CGRectMake(10, 13, 18, 17);
        }
        
    }
    else if (indexPath.row == 1)
    {
        normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_zhongbu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_zhongbu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        title.text = @"分享到腾讯微博";
        UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
        if (nil != icon)
        {
            icon.image = [UIImage imageNamed:@"new_fenxiangruanjian_tengxunweibo.png"];
            icon.frame = CGRectMake(10, 13, 20, 18);
        }
        
    }
    else if (indexPath.row == 2)
    {
        normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_zhongbu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_zhongbu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        title.text = @"分享到人人网";
        UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
        if (nil != icon)
        {
            icon.image = [UIImage imageNamed:@"new_fenxiangruanjian_renrenwang.png"];
            icon.frame = CGRectMake(10, 13, 20, 18);
        }
        
    }
    else if (indexPath.row == 3)
    {
        normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_dibu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"new_baoanzixun_biaoge_dibu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        title.text = @"分享到豆瓣";
        
        UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
        if (nil != icon)
        {
            icon.image = [UIImage imageNamed:@"new_fenxiangruanjian_douban.png"];
            icon.frame = CGRectMake(10, 13, 18, 17);
        }
        
    }
    
    if (nil != normalImage && nil != selectImage)
    {
        cell.backgroundView = [[[UIImageView alloc] initWithImage:normalImage]autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectImage]autorelease];
    }
    else
    {
        cell.backgroundView.hidden = YES;
        cell.selectedBackgroundView.hidden = YES;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //if ([[Util sharedUtil] hasLogin])
    
    
    switch (indexPath.row)
    {
        case 0:
            CustomLog(@"sina");
            
            break;
        case 1:
            CustomLog(@"qq");
            
            break;
        case 2:
            CustomLog(@"renren");
            break;
        case 3:
            CustomLog(@"douban");
            //分享
            break;
        default:
            break;
    }
    
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
