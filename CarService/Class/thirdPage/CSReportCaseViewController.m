//
//  CSReportCaseViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSReportCaseViewController.h"
#import "ApplicationPublic.h"
#import "ActionSheetDatePicker.h"
#import "BlockActionSheet.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImagePLCategory.h"
#import "StyledPageControl.h"
#import "CSExampleReferViewController.h"

@interface CSReportCaseViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate>{
    UIView* _placeHolderView;
}

@end

@implementation CSReportCaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_selfView
{
    float x, y, width, height;
    
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];
    
    x=0; y=0; width=42; height=28;
    UIButton* photeBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [photeBtn setImage:[UIImage imageNamed:@"shibubaoan_canama.png"] forState:UIControlStateNormal];
    [photeBtn setImage:[UIImage imageNamed:@"shibubaoan_canama_press.png"] forState:UIControlStateHighlighted];
    [photeBtn addTarget:self action:@selector(photeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:photeBtn] autorelease];
    [photeBtn release];

    x=0; y=0; width=320;
    if (Is_iPhone5) {
        height=1136/2.0;
    }else{
        height=960/2.0;
    }
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone5.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone4.png"]];
    }
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    [bgImageView release];
    
    //车牌号
    x=10; y=20; width=320-10*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"时间" with_delegate:self];
    
    //发动机号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"地点" with_delegate:self];
    
    y=y+height+15; height=180;
    {
        UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImgView setImage:[[UIImage imageNamed:@"black_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self.view addSubview:bgImgView];
        [bgImgView release];
    }
    //滚动视图
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [scrollView setTag:103];
    [scrollView setDelegate:self];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    {
        for(UIView* subview in scrollView.subviews){
            [subview removeFromSuperview];
        }
        
        _placeHolderView=[[UIView alloc] initWithFrame:scrollView.bounds];
        [_placeHolderView setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:_placeHolderView];
        
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 200, 150)];
        [imgView setImage:[UIImage imageNamed:@"shigubaoan_placeHolder.png"]];
        [_placeHolderView addSubview:imgView];
        [imgView release];
    }    
    
    y=y+height; height=20;
    StyledPageControl* pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(x,y,width,height)];
    [pageControl setTag:104];
	pageControl.hidesForSinglePage = NO;
    pageControl.userInteractionEnabled=NO;
	pageControl.backgroundColor = [UIColor clearColor];
    //(1)
    [pageControl setPageControlStyle:PageControlStyleWithPageNumber];
    //(2)
    //[pageControl setCoreNormalColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    //[pageControl setCoreSelectedColor:[UIColor colorWithRed:145/255.0 green:0.0 blue:0.0 alpha:1]];
    //(3)
    //[pageControl setPageControlStyle:PageControlStyleThumb];
    //[pageControl setThumbImage:[UIImage imageNamed:@"yonghumoshi_icon_5.png"]];
    //[pageControl setSelectedThumbImage:[UIImage imageNamed:@"yonghumoshi_icon_5_2.png"]];
    [self.view addSubview:pageControl];
    [pageControl release];

    //查看参考格式
    y=y+20; width=120; height=30;
    UIButton* referBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [referBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [referBtn setTitle:@"【查看参考格式】" forState:UIControlStateNormal];
    [referBtn setTitleColor:[UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1] forState:UIControlStateNormal];
    [referBtn setTitleColor:[UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1] forState:UIControlStateSelected];
    [referBtn addTarget:self action:@selector(referBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:referBtn];
    [referBtn release];
    
    //确定
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+15; height=48/2.0+10;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    [queryBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.title=@"事故报案";
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_placeHolderView release];
    [super dealloc];
}

#pragma mark - 本地函数
-(void)setUpPageView:(UIImage*)image{
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:103];
    if (scrollView) {
        if (scrollView.subviews.count==1) {
            [_placeHolderView removeFromSuperview];
        }
        
        UIView* pageView=[[UIView alloc] initWithFrame:CGRectMake(scrollView.subviews.count*scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        [pageView setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:pageView];
        [pageView release];

        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 200, 150)];
        [imgView setBackgroundColor:[UIColor clearColor]];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:image];
        [pageView addSubview:imgView];
        [imgView release];
        
        UIButton* deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width-30, scrollView.bounds.size.height-32, 26, 28)];
        [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"shigubaoan_delete.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"shigubaoan_delete_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [pageView addSubview:deleteBtn];
        [deleteBtn release];
        
        [scrollView setContentSize:CGSizeMake(scrollView.subviews.count*scrollView.bounds.size.width, scrollView.bounds.size.height)];
        [scrollView setContentOffset:CGPointMake((scrollView.subviews.count-1)*scrollView.bounds.size.width, 0) animated:YES];
        
        StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
        if (pageControl) {
            [pageControl setNumberOfPages:scrollView.subviews.count];
            [pageControl setCurrentPage:scrollView.subviews.count-1];
        }
    }
}

//https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Conceptual/TransitionGuide/Bars.html#//apple_ref/doc/uid/TP40013174-CH8-SW1
-(UIImage*)changeImageToCGImage:(UIImage*)image
{
    if (IsIOS6OrLower) {
        return image;
    }else{
        CGImageRef imageRef = image.CGImage;
        CGFloat targetWidth = 320*2;
        CGFloat targetHeight = 1*2;
        
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();
        if (bitmapInfo == kCGImageAlphaNone) {
            bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
        }
        CGContextRef bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
        CGImageRef ref = CGBitmapContextCreateImage(bitmap);
        UIImage* newImage = [UIImage imageWithCGImage:ref scale:2.0 orientation:UIImageOrientationUp];
        CGColorSpaceRelease(colorSpaceInfo);
        
        CGContextRelease(bitmap);
        CGImageRelease(ref);
        return  newImage;
    }
}

#pragma mark - 点击事件
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)photeBtnClick:(id)sender
{    
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    [sheet setDestructiveButtonWithTitle:@"拍 照" block:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.view.backgroundColor = [UIColor blackColor];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes =[NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            imagePickerController.showsCameraControls = YES;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            if (!IsIOS4OrLower) {
                [imagePickerController.navigationBar performSelector:@selector(setBackgroundImage:forBarMetrics:) withObject:[UIImage imageNamed:@"navigationBarSmall.png"] withObject:[NSNumber numberWithInt:0]];
            }
            [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:imagePickerController animated:YES];
            [imagePickerController release];
        }

    }];
    [sheet addButtonWithTitle:@"从相册选择" block:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.view.backgroundColor = [UIColor blackColor];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.mediaTypes =[NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            
            if (IsIOS6OrLower) {
                if (!IsIOS4OrLower) {
                    [imagePickerController.navigationBar performSelector:@selector(setBackgroundImage:forBarMetrics:) withObject:[UIImage imageNamed:@"navigationBarSmall.png"] withObject:[NSNumber numberWithInt:0]];
                }
            }else{
                if (!IsIOS4OrLower) {
                    [imagePickerController.navigationBar performSelector:@selector(setBackgroundImage:forBarMetrics:) withObject:[self changeImageToCGImage:[UIImage imageNamed:@"navigationBarSmall.png"]] withObject:[NSNumber numberWithInt:0]];
                }
            }
            [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:imagePickerController animated:YES];
            [imagePickerController release];
        }
    }];
    [sheet showInView:self.view];
}

-(void)queryBtnClick:(id)sender
{
    
}

-(void)deleteBtnClick:(UIButton*)sender
{

    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:103];
    if (scrollView) {
        if (scrollView.subviews.count==1) {
            [sender.superview removeFromSuperview];
            
            [scrollView addSubview:_placeHolderView];
            [scrollView setContentSize:scrollView.bounds.size];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
            if (pageControl) {
                [pageControl setNumberOfPages:0];
                [pageControl setCurrentPage:0];
            }
        }else{
            //如果子视图多余一个 判断是不是最后一个 最后一个和中间某一个offset不一致
            int index=0;
            UIView* indexView=[sender superview];
            for (UIView* subView in scrollView.subviews) {
                if ([subView isEqual:indexView]) {
                    break;
                }else{
                    index++;
                }
            }
            
            //设置偏移量
            if (index==(scrollView.subviews.count-1)) {
                [indexView removeFromSuperview];
                
                //设置内容视图大小
                [scrollView setContentSize:CGSizeMake(scrollView.subviews.count*scrollView.bounds.size.width, scrollView.bounds.size.height)];
                [scrollView setContentOffset:CGPointMake((scrollView.subviews.count-1)*scrollView.bounds.size.width, 0) animated:YES];
           
                StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
                if (pageControl) {
                    [pageControl setNumberOfPages:scrollView.subviews.count];
                    [pageControl setCurrentPage:scrollView.subviews.count-1];
                }
            }else{
                [indexView removeFromSuperview];

                //设置内容视图大小
                [scrollView setContentSize:CGSizeMake(scrollView.subviews.count*scrollView.bounds.size.width, scrollView.bounds.size.height)];
                //如果不是最后一个 偏移量不懂 后面视图向前移动
                for (int i=index; i<scrollView.subviews.count; i++) {
                    UIView* subView=[scrollView.subviews objectAtIndex:i];
                    subView.frame=CGRectMake(subView.frame.origin.x-subView.frame.size.width, subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
                }
                //
                StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
                if (pageControl) {
                    [pageControl setNumberOfPages:scrollView.subviews.count];
                    [pageControl setCurrentPage:index];
                }
            }
        }
    }
}

-(void)referBtnClick:(id)sender
{
    CSExampleReferViewController* ctrler=[[CSExampleReferViewController alloc] init];
    [self.navigationController pushViewController:ctrler animated:YES];
    [ctrler release];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
    }else if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //保存图片到相册
        [self saveToAlbumDelay:info];
    }
    [picker dismissModalViewControllerAnimated:NO];
    
    UIImage* recImage=(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    //recImage=[UIImage imageWithData:[[UIImage rotateImage:recImage] imageScaleToSize:CGSizeMake(600, 600) metaData:nil]];
    [self setUpPageView:recImage];
 }

-(void)saveToAlbumDelay:(NSDictionary *)info
{
    //后台线程上传图片获取网络返回结果
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存图片
        UIImageWriteToSavedPhotosAlbum((UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index=scrollView.contentOffset.x/scrollView.frame.size.width;
    StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
    if (pageControl) {
        [pageControl setCurrentPage:index];
    }
}

//手势拖动结束回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int index=scrollView.contentOffset.x/scrollView.frame.size.width;
    StyledPageControl* pageControl = (StyledPageControl*)[self.view viewWithTag:104];
    if (pageControl) {
        [pageControl setCurrentPage:index];
    }
}

#pragma mark - UITextFieldDelegate
// 选择查询日期
-(void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (selectedDate!=nil && element!=nil) {
        UITextField* textField = (UITextField*)element;
        if (textField) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString* formatStr=[formatter stringFromDate:selectedDate];
            [formatter release];
            [textField setText:formatStr];
        }
    }
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==101)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
        return NO;
    }
    
    return YES;
}

//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
