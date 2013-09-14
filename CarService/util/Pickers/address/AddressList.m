//
//  AddressList.m
//  ComeEShop
//
//  Created by xuesen hu on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressList.h"
#import "JSONParser.h"

@implementation AddressList

+(NSMutableDictionary*)getAddressDict {
	NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AddressList"];
	if (!dict) {
		NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"getAddressInfoList" ofType:@"do"]];
		dict = [JSONParser parserData:data isAllValues:YES valueForKey:nil];
		if (dict) {
			[[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"AddressList"];			
		}
	}
	return dict;
}

+(NSMutableArray*)getProvinceNameList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"province"];
	NSMutableArray *NameList = [NSMutableArray arrayWithCapacity:34];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[NameList addObject:[d objectForKey:@"NAME"]];
	}
	return NameList;
}

+(NSMutableArray*)getProvinceIdList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"province"];
	NSMutableArray *IdList = [NSMutableArray arrayWithCapacity:34];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[IdList addObject:[d objectForKey:@"ID"]];
	}
	return IdList;
}

+(NSMutableArray*)getCityNameList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"city"];
	NSMutableArray *NameList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[NameList addObject:[d objectForKey:@"NAME"]];
	}
	return NameList;
}

+(NSMutableArray*)getCityIdList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"city"];
	NSMutableArray *IdList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[IdList addObject:[d objectForKey:@"ID"]];
	}
	return IdList;
}

+(NSMutableArray*)getDistrictNameList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"district"];
	NSMutableArray *NameList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[NameList addObject:[d objectForKey:@"NAME"]];
	}
	return NameList;
}

+(NSMutableArray*)getDistrictIdList {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"district"];
	NSMutableArray *IdList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		[IdList addObject:[d objectForKey:@"ID"]];
	}
	return IdList;
}

+(NSMutableArray*)getCityNameListWithProvinceId:(NSString*)provinceId {	
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"city"];
	NSMutableArray *NameList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		NSString *s = [NSString stringWithFormat:@"%d",[[d objectForKey:@"ID"]intValue]];
		if ([[s substringToIndex:2] isEqualToString:[provinceId substringToIndex:2]]) {
			NSString *name = [d objectForKey:@"NAME"];
			[NameList addObject:name];
		}		
	}
	return NameList;
}

+(NSMutableArray*)getDistrictNameListWithCityId:(NSString*)cityId {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"district"];
	NSMutableArray *NameList = [NSMutableArray arrayWithCapacity:10];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		NSString *s = [NSString stringWithFormat:@"%d",[[d objectForKey:@"ID"]intValue]];
		if ([[s substringToIndex:4] isEqualToString:[cityId substringToIndex:4]]) {
			NSString *name = [d objectForKey:@"NAME"];
			[NameList addObject:name];
		}		
	}
	return NameList;
}

+(NSString*)getProvinceIdWithName:(NSString*)name {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"province"];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		if ([name isEqual:[d objectForKey:@"NAME"]]) {
			return [NSString stringWithFormat:@"%d",[[d objectForKey:@"ID"]intValue]];
		}
	}
	return nil;
}

+(NSString*)getCityIdWithName:(NSString*)name {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"city"];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		if ([name isEqual:[d objectForKey:@"NAME"]]) {
			return [NSString stringWithFormat:@"%d",[[d objectForKey:@"ID"]intValue]];
		}
	}
	return nil;
}

+(NSString*)getDistrictIdWithName:(NSString*)name {
	NSMutableDictionary *dict = [AddressList getAddressDict];
	NSMutableArray *List = [dict objectForKey:@"district"];
	for (int i=0; i<[List count]; i++) {
		NSDictionary *d = [List objectAtIndex:i];
		if ([name isEqual:[d objectForKey:@"NAME"]]) {
			return [NSString stringWithFormat:@"%d",[[d objectForKey:@"ID"]intValue]];
		}
	}
	return nil;
}

@end
