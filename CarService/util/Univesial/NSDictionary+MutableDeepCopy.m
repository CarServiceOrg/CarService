//
//  NSDictionary+MutableDeepCopy.m
//  MTSIPAD
//
//  Created by 3g2win 3g2win on 12-9-28.
//  Copyright (c) 2012年 3g2win. All rights reserved.
//

//目标：把NSDictionary对象转换成NSMutableDictionary对象，对象内容是字符串数组，需要实现完全复制（深复制）。 
//
//    如果调用NSDictionary的mutableCopy方法，可以得到一个NSMutableDictionary对象，但这只是浅复制，如果我们修改NSDictionary中数组内的值
//(当然，数组必须是NSMutableArray），会发现，NSMutableDictionary对象内数组的值也跟着更改了。我们需要增加一个mutableDeepCopy方法来实现深复制，
//在该方法中，循环复制每一个元素。
//要实现这一功能，有两种方法，一是继承，二是使用category。category与继承的区别在于，使用category并不是新建一个类，而是在原类的基础上增加一些方法
//(使用的时候还是用原类名)，这样，我们就不需要修改已经在其他源文件中写好的类名，只需要导入h头文件，再把复制方法修改成我们新增的方法即可。
// 
//一、新建Objective-C category文件，我这Category填MutableDeepCopy,Category on填NSDictionary,所以生成的文件是NSDictionary+MutableDeepCopy.h和NSDictionary+MutableDeepCopy.m,生成的文件名很容易理解。 
// eg:
// NSMutableArray *arr1=[[NSMutableArray alloc] initWithObjects:@"aa",@"bb",@"cc", nil];  
// NSDictionary *dict1=[[NSDictionary alloc] initWithObjectsAndKeys:arr1,@"arr1", nil];  
// NSMutableDictionary *dict2=[dict1 mutableCopy];   //浅复制  
// NSMutableDictionary *dict3=[dict1 mutableDeepCopy];  //深复制  
 
#import "NSDictionary+MutableDeepCopy.h"

@implementation NSDictionary (MutableDeepCopy)

-(NSMutableDictionary *)mutableDeepCopy{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    //新建一个NSMutableDictionary对象，大小为原NSDictionary对象的大小
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {//循环读取复制每一个元素
        id value=[self objectForKey:key];
        id copyValue=nil;
        if (value!=nil && [value isKindOfClass:[NSNull class]]==NO) {
            if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
                //如果key对应的元素可以响应mutableDeepCopy方法(还是NSDictionary)，调用mutableDeepCopy方法复制
                copyValue=[value mutableDeepCopy];
            }else if([value respondsToSelector:@selector(mutableCopy)]){
                copyValue=[value mutableCopy];
            }
            
            if(copyValue==nil){
                copyValue=[value copy];
            }
            [dict setObject:copyValue forKey:key];
            [copyValue release];
        }
    }
    
    return dict;
}

@end
