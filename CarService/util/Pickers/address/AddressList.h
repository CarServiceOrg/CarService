//
//  AddressList.h
//  ComeEShop
//
//  Created by xuesen hu on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddressList : NSObject {
    
}

+(NSMutableArray*)getProvinceNameList;
+(NSMutableArray*)getProvinceIdList;
+(NSMutableArray*)getCityNameListWithProvinceId:(NSString*)provinceId;
+(NSMutableArray*)getDistrictNameListWithCityId:(NSString*)cityId;

+(NSString*)getProvinceIdWithName:(NSString*)name;
+(NSString*)getCityIdWithName:(NSString*)name;
+(NSString*)getDistrictIdWithName:(NSString*)name;

@end
