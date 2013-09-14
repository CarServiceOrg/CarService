//
//  ActionSheetMultiStringPicker.m
//  ActionSheetPicker
//
//  Created by 3g2win 3g2win on 12-9-6.
//  Copyright (c) 2012年 3g2win. All rights reserved.
//

#import "ActionSheetMultiStringPicker.h"
#import "AddressList.h"
#import "MyPicker.h"

@interface ActionSheetMultiStringPicker()
@property (nonatomic,assign) NSInteger selectedIndex_province;
@property (nonatomic,retain) NSMutableDictionary* dict_province;

@property (nonatomic,assign) NSInteger selectedIndex_city;
@property (nonatomic,retain) NSMutableDictionary* dict_city;

@property (nonatomic,assign) NSInteger selectedIndex_district;
@property (nonatomic,retain) NSMutableDictionary* dict_district;
@end

@implementation ActionSheetMultiStringPicker
@synthesize selectedIndex_province;
@synthesize dict_province;

@synthesize selectedIndex_city;
@synthesize dict_city;

@synthesize selectedIndex_district;
@synthesize dict_district;

@synthesize onActionSheetDone = _onActionSheetDone;
@synthesize onActionSheetCancel = _onActionSheetCancel;

+ (id)showPickerWithTitle:(NSString *)title initialSelection:(NSInteger)index doneBlock:(ActionMultiStringDoneBlock)doneBlock cancelBlock:(ActionMultiStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    ActionSheetMultiStringPicker * multi_picker = [[ActionSheetMultiStringPicker alloc] initWithTitle:title initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [multi_picker showActionSheetPicker];
    return [multi_picker autorelease];
}

- (id)initWithTitle:(NSString *)title initialSelection:(NSInteger)index doneBlock:(ActionMultiStringDoneBlock)doneBlock cancelBlock:(ActionMultiStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title initialSelection:index target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showPickerWithTitle:(NSString *)title initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionSheetMultiStringPicker *multi_picker = [[[ActionSheetMultiStringPicker alloc] initWithTitle:title initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin] autorelease];
    [multi_picker showActionSheetPicker];
    return multi_picker;
}

- (id)initWithTitle:(NSString *)title initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.title = title;
        
        self.selectedIndex_province=index/1000000;
        self.dict_province=[NSMutableDictionary dictionaryWithCapacity:2];
        
        self.selectedIndex_city=(index%1000000)/1000;
        self.dict_city=[NSMutableDictionary dictionaryWithCapacity:2];
        
        self.selectedIndex_district=index%1000;
        self.dict_district=[NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)dealloc {    
    Block_release(_onActionSheetDone);
    Block_release(_onActionSheetCancel);
    
    if (self.dict_province) {
        self.dict_province=nil;
    }
    if (self.dict_city) {
        self.dict_city=nil;
    }
    if (self.dict_district) {
        self.dict_district=nil;
    }
    
    [super dealloc];
}

- (UIView *)configuredPickerView {
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    MyPicker *stringPicker = [[[MyPicker alloc] initWithFrame:pickerFrame] autorelease];
    //UIPickerView *stringPicker = [[[UIPickerView alloc] initWithFrame:pickerFrame] autorelease];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    //初始化数据
    [self update_dict_province];
    [self update_dict_city];
    [self update_dict_district];
    //初始化显示
    [stringPicker selectRow:self.selectedIndex_province inComponent:0 animated:NO];
    [stringPicker selectRow:self.selectedIndex_city inComponent:1 animated:NO];
    [stringPicker selectRow:self.selectedIndex_district inComponent:2 animated:NO];
    //开始显示界面
    [stringPicker reloadAllComponents];

    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionSheetDone) {
        NSMutableArray* backAry=[NSMutableArray arrayWithCapacity:3];
        [backAry addObject:self.dict_province];
        [backAry addObject:self.dict_city];
        [backAry addObject:self.dict_district];
        //将选择的数据返回去
        _onActionSheetDone(self, self.selectedIndex_province*1000000+self.selectedIndex_city*1000+self.selectedIndex_district, backAry);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        //[target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedIndex] withObject:origin];
        return;
    }
    NSLog(@"Invalid target/action ( %s / %@ ) combination used for ActionSheetPicker", object_getClassName(target), NSStringFromSelector(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

//For superclasses. 返回当前UIPicker的列数
- (int)getNumberOfColumn_fromSubclass{
    return 3;
}

#pragma mark - 省市区相关操作

//更新已经选择的省份的名称及ID
-(void)update_dict_province{
    NSMutableArray* provinceAry=[AddressList getProvinceNameList];
    if (provinceAry!=nil && [provinceAry count]>self.selectedIndex_province) {
        NSString* provinceNameStr=[provinceAry objectAtIndex:self.selectedIndex_province];
        if (provinceNameStr) {
            NSString* provinceIDStr=[AddressList getProvinceIdWithName:provinceNameStr];
            if (provinceIDStr) {
                [self.dict_province setObject:provinceNameStr forKey:@"name_province"];
                [self.dict_province setObject:provinceIDStr forKey:@"id_province"];
            }
        }
    }
}

//更新已经选择的市的名称及ID
-(void)update_dict_city{
    if (self.dict_province) {
        NSString* provinceIDStr=[self.dict_province objectForKey:@"id_province"];
        if (provinceIDStr) {
            NSMutableArray* cityAry=[AddressList getCityNameListWithProvinceId:provinceIDStr];
            if (cityAry!=nil && [cityAry count]>self.selectedIndex_city) {
                NSString* cityNameStr=[cityAry objectAtIndex:self.selectedIndex_city];
                if (cityNameStr) {
                    NSString* cityIDStr=[AddressList getCityIdWithName:cityNameStr];
                    if (cityIDStr) {
                        [self.dict_city setObject:cityNameStr forKey:@"name_city"];
                        [self.dict_city setObject:cityIDStr forKey:@"id_city"];
                    }
                }
            }
        }
    }
}

//更新已经选择的区的名称及ID
-(void)update_dict_district{
    if (self.dict_district) {
        NSString* cityIDStr=[self.dict_city objectForKey:@"id_city"];
        if (cityIDStr) {
            NSMutableArray* districtAry=[AddressList getDistrictNameListWithCityId:cityIDStr];
            if (districtAry!=nil && [districtAry count]>self.selectedIndex_district) {
                NSString* districtNameStr=[districtAry objectAtIndex:self.selectedIndex_district];
                if (districtNameStr) {
                    NSString* districtIDStr=[AddressList getDistrictIdWithName:districtNameStr];
                    if (districtNameStr) {
                        [self.dict_district setObject:districtNameStr forKey:@"name_district"];
                        [self.dict_district setObject:districtIDStr forKey:@"id_district"];
                    }
                }
            }
        }
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0) {
        return [[AddressList getProvinceNameList] count];
    }else if(component==1){
        NSString* provinceIDStr=[self.dict_province objectForKey:@"id_province"];
        if (provinceIDStr) {
            return [[AddressList getCityNameListWithProvinceId:provinceIDStr] count];
        }
    }else if (component==2) {
        NSString* cityIDStr=[self.dict_city objectForKey:@"id_city"];
        if (cityIDStr) {
            return [[AddressList getDistrictNameListWithCityId:cityIDStr] count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        return [NSString stringWithFormat:@"%@",[[AddressList getProvinceNameList] objectAtIndex:row]];
    }else if (component==1) {
        NSString* provinceIDStr=[self.dict_province objectForKey:@"id_province"];
        if (provinceIDStr) {
            NSMutableArray* cityAry=[AddressList getCityNameListWithProvinceId:provinceIDStr];
            if (cityAry!=nil) {
                return [NSString stringWithFormat:@"%@",[cityAry objectAtIndex:row]];
            }
        }
    }else if (component==2) {
        NSString* cityIDStr=[self.dict_city objectForKey:@"id_city"];
        if (cityIDStr) {
            NSMutableArray* districtAry=[AddressList getDistrictNameListWithCityId:cityIDStr];
            if (districtAry!=nil) {
                return [NSString stringWithFormat:@"%@",[districtAry objectAtIndex:row]];
            }
        }
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component==0) {
        return (pickerView.frame.size.width-30)/3-35;
    }else if (component==1) {
        return (pickerView.frame.size.width-30)/3;
    }else if (component==2) {
        return (pickerView.frame.size.width-30)/3+35;
    }
    
    return (pickerView.frame.size.width - 30)/3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            //查看省份的数据是否发生变化
            self.selectedIndex_province=row;
            //更新保存的省份数据
            [self update_dict_province];
            //右侧的市，默认停留在第一行，0表示第一行。
            [pickerView selectRow:0 inComponent:1 animated:YES];
            //重新加载第二个滚轮。
            [pickerView reloadComponent:1];
            
            self.selectedIndex_city=0;
            //更新保存的市数据 
            [self update_dict_city];
            //右侧的市，默认停留在第一行，0表示第一行。
            [pickerView selectRow:0 inComponent:2 animated:YES];
            //重新加载第二个滚轮。
            [pickerView reloadComponent:2];
            
            self.selectedIndex_district=0;
            break;
        }
        case 1:{
            self.selectedIndex_city=row;
            //更新保存的市数据 
            [self update_dict_city];
            //右侧的市，默认停留在第一行，0表示第一行。
            [pickerView selectRow:0 inComponent:2 animated:YES];
            //重新加载第二个滚轮。
            [pickerView reloadComponent:2];
            self.selectedIndex_district=0;
            break;
        }
        case 2:{
            self.selectedIndex_district=row;
            //更新保存的区数据 
            [self update_dict_district];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Block setters

// NOTE: Sometimes see crashes when relying on just the copy property. Using Block_copy ensures correct behavior

- (void)setOnActionSheetDone:(ActionMultiStringDoneBlock)onActionSheetDone {
    if (_onActionSheetDone) {
        Block_release(_onActionSheetDone);
        _onActionSheetDone = nil;
    }
    _onActionSheetDone = Block_copy(onActionSheetDone);
}

- (void)setOnActionSheetCancel:(ActionMultiStringCancelBlock)onActionSheetCancel {
    if (_onActionSheetCancel) {
        Block_release(_onActionSheetCancel);
        _onActionSheetCancel = nil;
    }
    _onActionSheetCancel = Block_copy(onActionSheetCancel);
}

@end
