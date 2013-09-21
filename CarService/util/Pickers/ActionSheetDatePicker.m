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
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import "ActionSheetDatePicker.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h> //layer you need this import

@interface ActionSheetDatePicker()
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *selectedDate;
@end

@implementation ActionSheetDatePicker
@synthesize selectedDate = _selectedDate;
@synthesize datePickerMode = _datePickerMode;

+ (id)showPickerWithTitle:(NSString *)title 
           datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate                                                                             
                 target:(id)target action:(SEL)action origin:(id)origin {
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate target:target action:action origin:origin];
    [picker showActionSheetPicker];
    return [picker autorelease];
}

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action origin:(id)origin {
    self = [super initWithTarget:target successAction:action cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        self.datePickerMode = datePickerMode;
        self.selectedDate = selectedDate;
    }
    return self;
}

- (void)dealloc {
    self.selectedDate = nil;
    [super dealloc];
}

-(void)addSelfDefineImages:(UIView*)superView{
    float x,y,width,height;
    float width2=29;
    //left
    x=0; y=0; width=77/2.0; height=432/2.0;
    if (self.datePickerMode==UIDatePickerModeDateAndTime) {
        width=width2;
    }
    UIImageView* left_imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [left_imgView setImage:[UIImage imageNamed:@"datePicker_left"]];
    [superView addSubview:left_imgView];
    [left_imgView release];
    //top
    x=x+width; y=0; width=243; height=18/2.0;
    if (self.datePickerMode==UIDatePickerModeDateAndTime) {
        width=320-width2*2;
    }
    UIImageView* top_imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height+1)];
    [top_imgView setImage:[UIImage imageNamed:@"datePicker_top"]];
    [superView addSubview:top_imgView];
    [top_imgView release];
    //down
    y=superView.frame.size.height-height;
    UIImageView* down_imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [down_imgView setImage:[UIImage imageNamed:@"datePicker_down"]];
    [superView addSubview:down_imgView];
    [down_imgView release];
    //right
    x=superView.frame.size.width-x; y=0; width=77/2.0; height=432/2.0;
    if (self.datePickerMode==UIDatePickerModeDateAndTime) {
        width=width2;
    }
    UIImageView* right_imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [right_imgView setImage:[UIImage imageNamed:@"datePicker_right"]];
    [superView addSubview:right_imgView];
    [right_imgView release];
}

- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[[UIDatePicker alloc] initWithFrame:datePickerFrame] autorelease];
    datePicker.datePickerMode = self.datePickerMode;
    [datePicker setDate:self.selectedDate animated:NO];
    [datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
    //编辑添加自定义图片
    [self addSelfDefineImages:datePicker];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing (not used in this picker, but just in case somebody uses this as a template for another picker)
    self.pickerView = datePicker;
    
    return datePicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    if ([target respondsToSelector:action])
        objc_msgSend(target, action, self.selectedDate, origin);
    else
        NSAssert(NO, @"Invalid target/action ( %s / %@ ) combination used for ActionSheetPicker", object_getClassName(target), NSStringFromSelector(action));
}

- (void)eventForDatePicker:(id)sender {
    if (!sender || ![sender isKindOfClass:[UIDatePicker class]])
        return;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.selectedDate = datePicker.date;
}

- (void)customButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %d, custom button count: %d", index, self.customButtons.count);    
    NSAssert([self.pickerView respondsToSelector:@selector(setDate:animated:)], @"Bad pickerView for ActionSheetDatePicker, doesn't respond to setDate:animated:");
    NSDictionary *buttonDetails = [self.customButtons objectAtIndex:index];
    NSDate *itemValue = [buttonDetails objectForKey:@"buttonValue"];
    UIDatePicker *picker = (UIDatePicker *)self.pickerView;    
    [picker setDate:itemValue animated:YES];
    [self eventForDatePicker:picker];
}

@end
