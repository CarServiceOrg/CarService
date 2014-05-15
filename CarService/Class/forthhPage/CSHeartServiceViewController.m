//
//  CSHeartServiceViewController.m
//  CarService
//
//  Created by baidu on 14-5-15.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSHeartServiceViewController.h"

@interface CSHeartServiceViewController ()

@end

@implementation CSHeartServiceViewController
@synthesize backView;
@synthesize backScrollView;
@synthesize textFiled1;
@synthesize textFiled2;
@synthesize textFiled3;
@synthesize textFiled4;
@synthesize textFiled5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [backView release];
    [backScrollView release];
    [textFiled5 release];
    [textFiled4 release];
    [textFiled3 release];
    [textFiled2 release];
    [textFiled1 release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender
{
    NSLog(@"confirmButtonPressed");
}

- (void)hideKeyBoard
{
    [self.textFiled1 resignFirstResponder];
    [self.textFiled2 resignFirstResponder];
    [self.textFiled3 resignFirstResponder];
    [self.textFiled4 resignFirstResponder];
    [self.textFiled5 resignFirstResponder];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //点击页面使键盘消失
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.frame.size.width, self.backScrollView.frame.size.height + 5);

    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KeyBoradNotification

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"enter here");
    CGFloat startY = 0;
    if (Is_iPhone5)
    {
        if ((self.textFiled1 == textField)||(self.textFiled2 == textField)||(self.textFiled3 == textField))
        {
            startY = 0;
        }
        else if (self.textFiled4 == textField)
        {
            startY = -120;
        }
        else
        {
            startY = -150;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, startY, self.backView.frame.size.width, self.backView.frame.size.height);
            
        }
        else
        {
            self.backView.frame = CGRectMake(0,startY, self.backView.frame.size.width, self.backView.frame.size.height);
            
            
        }
    }];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    /*NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, -150, self.backView.frame.size.width, self.backView.frame.size.height);

        }
        else
        {
            self.backView.frame = CGRectMake(0, -150, self.backView.frame.size.width, self.backView.frame.size.height);
            
            
        }
    }];*/
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
            
        }
        else
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
            
        }
    }];
    
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark - UIGesture Delegate Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
