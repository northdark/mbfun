//
//  SUploadColllocationControlCenter.m
//  Wefafa
//
//  Created by chencheng on 15/8/14.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SUploadColllocationControlCenter.h"
#import "UzysAssetsPickerController.h"
#import "AppDelegate.h"
#import "SV2CropViewController.h"
#import "SEditeProductTagViewController.h"
#import "SAddProductTagViewController.h"
#import "SSelectProductImageViewController.h"
#import "SCRecorderViewController.h"
#import "SUsedProductViewController.h"

#import "Dialog.h"

#import "SPublishViewController.h"
#import "SV3VideoCropViewController.h"
#import "SAddProductTagViewController.h"
#import "SUtilityTool.h"

#define sizeK [UIScreen mainScreen].bounds.size.width/750.0

static UIWindow *g_cameraStartSlideWindow = nil;



static SUploadColllocationControlCenter *g_uploadColllocationControlCenter = nil;

/**
 *   创建搭配的控制中心类——该类为单例模式
 */
@interface SUploadColllocationControlCenter ()<UzysAssetsPickerControllerDelegate, SCRecorderViewControllerDelegate>
{
    __weak UIViewController *_uploadColllocationPreViewController;//进入创建搭配之前的视图控制器
    
    __weak UzysAssetsPickerController *_homeViewController;//首页的系统相册
    __weak SCRecorderViewController *_homeCameraViewController;//首页的相机
    __weak SV2CropViewController *_cropController;//图片和视频裁切
    __weak SV3VideoCropViewController *_v3VideoCropViewController;
    __weak SAddProductTagViewController *_addProductTagViewController;// 添加单品标签
    __weak SPublishViewController *_publishViewController;//发布搭配页面
}

@end

@implementation SUploadColllocationControlCenter

+ (void)initialize
{
    if (g_uploadColllocationControlCenter == nil)
    {
        g_uploadColllocationControlCenter = [[SUploadColllocationControlCenter alloc] init];
    }
}

+ (SUploadColllocationControlCenter *)shareSUploadColllocationControlCenter
{
    return g_uploadColllocationControlCenter;
}

#pragma mark - 跳转控制接口

/**
 *   退出创建搭配
 */
- (void)exitUploadColllocationWithAnimated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[AppDelegate rootViewController] popToViewController:_uploadColllocationPreViewController animated:animated];
}

/**
 *   返回上级页面
 */
- (void)backtoPreViewWithAnimated:(BOOL)animated
{
    if ([AppDelegate rootViewController].topViewController == _cropController
        ||[AppDelegate rootViewController].topViewController == _v3VideoCropViewController)
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    [[AppDelegate rootViewController] popViewControllerAnimated:animated];
}

/**
 *   返回上级页面
 */
- (void)dismissToPreViewWithAnimated:(BOOL)animated
{
    UIViewController *topViewController = [AppDelegate rootViewController].topViewController;
    
    if (animated)
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
        
        [[AppDelegate shareAppdelegate].window addSubview:topViewController.view];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            topViewController.view.layer.transform = CATransform3DMakeTranslation(0, UI_SCREEN_HEIGHT, 0);
            
        } completion:^(BOOL finished) {
            [topViewController.view removeFromSuperview];
        }];
    }
    else
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    }
}

/**
 *   显示创建搭配的首页——选择系统相册里面的照片或视频
 */
- (void)showUploadColllocationHomeViewWithAnimated:(BOOL)animated
{
    if (![BaseViewController pushLoginViewController])
    {
        return;
    }
    
    [[SUploadColllocationControlCenter  shareSUploadColllocationControlCenter] showUploadColllocationHomeView2WithAnimated:animated animatedCompletion:nil allCompletion:nil];
}

/**
 *   显示创建搭配的首页——选择系统相册里面的照片或视频
 */
- (void)showUploadColllocationHomeViewWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    if (_homeViewController != nil)
    {
        [[AppDelegate rootViewController] popToViewController:_homeViewController animated:YES];
        return;
    }

    
    UzysAssetsPickerController *homeViewController = nil;
    
    if (_homeViewController == nil)
    {
        homeViewController = [[UzysAssetsPickerController alloc] init];
        
        homeViewController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        homeViewController.maximumNumberOfSelectionMedia = 1;
        homeViewController.showCameraCell = YES;
        
        homeViewController.assetsFilter = [ALAssetsFilter allAssets];
        
        _homeViewController = homeViewController;
    }
    
    [[AppDelegate rootViewController] presentViewController:_homeViewController animated:animated completion:^{
        
        if (completion != nil)
        {
            completion();
        }
    }];
    
}


/**
 *   显示创建搭配的首页:方案2——选择系统相册里面的照片或视频
 */
- (void)showUploadColllocationHomeView2WithAnimated:(BOOL)animated animatedCompletion:(void (^)(void))animatedCompletion allCompletion:(void (^)(void))allCompletion
{
    if (_homeViewController != nil)
    {
        [[AppDelegate rootViewController] popToViewController:_homeViewController animated:YES];
        return;
    }
    
    
    
    [AppDelegate shareAppdelegate].window.userInteractionEnabled = NO;
    
    UzysAssetsPickerController *homeViewController = nil;
    
    if (_homeViewController == nil)
    {
        homeViewController = [[UzysAssetsPickerController alloc] init];
        
        homeViewController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        homeViewController.maximumNumberOfSelectionMedia = 1;
        homeViewController.showCameraCell = YES;
        
        homeViewController.automaticallyAdjustsScrollViewInsets = NO;
        
        homeViewController.assetsFilter = [ALAssetsFilter allAssets];
        
        _homeViewController = homeViewController;
    }
    
    UzysAssetsPickerController *strongHomeViewController = _homeViewController;
    
    if (_uploadColllocationPreViewController == nil)
    {
        _uploadColllocationPreViewController = [AppDelegate rootViewController].topViewController;
    }
    

    if (animated)
    {
        CATransform3D backupTransform = strongHomeViewController.view.layer.transform;
        
        strongHomeViewController.view.frame = [AppDelegate shareAppdelegate].window.bounds;
        strongHomeViewController.view.layer.transform = CATransform3DMakeTranslation(0, UI_SCREEN_HEIGHT, 0);
        
        [[AppDelegate shareAppdelegate].window addSubview:strongHomeViewController.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            strongHomeViewController.view.layer.transform = backupTransform;
            
        } completion:^(BOOL finished) {
            
            if (animatedCompletion != nil)
            {
                animatedCompletion();
            }

            
            [strongHomeViewController.view removeFromSuperview];
            [[AppDelegate rootViewController] pushViewController:strongHomeViewController animated:NO];
            
            [AppDelegate shareAppdelegate].window.userInteractionEnabled = YES;
            
            if (allCompletion != nil)
            {
                allCompletion();
            }
        }];
    }
    else
    {
        if (animatedCompletion != nil)
        {
            animatedCompletion();
        }

        [[AppDelegate rootViewController] pushViewController:strongHomeViewController animated:NO];
        
        [AppDelegate shareAppdelegate].window.userInteractionEnabled = YES;
        
        if (allCompletion != nil)
        {
            allCompletion();
        }
    }
    
    
    //支持H5的测试代码
    
    /*UzysAssetsPickerController *homeViewController = nil;
    
    if (_homeViewController == nil)
    {
        homeViewController = [[UzysAssetsPickerController alloc] init];
        
        homeViewController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        homeViewController.maximumNumberOfSelectionMedia = 5;
        homeViewController.showCameraCell = NO;
        
        homeViewController.assetsFilter = [ALAssetsFilter allPhotos];
        
        _homeViewController = homeViewController;
    }
    
    [[AppDelegate rootViewController] presentViewController:_homeViewController animated:animated completion:^{
        
        
    }];*/

}


/**
 *   显示首页相机视图
 */
- (void)showHomeCameraViewWithAnimated:(BOOL)animated
{
    [self showHomeCameraViewWithAnimated:animated completionSection1:nil completionSection2:nil];
}


- (void)showHomeCameraViewWithAnimated:(BOOL)animated completionSection1:(void (^)(void))completionSection1 completionSection2:(void (^)(void))completionSection2
{
    SCRecorderViewController *homeCameraViewController = nil;
    
    if (_homeCameraViewController == nil)
    {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
        homeCameraViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCameraStoryBoardID"];
        homeCameraViewController.recorderStyle = RecorderViewPhotoAndVideoStyle;
        homeCameraViewController.delegate = self;
        homeCameraViewController.animatedBack = YES;
        [homeCameraViewController setHidesBottomBarWhenPushed:YES];
        _homeCameraViewController = homeCameraViewController;
    }
    
    //[[AppDelegate rootViewController] pushViewController:_homeCameraViewController animated:NO];
    
    SCRecorderViewController *strongHomeCameraViewController = _homeCameraViewController;
    
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = [AppDelegate rootViewController].view.frame;
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
            
        } completion:^(BOOL finished) {
            
            if (completionSection1 != nil)
            {
                completionSection1();
            }
            
            [[AppDelegate rootViewController] pushViewController:strongHomeCameraViewController animated:NO];
            
            [UIView animateWithDuration:0.3     delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
                
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                
                g_cameraStartSlideWindow = nil;
                
                if (completionSection2 != nil)
                {
                    completionSection2();
                }

            }];
            
        }];
    }
}

/**
 *   关闭相机视图
 */
- (void)closeCameraViewWithAnimated:(BOOL)animated
{
    
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
            
            
            
        } completion:^(BOOL finished) {
            
            [[AppDelegate rootViewController] popViewControllerAnimated:NO];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                g_cameraStartSlideWindow = nil;
            }];
        }];
    }
    else
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    }
}



/**
 *   显示创建搭配的照片裁剪视图
 */
- (void)showCropViewWithImage:(UIImage *)image animated:(BOOL)animated
{
    SV2CropViewController *cropController = nil;
    
    if (_cropController == nil)
    {
        cropController = [[SV2CropViewController alloc] init];
        _cropController = cropController;
        
    }
    
    _cropController.back = ^(){
        
        if (_homeCameraViewController == nil)
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }
        else
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }
    };
    
    _cropController.didFinishCropImage = ^(UIImage *cropImage){
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showAddProductTagViewWithImage:cropImage animated:YES];
        
    };

    
    _cropController.image = image;
    
    [[AppDelegate rootViewController] pushViewController:_cropController animated:animated];
}


/**
 *   显示创建搭配的视频裁剪视图
 */
- (void)showCropViewWithVideoURL:(NSURL *)videoURL videoDuration:(float)videoDuration animated:(BOOL)animated
{
    SV2CropViewController *cropController = nil;
    
    
    if (_cropController == nil)
    {
        cropController = [[SV2CropViewController alloc] init];
        _cropController = cropController;
    }
    
    _cropController.back = ^(){
        
        if (_homeCameraViewController == nil)
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }
        else
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }

    };
    
   _cropController.didFinishCropVideo = ^(NSURL *cropVideoURL){
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showAddProductTagViewWithVideoURL:cropVideoURL animated:YES];
    };
    
    _cropController.didFinishCropVideo = ^(NSURL *cropVideoURL){
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showAddProductTagViewWithVideoURL:cropVideoURL  animated:YES];
    };
    
    _cropController.videoURL = videoURL;
    _cropController.videoDuration = videoDuration;
    
    [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationNone completion:^(BOOL finished) {
        
    }];
    
    [[AppDelegate rootViewController] pushViewController:_cropController animated:animated];
}

/**
 *   显示创建搭配的视频裁剪视图
 */
- (void)showV3VideoCropViewWithAsset:(AVAsset *)avAsset videoSize:(CGSize)videoSize animated:(BOOL)animated
{
    SV3VideoCropViewController *v3VideoCropViewController = nil;
    
    if (_v3VideoCropViewController == nil)
    {
        v3VideoCropViewController = [[SV3VideoCropViewController alloc] init];
        _v3VideoCropViewController = v3VideoCropViewController;
    }
    
    _v3VideoCropViewController.back = ^(){
        
        if (_homeCameraViewController == nil)
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }
        else
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        }
    };
    
    _v3VideoCropViewController.didFinishCropVideo = ^(NSURL *cropVideoURL){
        
        NSLog(@"开始显示下一页");
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showAddProductTagViewWithVideoURL:cropVideoURL animated:YES];
    };
    
    _v3VideoCropViewController.asset = avAsset;
    _v3VideoCropViewController.videoSize = videoSize;
    
    [[AppDelegate rootViewController] pushViewController:_v3VideoCropViewController animated:animated];

}

/**
 *   显示添加单品标签视图
 */
- (void)showAddProductTagViewWithImage:(UIImage *)image animated:(BOOL)animated
{
    SAddProductTagViewController *addProductTagViewController = nil;
    
    if (_addProductTagViewController == nil)
    {
        addProductTagViewController = [[SAddProductTagViewController alloc] init];
        _addProductTagViewController = addProductTagViewController;
    }
    
    _addProductTagViewController.back = ^(){
    
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _addProductTagViewController.didFinishProductTag = ^(NSArray *productTagInfoArray,CGSize imgSize){
    
//        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showPublishViewWithAnimated:YES];
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showPublishViewWithProductArray:productTagInfoArray productImage:image imageSize:imgSize productVideo:nil animated:YES];
    };
    
    _addProductTagViewController.image = image;
    [[AppDelegate rootViewController] pushViewController:_addProductTagViewController animated:animated];
}

/**
 *   显示添加单品标签视图
 */
- (void)showAddProductTagViewWithVideoURL:(NSURL *)videoURL animated:(BOOL)animated
{
    SAddProductTagViewController *addProductTagViewController = nil;
    
    
    if (_addProductTagViewController == nil)
    {
        addProductTagViewController = [[SAddProductTagViewController alloc] init];
        _addProductTagViewController = addProductTagViewController;
    }
    
    _addProductTagViewController.back = ^(){
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _addProductTagViewController.didFinishProductTag = ^(NSArray *productTagInfoArray,CGSize imgSize){
        
//        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showPublishViewWithProductArray:productTagInfoArray animated:YES];
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showPublishViewWithProductArray:productTagInfoArray productImage:_addProductTagViewController.videoImage imageSize:imgSize productVideo:videoURL animated:YES];
    };

    _addProductTagViewController.videoURL = videoURL;
    
    [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationNone completion:^(BOOL finished) {
        
    }];
    
    [[AppDelegate rootViewController] pushViewController:_addProductTagViewController animated:animated];
}

/**
 *   显示发布搭配视图
 */
- (void)showPublishViewWithProductArray:(NSArray*)array productImage:(UIImage*)image imageSize:(CGSize)Imgsize productVideo:(NSURL*)video animated:(BOOL)animated
{
    SPublishViewController *publishViewController = nil;
    
    
    if (_publishViewController == nil)
    {
        publishViewController = [[SPublishViewController alloc] init];
        publishViewController.productArray=array;
        publishViewController.videoURL=video;
        publishViewController.ProductImage=image;
        publishViewController.ImgSize=Imgsize;
        
        _publishViewController = publishViewController;
    }
    
    _publishViewController.back = ^(){
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
        
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_publishViewController animated:animated];
}

///**
// *   显示发布搭配视图
// */
//- (void)showPublishViewWithAnimated:(BOOL)animated
//{
//    SPublishViewController *publishViewController = nil;
//    
//    
//    if (_publishViewController == nil)
//    {
//        publishViewController = [[SPublishViewController alloc] init];
//        publishViewController.productArray=nil;
//        _publishViewController = publishViewController;
//    }
//    
//    _publishViewController.back = ^(){
//        
//        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] backtoPreViewWithAnimated:YES];
//        
//    };
//
//    
//    [[AppDelegate rootViewController] pushViewController:_publishViewController animated:animated];
//}

#pragma mark - UzysAssetsPickerControllerDelegate接口

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissToPreViewWithAnimated:YES];
}

- (void)uzysAssetsPickerControllerDidPickingCamera:(UzysAssetsPickerController *)picker
{
    //[[AppDelegate shareAppdelegate].window addSubview:_homeViewController.view];
    
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showHomeCameraViewWithAnimated:YES completionSection1:^{
        
        [self dismissToPreViewWithAnimated:NO];
        
        //[_homeViewController.view removeFromSuperview];
        
    } completionSection2:^{
        
    }];
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([assets count] == 0)
    {
        return;
    }
    else if ([assets count] == 1) //单选模式
    {
        ALAsset *asset = assets[0];
        
        NSString *assetTypeString = [asset valueForProperty:ALAssetPropertyType];
        if([assetTypeString isEqualToString:ALAssetTypePhoto]) //图片
        {
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            UIImage *pickingImage = nil;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                   scale:defaultRepresentation.scale
                                             orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([asset aspectRatioThumbnail] != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showCropViewWithImage:pickingImage animated:YES];
            
        }
        else if ([assetTypeString isEqualToString:ALAssetTypeVideo])//视频
        {
            AVAsset *avAsset = [AVAsset assetWithURL:asset.defaultRepresentation.url];
            
            if (avAsset.duration.value/avAsset.duration.timescale > 60)
            {
                UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360*sizeK, 200*sizeK)];
                dialogView.backgroundColor = [UIColor blackColor];
                dialogView.layer.cornerRadius = 8;
                dialogView.layer.masksToBounds = YES;
                dialogView.alpha = 1;
                
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/warning"]];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.frame = CGRectMake(158*sizeK, 40*sizeK, 44*sizeK, 44*sizeK);
                [dialogView addSubview:imageView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114*sizeK, dialogView.frame.size.width, 26*sizeK)];
                titleLabel.text = @"只能选择小于等于60秒的视频";
                titleLabel.font = FONT_t5;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [UIColor whiteColor];
                [dialogView addSubview:titleLabel];
                
                
                [CCDialog showDialogView:dialogView modal:YES showDialogViewAnimationOption:QFShowDialogViewAnimationFromCenter completion:^(BOOL finished) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationNone completion:^(BOOL finished) {
                            
                        }];
                    });
                    
                }];
            }
            else
            {
                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage] ;
                
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showV3VideoCropViewWithAsset:avAsset videoSize:image.size animated:NO];
            }
        }
    }
}


#pragma mark - SCRecorderViewControllerDelegate接口

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureImage:(UIImage *)image
{
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showCropViewWithImage:image animated:YES];
}

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureVideo:(AVAsset *)avAsset
{
    CGSize videoSize;
    
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    
    NSError *error=nil;
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    if(error == nil)
    {
        CMTimeShow(actualTime);
        UIImage *image=[UIImage imageWithCGImage:cgImage];
        
        videoSize = image.size;
        
        CGImageRelease(cgImage);
    }
    
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showV3VideoCropViewWithAsset:avAsset videoSize:videoSize animated:YES];
}

- (void)recorderViewControllerDidPickingSystemPhoto:(SCRecorderViewController *)recorderViewController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    
    
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeView2WithAnimated:YES animatedCompletion:^{
        
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] closeCameraViewWithAnimated:NO];
        
    } allCompletion:^{
        
    }];
}

- (void)recorderViewControllerDidCancel:(SCRecorderViewController *)recorderViewController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] closeCameraViewWithAnimated:YES];
}


@end
