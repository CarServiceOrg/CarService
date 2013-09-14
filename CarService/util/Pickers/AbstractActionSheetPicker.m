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

#import "AbstractActionSheetPicker.h"
#import <objc/message.h>

#import "KSCustomPopoverBackgroundView.h"
#import <QuartzCore/QuartzCore.h> //layer you need this import

@interface AbstractActionSheetPicker()

@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL successAction;
@property (nonatomic, assign) SEL cancelAction;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) NSObject *selfReference;

- (void)presentPickerForView:(UIView *)aView;
- (void)configureAndPresentPopoverForView:(UIView *)aView;
- (void)configureAndPresentActionSheetForView:(UIView *)aView;
- (void)presentActionSheet:(UIActionSheet *)actionSheet;
- (void)presentPopover:(UIPopoverController *)popover;
- (void)dismissPicker;
- (BOOL)isViewPortrait;
- (BOOL)isValidOrigin:(id)origin;
- (id)storedOrigin;
- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle;
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)aTitle;
- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction;
- (IBAction)actionPickerDone:(id)sender;
- (IBAction)actionPickerCancel:(id)sender;
@end

@implementation AbstractActionSheetPicker
@synthesize title = _title;
@synthesize containerView = _containerView;
@synthesize barButtonItem = _barButtonItem;
@synthesize target = _target;
@synthesize successAction = _successAction;
@synthesize cancelAction = _cancelAction;
@synthesize actionSheet = _actionSheet;
@synthesize popOverController = _popOverController;
@synthesize selfReference = _selfReference;
@synthesize pickerView = _pickerView;
@dynamic viewSize;
@synthesize customButtons = _customButtons;
@synthesize hideCancel = _hideCancel;
@synthesize presentFromRect = _presentFromRect;

#pragma mark - Abstract Implementation

- (id)initWithTarget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin  {
    self = [super init];
    if (self) {
        self.target = target;
        self.successAction = successAction;
        self.cancelAction = cancelActionOrNil;
        self.presentFromRect = CGRectZero;
        
        if ([origin isKindOfClass:[UIBarButtonItem class]])
            self.barButtonItem = origin;
        else if ([origin isKindOfClass:[UIView class]])
            self.containerView = origin;
        else
            NSAssert(NO, @"Invalid origin provided to ActionSheetPicker ( %@ )", origin);
        
        //allows us to use this without needing to store a reference in calling class
        self.selfReference = self;
    }
    return self;
}

- (void)dealloc {
    //need to clear picker delegates and datasources, otherwise they may call this object after it's gone
    if ([self.pickerView respondsToSelector:@selector(setDelegate:)])
        [self.pickerView performSelector:@selector(setDelegate:) withObject:nil];
    
    if ([self.pickerView respondsToSelector:@selector(setDataSource:)])
        [self.pickerView performSelector:@selector(setDataSource:) withObject:nil];
    
    if (self.title) {
        self.title=nil;
    }
    if (self.pickerView) {
        self.pickerView=nil;
    }
    if (self.customButtons) {
        self.customButtons=nil;
    }
    if (self.barButtonItem) {
        self.barButtonItem=nil;
    }
    if (self.containerView) {
        self.containerView=nil;
    }
    if (self.actionSheet) {
        self.actionSheet=nil;
    }
    if (self.popOverController) {
        self.popOverController=nil;
    }
    if (self.target) {
        self.target=nil;
    }
    
    [super dealloc];
}

- (UIView *)configuredPickerView {
    NSAssert(NO, @"This is an abstract class, you must use a subclass of AbstractActionSheetPicker (like ActionSheetStringPicker)");
    return nil;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    NSAssert(NO, @"This is an abstract class, you must use a subclass of AbstractActionSheetPicker (like ActionSheetStringPicker)");
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

//For superclasses. 返回当前UIPicker的列数
- (int)getNumberOfColumn_fromSubclass{
    return -1;
}

#pragma mark - Actions

- (void)showActionSheetPicker {
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, 260)];    
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:self.title];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [masterView addSubview:pickerToolbar];
    self.pickerView = [self configuredPickerView];
    NSAssert(_pickerView != NULL, @"Picker view failed to instantiate, perhaps you have invalid component data.");
    [masterView addSubview:_pickerView];
    [self presentPickerForView:masterView];
    [masterView release];
}

- (IBAction)actionPickerDone:(id)sender {
    [self notifyTarget:self.target didSucceedWithAction:self.successAction origin:[self storedOrigin]];    
    [self dismissPicker];
}

- (IBAction)actionPickerCancel:(id)sender {
    [self notifyTarget:self.target didCancelWithAction:self.cancelAction origin:[self storedOrigin]];
    [self dismissPicker];
}

- (void)dismissPicker {
#if __IPHONE_4_1 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    if (self.actionSheet)
#else
    if (self.actionSheet && [self.actionSheet isVisible])
#endif
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    else if (self.popOverController && self.popOverController.popoverVisible)
        [_popOverController dismissPopoverAnimated:YES];
    self.actionSheet = nil;
    self.popOverController = nil;
    self.selfReference = nil;
}

#pragma mark - Custom Buttons

- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value {
    if (!self.customButtons)
        _customButtons = [[NSMutableArray alloc] init];
    if (!title)
        title = @"";
    if (!value)
        value = [NSNumber numberWithInt:0];
    NSDictionary *buttonDetails = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"buttonTitle", value, @"buttonValue", nil];
    [self.customButtons addObject:buttonDetails];
    [buttonDetails release];
}

- (IBAction)customButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %d, custom button count: %d", index, self.customButtons.count);
    NSAssert([self.pickerView respondsToSelector:@selector(selectRow:inComponent:animated:)], @"customButtonPressed not overridden, cannot interact with subclassed pickerView");
    NSDictionary *buttonDetails = [self.customButtons objectAtIndex:index];
    NSAssert(buttonDetails != NULL, @"Custom button dictionary is invalid");
    NSInteger buttonValue = [[buttonDetails objectForKey:@"buttonValue"] intValue];
    UIPickerView *picker = (UIPickerView *)self.pickerView;
    NSAssert(picker != NULL, @"PickerView is invalid");
    [picker selectRow:buttonValue inComponent:0 animated:YES];
    if ([self respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        void (*objc_msgSendTyped)(id self, SEL _cmd, id pickerView, NSInteger row, NSInteger component) = (void*)objc_msgSend; // sending Integers as params
        objc_msgSendTyped(self, @selector(pickerView:didSelectRow:inComponent:), picker, buttonValue, 0);
    }
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    CGRect frame = CGRectMake(0, 0, self.viewSize.width+2, 44);
    UIToolbar *pickerToolbar = [[[UIToolbar alloc] initWithFrame:frame] autorelease];
    //导航栏上的背景颜色
    //(1)
    //pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    //(2)
    UIColor* bgColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
    pickerToolbar.tintColor=bgColor;
    pickerToolbar.layer.borderColor=[bgColor CGColor];
    pickerToolbar.layer.borderWidth=1.0;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (NSDictionary *buttonDetails in self.customButtons) {
        NSString *buttonTitle = [buttonDetails objectForKey:@"buttonTitle"];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(customButtonPressed:)];
        button.tag = index;
        [barItems addObject:button];
        [button release];
        index++;
    }
    if (NO == self.hideCancel) {
        //(1)
        UIBarButtonItem *cancelBtn = [self createButtonWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(actionPickerCancel:)];
        [barItems addObject:cancelBtn];
        //(2)
        //UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
        ////[cancelBtn setTintColor:[UIColor blackColor]];
        //[barItems addObject:cancelBtn];        
    }
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    if (title){
        UIFont* titleFont=[UIFont systemFontOfSize:18.0];
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0 , [title sizeWithFont:titleFont].width, 44)] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = titleFont;  //设置文本字体与大小
        titleLabel.textColor = [UIColor blackColor];  //白色背景下：设置文本颜色
        //titleLabel.textColor = [UIColor whiteColor];  //黑色背景下：设置文本颜色
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = title;  //设置标题
        
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        labelButton.customView=titleLabel; 
        [barItems addObject:labelButton];    
        [barItems addObject:flexSpace];
    }
    {
        //(1)
        UIBarButtonItem *doneButton = [self createButtonWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(actionPickerDone:)];
        [barItems addObject:doneButton];
        [pickerToolbar setItems:barItems animated:YES];
        [barItems release];
        //(2)
        //UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
        //[barItems addObject:doneButton];
        //[pickerToolbar setItems:barItems animated:YES];
        //[barItems release];
    }
    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    [toolBarItemlabel setTextAlignment:UITextAlignmentCenter];    
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];    
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];    
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];    
    toolBarItemlabel.text = aTitle;    
    UIBarButtonItem *buttonLabel = [[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel] autorelease];
    [toolBarItemlabel release];    
    return buttonLabel;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction] autorelease];
}

- (UIBarButtonItem *)createButtonWithTitle:(NSString *)title style:(UIBarButtonItemStyle)type target:(id)target action:(SEL)buttonAction {
    return [[[UIBarButtonItem alloc] initWithTitle:title style:type target:target action:buttonAction] autorelease];
}

#pragma mark - Utilities and Accessors

- (CGSize)viewSize {
    if (![self isViewPortrait]){
        if ([self getNumberOfColumn_fromSubclass]==-1) {
            return CGSizeMake(320, 480);
        }else {
            return CGSizeMake(480, 320);
        }
    }else{
        if ([self getNumberOfColumn_fromSubclass]!=-1) {
            return CGSizeMake(480, 320);
        }
        return CGSizeMake(320, 480);
    }
    
//    if (![self isViewPortrait]){
//        return CGSizeMake(480, 320);
//    }else{
//        return CGSizeMake(320, 480);
//    }
}

- (BOOL)isViewPortrait {
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)isValidOrigin:(id)origin {
    if (!origin)
        return NO;
    BOOL isButton = [origin isKindOfClass:[UIBarButtonItem class]];
    BOOL isView = [origin isKindOfClass:[UIView class]];
    return (isButton || isView);
}

- (id)storedOrigin {
    if (self.barButtonItem)
        return self.barButtonItem;
    return self.containerView;
}

#pragma mark - Popovers and ActionSheets

- (void)presentPickerForView:(UIView *)aView {
    self.presentFromRect = aView.frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self configureAndPresentPopoverForView:aView];
    else
        [self configureAndPresentActionSheetForView:aView];
}

- (void)configureAndPresentActionSheetForView:(UIView *)aView {
    NSString *paddedSheetTitle = nil;
    CGFloat sheetHeight = self.viewSize.height - 47;
    if ([self isViewPortrait]) {
        paddedSheetTitle = @"\n\n\n"; // looks hacky to me
    } else {
        NSString *reqSysVer = @"5.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
            sheetHeight = self.viewSize.width;
        } else {
            sheetHeight += 103;
        }
    }
    _actionSheet = [[UIActionSheet alloc] initWithTitle:paddedSheetTitle delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [_actionSheet addSubview:aView];
    [self presentActionSheet:_actionSheet];
    _actionSheet.bounds = CGRectMake(0, 0, self.viewSize.width, sheetHeight);
}

- (void)presentActionSheet:(UIActionSheet *)actionSheet {
    NSParameterAssert(actionSheet != NULL);
    if (self.barButtonItem)
        [actionSheet showFromBarButtonItem:_barButtonItem animated:YES];
    else if (self.containerView && NO == CGRectIsEmpty(self.presentFromRect))
        [actionSheet showFromRect:_presentFromRect inView:_containerView animated:YES];
    else
        [actionSheet showInView:_containerView];
}

- (void)configureAndPresentPopoverForView:(UIView *)aView {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = aView;
    viewController.contentSizeForViewInPopover = viewController.view.frame.size;
    _popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    //(1)
    if ([_popOverController respondsToSelector:@selector(popoverBackgroundViewClass)]) {
       _popOverController.popoverBackgroundViewClass=[KSCustomPopoverBackgroundView class];
    }
    //(2) 4.x的私有方法 //对应的值有 0-黑色, 1-白色, 2-奶白色,
    //[_popOverController setValue:[NSNumber numberWithInt:2] forKey:@"popoverBackgroundStyle"];
    _popOverController.delegate=self;
    [self presentPopover:_popOverController];
    [viewController release];
}

- (void)presentPopover:(UIPopoverController *)popover {
    NSParameterAssert(popover != NULL);
    if (self.barButtonItem) {
        [popover presentPopoverFromBarButtonItem:_barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return;
    }
    else if ((self.containerView) && NO == CGRectIsEmpty(self.presentFromRect)) {
        [popover presentPopoverFromRect:_containerView.frame inView:_containerView.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return;
    }
    // Unfortunately, things go to hell whenever you try to present a popover from a table view cell.  These are failsafes.
    UIView *origin = nil;
    CGRect presentRect = CGRectZero;
    @try {
        origin = (_containerView.superview ? _containerView.superview : _containerView);
        presentRect = origin.bounds;
        [popover presentPopoverFromRect:presentRect inView:origin permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    @catch (NSException *exception) {
        origin = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
        presentRect = CGRectMake(origin.center.x, origin.center.y, 1, 1);
        [popover presentPopoverFromRect:presentRect inView:origin permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate

//代理回调函数 当点击其他区域时 
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (popoverController) {
        [self notifyTarget:self.target didCancelWithAction:self.cancelAction origin:[self storedOrigin]];
        [self dismissPicker];
	}
}

@end

