//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//åLOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ActionSheetStringPicker.h"
#import "MyPicker.h"
#import <QuartzCore/QuartzCore.h> //layer you need this import

@interface ActionSheetStringPicker()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation ActionSheetStringPicker
@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize onActionSheetDone = _onActionSheetDone;
@synthesize onActionSheetCancel = _onActionSheetCancel;

+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:strings initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return [picker autorelease];
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title rows:strings initialSelection:index target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionSheetStringPicker *picker = [[[ActionSheetStringPicker alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin] autorelease];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    if (self.data) {
        self.data = nil;
    }
    Block_release(_onActionSheetDone);
    Block_release(_onActionSheetCancel);
    [super dealloc];
}

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    MyPicker *stringPicker = [[[MyPicker alloc] initWithFrame:pickerFrame] autorelease];
    //UIPickerView *stringPicker = [[[UIPickerView alloc] initWithFrame:pickerFrame] autorelease];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker selectRow:self.selectedIndex inComponent:0 animated:NO];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, self.selectedIndex, [self.data objectAtIndex:self.selectedIndex]);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        [target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedIndex] withObject:origin];
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

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
//(1)
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [self.data objectAtIndex:row];
//}

//(2)
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* textLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width-25*2, 44)] autorelease];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [textLabel setText:[self.data objectAtIndex:row]];
    [textLabel setNumberOfLines:0];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    if (row==0) {
        UIImageView* front_imgView=[[UIImageView alloc] initWithFrame:CGRectMake((textLabel.frame.size.width-354)/2, 0, 354, 2)];
        [front_imgView setImage:[UIImage imageNamed:@"yinhangzhuanyong_xuxian"]];
        [textLabel addSubview:front_imgView];
        [front_imgView release];
    }
    UIImageView* bottom_imgView=[[UIImageView alloc] initWithFrame:CGRectMake((textLabel.frame.size.width-354)/2, textLabel.frame.size.height-2, 354, 2)];
    [bottom_imgView setImage:[UIImage imageNamed:@"yinhangzhuanyong_xuxian"]];
    [textLabel addSubview:bottom_imgView];
    [bottom_imgView release];
    
    return textLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}

#pragma mark - Block setters

    // NOTE: Sometimes see crashes when relying on just the copy property. Using Block_copy ensures correct behavior

- (void)setOnActionSheetDone:(ActionStringDoneBlock)onActionSheetDone {
    if (_onActionSheetDone) {
        Block_release(_onActionSheetDone);
        _onActionSheetDone = nil;
    }
    _onActionSheetDone = Block_copy(onActionSheetDone);
}

- (void)setOnActionSheetCancel:(ActionStringCancelBlock)onActionSheetCancel {
    if (_onActionSheetCancel) {
        Block_release(_onActionSheetCancel);
        _onActionSheetCancel = nil;
    }
    _onActionSheetCancel = Block_copy(onActionSheetCancel);
}

@end