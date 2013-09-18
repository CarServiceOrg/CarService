//
//  CSDelegateBookViewController.h
//  CarService
//
//  Created by baidu on 13-9-18.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CSDelegateServiceType
{
    CSDelegateServiceType_wash = 0,
    CSDelegateServiceType_check,
    CSDelegateServiceType_fix,
    CSDelegateServiceType_sale
};

typedef enum CSDelegateServiceType CSDelegateServiceType;

@interface CSDelegateBookViewController : UIViewController{
    CSDelegateServiceType _type;
}

-(id)initWithBookType:(CSDelegateServiceType) type;

@end
