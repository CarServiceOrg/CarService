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
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "MBProgressHUD.h"

@interface CSReportCaseViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>{
    UIView* _placeHolderView;
    
    UIScrollView* view_ScrollView;  //用于iphone4上滚动显示
    UIScrollView* pic_ScrollView;   //用于所选或所照的图片
}

@property(readonly,assign)MBProgressHUD *alertView;

@end

@implementation CSReportCaseViewController
@synthesize alertView;

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
    //背景
    [ApplicationPublic selfDefineBg:self.view];
    //标题栏
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"事故咨询" withTarget:self with_action:@selector(backBtnClick:) rightBtn:self with_action:@selector(photeBtnClick:)];
    
    float x, y, width, height;
    
    //滚动视图
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    view_ScrollView=[[UIScrollView alloc] initWithFrame:frame];
    [view_ScrollView setContentSize:CGSizeMake(frame.size.width, 1136/2.0-20-(40+55))];
    view_ScrollView.backgroundColor=[UIColor clearColor];
    view_ScrollView.showsHorizontalScrollIndicator=NO;
    view_ScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:view_ScrollView];
    [view_ScrollView release];
    
    //车牌号
    x=5; y=10; width=view_ScrollView.frame.size.width-5*2; height=40;
    [ApplicationPublic setUp_UITextField:view_ScrollView with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"时间" with_delegate:self];
    
    //发动机号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:view_ScrollView with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"地点" with_delegate:self];
    
    y=y+height+15; height=180;
    {
        UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImgView setImage:[ApplicationPublic getOriginImage:@"new_baoanzixun_shiguzhaopianbeijing.png" withInset:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [view_ScrollView addSubview:bgImgView];
        [bgImgView release];
    }
    //滚动视图
    pic_ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [pic_ScrollView setDelegate:self];
    pic_ScrollView.backgroundColor=[UIColor clearColor];
    pic_ScrollView.pagingEnabled=YES;
    pic_ScrollView.showsHorizontalScrollIndicator=NO;
    pic_ScrollView.showsVerticalScrollIndicator=NO;
    [view_ScrollView addSubview:pic_ScrollView];
    [pic_ScrollView release];
    {
        for(UIView* subview in pic_ScrollView.subviews){
            [subview removeFromSuperview];
        }
        
        _placeHolderView=[[UIView alloc] initWithFrame:pic_ScrollView.bounds];
        [_placeHolderView setBackgroundColor:[UIColor clearColor]];
        [pic_ScrollView addSubview:_placeHolderView];
        
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
    [view_ScrollView addSubview:pageControl];
    [pageControl release];

    //查看参考格式
    y=y+20; width=120; height=30;
    UIButton* referBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [referBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [referBtn setTitle:@"【查看参考格式】" forState:UIControlStateNormal];
    [referBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [referBtn setTitleColor:[UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1] forState:UIControlStateHighlighted];
    [referBtn addTarget:self action:@selector(referBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_ScrollView addSubview:referBtn];
    [referBtn release];
    
    //确定
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+15; height=48/2.0+10;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_ScrollView addSubview:queryBtn];
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
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        [alertView release],alertView = nil;
    }

    [_placeHolderView release];
    [super dealloc];
}

#pragma mark - 本地函数
-(void)setUpPageView:(UIImage*)image{
    UIScrollView* scrollView=pic_ScrollView;
    if (scrollView) {
        if (scrollView.subviews.count==1) {
            [_placeHolderView removeFromSuperview];
        }
        
        UIView* pageView=[[UIView alloc] initWithFrame:CGRectMake(scrollView.subviews.count*scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        [pageView setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:pageView];
        [pageView release];

        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 200, 150)];
        [imgView setTag:1001];
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

#pragma mark - 网络请求

-(void)startHttpRequest{
    {
        self.alertView.mode = MBProgressHUDModeText;
        self.alertView.color=[UIColor darkGrayColor];
        self.alertView.labelText = NSLocalizedString(@"加载中...", nil);
        [self.alertView show:YES];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL backBool=[self startHttpRequest_report];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView hide:YES];
            if (backBool) {
                [self backBtnClick:nil];
            }else{
                [self showErrorMessage];
            }
        });
    });
}
/*
?json={"action":"accident_report",”addtime”:”2013-03-06”,”content”:”$content” ,”user_id”:”$user_id”}
 注：请用POST请求，图像name为file ,例如<input name="file" type="file" size="100"  />,
 PHP接收时$_FILES['file']
 */
-(BOOL)startHttpRequest_report
{
    UITextField* aTextField=(UITextField*)[view_ScrollView viewWithTag:101];
    NSString* dateStr=[NSString stringWithFormat:@"%@",aTextField.text];
    
    UITextField* bTextField=(UITextField*)[view_ScrollView viewWithTag:102];
    NSString* contentStr=[NSString stringWithFormat:@"%@",bTextField.text];
    
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"accident_report", @"action",
                            dateStr, @"addtime",
                            contentStr,@"content",
                            [[[Util sharedUtil] getUserInfo] objectForKey:@"id"], @"user_id",
                            nil];
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_report-->urlStr:%@",urlStr);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    for(UIView* subview in pic_ScrollView.subviews){
        UIImageView* imgView=(UIImageView*)[pic_ScrollView viewWithTag:1001];
        NSData *jpeg;
        jpeg = [NSData dataWithData:UIImageJPEGRepresentation(imgView.image, 0.85)];
        if ([jpeg length] == 0){
            jpeg = [NSData dataWithData:UIImagePNGRepresentation(imgView.image)];
        }
        [request addData:jpeg withFileName:@"file" andContentType:@"file" forKey:@"input"];
        [request setPostLength:jpeg.length];
    }
    [request startSynchronous];
    
    NSError* error=[request error];
    if (error) {
        return NO;
    }else{
        CustomLog(@"<<Chao-->CSSecondViewController-->startHttpRequest_report-->[request responseString] : %@",[request responseString]);
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_report-->requestDic:%@",requestDic);
        if ([requestDic objectForKey:@"status"]) {
            if ([[requestDic objectForKey:@"status"] intValue]==1) {
                return NO;
            }else if ([[requestDic objectForKey:@"status"] intValue]==0){
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)showErrorMessage{
    [ApplicationPublic showMessage:self with_title:@"上传数据失败！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
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
    //时间
    UITextField* aTextField=(UITextField*)[view_ScrollView viewWithTag:101];
    if (aTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请选择事故发生时间！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    //地点
    UITextField* bTextField=(UITextField*)[view_ScrollView viewWithTag:102];
    if (bTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请输入事故地点！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    
    if ([pic_ScrollView.subviews count]==1 && [pic_ScrollView.subviews objectAtIndex:0]==_placeHolderView) {
        [ApplicationPublic showMessage:self with_title:@"请上传事故图片！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }

    //开始网络请求
    [self startHttpRequest];
}

-(void)deleteBtnClick:(UIButton*)sender
{
    UIScrollView* scrollView=pic_ScrollView;
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
            [formatter setDateFormat:@"YYYY-MM-dd"];
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
        [ActionSheetDatePicker showPickerWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
        return NO;
    }
    
    return YES;
}

//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        [alertView release],alertView = nil;
    }
}
- (MBProgressHUD*) alertView
{
    if (alertView==nil) {
        id delegate = [UIApplication sharedApplication].delegate;
        UIWindow *window = [delegate window];
        alertView = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alertView];
        alertView.dimBackground = YES;
        alertView.labelText = NSLocalizedString(@"加载中", @"");
        alertView.delegate = self;
    }
    return alertView;
}

@end
