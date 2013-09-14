//
//  ActionSheetMultiStringPicker.h
//  ActionSheetPicker
//
//  Created by 3g2win 3g2win on 12-9-6.
//  Copyright (c) 2012年 3g2win. All rights reserved.
//

#import "AbstractActionSheetPicker.h"

@class ActionSheetMultiStringPicker;
typedef void(^ActionMultiStringDoneBlock)(ActionSheetMultiStringPicker *picker,NSInteger selectedIndex, id selectedValue);
typedef void(^ActionMultiStringCancelBlock)(ActionSheetMultiStringPicker *picker);

@interface ActionSheetMultiStringPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
/* Create and display an action sheet picker. The returned picker is autoreleased. 
 "origin" must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 "target" must not be empty.  It should respond to "onSuccess" actions.
 "rows" is an array of strings to use for the picker's available selection choices. 
 "initialSelection" is used to establish the initially selected row;
 */
+ (id)showPickerWithTitle:(NSString *)title initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;

// Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (id)initWithTitle:(NSString *)title initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;



+ (id)showPickerWithTitle:(NSString *)title initialSelection:(NSInteger)index doneBlock:(ActionMultiStringDoneBlock)doneBlock cancelBlock:(ActionMultiStringCancelBlock)cancelBlock origin:(id)origin;

- (id)initWithTitle:(NSString *)title initialSelection:(NSInteger)index doneBlock:(ActionMultiStringDoneBlock)doneBlock cancelBlock:(ActionMultiStringCancelBlock)cancelBlockOrNil origin:(id)origin;

@property (nonatomic, copy) ActionMultiStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionMultiStringCancelBlock onActionSheetCancel;

//delete warning
//更新已经选择的省份的名称及ID
-(void)update_dict_province;
//更新已经选择的市的名称及ID
-(void)update_dict_city;
//更新已经选择的区的名称及ID
-(void)update_dict_district;

@end