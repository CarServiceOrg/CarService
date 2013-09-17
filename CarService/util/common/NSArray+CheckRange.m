//
//  NSArrayz+CheckRange.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-16.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "NSArray+CheckRange.h"

@implementation NSArray(CheckRange)

- (id)objectAtIndexWithCheck:(NSUInteger)index
{
    if (index < [self count])
    {
        return [self  objectAtIndex:index];
    }
    else
    {
        CustomLog(@"error happen here");
        return nil;
    }
}

@end
