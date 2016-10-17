//
//  ViewController.m
//  ChatRoom
//
//  Created by Groupfly on 16/9/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"

#import "VPImageCropperViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "EDCollectionCell.h"

static CGFloat screenWidth ;
static CGFloat screenHeight ;

@interface ViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSOperationQueue *_queue;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (nonatomic,strong) CIImage *baseImage;

@property (nonatomic,strong) CIContext *context;

@property (nonatomic,strong) CIFilter *firstFilter;

@property (nonatomic,strong) CIFilter *secondFilter;

@property (nonatomic,strong) CIFilter *thirdFilter;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UILabel *la;

@end

@implementation ViewController

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        /*
         
         UICollectionViewScrollDirectionVertical展示的布局：
         1 2 3
         4 5 6
         7
         
         */
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, screenWidth,180) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化操作队列
//    _queue = [[NSOperationQueue alloc] init];
    
    /*
     
     1、NSBlockOperation
     2、NSInvocationOperation
     
     NSOperationQueue
     
     */
    // 1. 下载
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"下载 %@" , [NSThread currentThread]);
//    }];
//    // 2. 滤镜
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"滤镜 %@" , [NSThread currentThread]);
//    }];
//    // 3. 显示
//    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"更新UI %@" , [NSThread currentThread]);
//    }];
//    
//    // 添加操作之间的依赖关系，所谓“依赖”关系，就是等待前一个任务完成后，后一个任务才能启动
//    // 依赖关系可以跨线程队列实现
//    // 提示：在指定依赖关系时，注意不要循环依赖，否则不工作。
//    [op2 addDependency:op1];
//    [op3 addDependency:op2];
//    //    [op1 addDependency:op3];
//    
//    [_queue addOperation:op1];
//    [_queue addOperation:op2];
//    [[NSOperationQueue mainQueue] addOperation:op3];
    
    UILabel *la = [UILabel new];
    la.frame = CGRectMake(10, 80, 80, 30);
    la.text = @"测试用例";
    la.backgroundColor = [UIColor orangeColor];
    self.la = la;
    [self.view addSubview:la];
    
    la.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [la addGestureRecognizer:longpress];
}

- (void)longPress:(UILongPressGestureRecognizer *)longpress{
    
    CGPoint point = [longpress locationInView:longpress.view];
    
    UIMenuItem *pasteItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copystr:)];
    UIMenuItem *transItem = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(trans:)];
    UIMenuItem *collectItem = [[UIMenuItem alloc]initWithTitle:@"收藏" action:@selector(collect:)];
    UIMenuItem *joinItem = [[UIMenuItem alloc]initWithTitle:@"加入" action:@selector(join:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[pasteItem,transItem,collectItem,joinItem]];
    [menu setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:longpress.view];
    menu.arrowDirection = UIMenuControllerArrowDown;
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder{
    NSLog(@"canBecomeFirstResponder");
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copystr:) || action == @selector(trans:) || action == @selector(collect:) || action == @selector(join:)){
        return YES;
    }
    
    return NO;
}

- (void)copystr:(UIMenuController *)menuController{
    NSLog(@"===copystr");
}

- (void)trans:(UIMenuController *)menuController{
    NSLog(@"===trans");
}

- (void)collect:(UIMenuController *)menuController{
    NSLog(@"===collect");
}
- (void)join:(UIMenuController *)menuController{
    NSLog(@"===join");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   
}


- (void)usageOfollectionView{
    //    隐藏原有视图
    [self.imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EDCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EDCollectionCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;   // section数量
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;   // 每个section里面有多少项
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{   // 每一项对应的内容
    EDCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"EDCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    cell.label.text = [NSString stringWithFormat:@"农夫山泉-%zd",indexPath.item];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){screenWidth/2,60};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        
        UICollectionViewFlowLayout *lay = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        if (lay.scrollDirection == UICollectionViewScrollDirectionVertical) {
            NSLog(@"UICollectionViewScrollDirectionVertical");
            
            return UIEdgeInsetsMake(0, 0, 10, 0);// 相邻section间的间距
        }else{
            NSLog(@"UICollectionViewScrollDirectionHorizontal");
            
            return UIEdgeInsetsMake(0, 0, 0, 0);// 相邻section间的间距
        }
        
    }
    
    return UIEdgeInsetsZero;// 相邻section间的间距
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;   // 同一个section中相邻item的间距
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)filter{
    NSArray *properties = [CIFilter filterNamesInCategory: kCICategoryBuiltIn];
    
    NSLog(@"%@", properties);
    
    for (NSString *filterName in properties) {
        
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
    
    self.baseImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"0"]];
    
    // 创建基于GPU的CIContext对象
    self.context = [CIContext contextWithOptions: nil];
    
    // 创建基于CPU的CIContext对象
    //self.context = [CIContext contextWithOptions: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    
    // 1、棕黑
    self.firstFilter = [CIFilter filterWithName:@"CISepiaTone"];
    
    // 2、CIGaussianBlur
    self.secondFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
}

- (IBAction)takePhoto:(UIBarButtonItem *)sender {
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"手机相册", nil];
//    [actionSheet showInView:self.view];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    NSLog(@"baseImage---%@,context---%@",self.baseImage,self.context);
//    
//    UIImageView *firImgView = self.imageViews[0];
//    // 设置滤镜参数
//    [self.firstFilter setValue:@0.75 forKey:@"inputIntensity"];
//    [self.firstFilter setValue:self.baseImage forKey:@"inputImage"];
//    
//    // 得到过滤后的图片
//    CIImage *outputImage = [self.firstFilter outputImage];
//    // 转换图片
//    CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
//    
//    // 显示图片
//    [firImgView setImage:newImg];
//    // 释放C对象
//    //    CGImageRelease(cgimg);
//    
//    UIImageView *secImageView = self.imageViews[1];
//    [self.secondFilter setValue:@5 forKey:@"inputRadius"];
//    [self.secondFilter setValue:self.baseImage forKey:@"inputImage"];
//    
//    // 得到过滤后的图片
//    outputImage = [self.secondFilter outputImage];
//    // 转换图片
//    cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//    newImg = [UIImage imageWithCGImage:cgimg];
//    
//    // 显示图片
//    [secImageView setImage:newImg];
//    // 释放C对象
//    CGImageRelease(cgimg);
//    
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != 2) { // 没有点击取消
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        if (buttonIndex == 0) {
            NSLog(@"拍照");
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else if (buttonIndex == 1){
            NSLog(@"手机相册");
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:imagePickerController animated:true completion:nil];
    }
}

#pragma mark -- UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"info---%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        self.baseImage = [[CIImage alloc]initWithImage:portraitImg];
        
    }];
}




#pragma mark -- VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    
    NSArray *styles = @[@"CIAdditionCompositing",@"CIHardLightBlendMode",@"CISepiaTone",@"CIVignette",@"CIExposureAdjust ",@"CIColorBurnBlendMode",@"CIFalseColo",@"CILinearGradient",@"CILuminosityBlendMode"];
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        imageView.image = editedImage;
        
        CIImage *imageToFilter ;
        imageToFilter = [[CIImage alloc]initWithImage:imageView.image];
        
        CIFilter *activeFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [activeFilter setDefaults];
        [activeFilter setValue:@0.75 forKey:@"inputIntensity"];
        
        [activeFilter setValue:imageToFilter forKey:@"inputImage"];
        
        CIImage *filterImage = [activeFilter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:filterImage fromRect:[imageToFilter extent]];
        UIImage *myNewImage = [UIImage imageWithCGImage:cgImage];
        
        imageView.image = myNewImage;
        
        CGImageRelease(cgImage);
        
        //        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        //        [library writeImageToSavedPhotosAlbum:cgImage
        //                                     metadata:[saveToSave properties]
        //                              completionBlock:^(NSURL *assetURL, NSError *error) {
        //                                  CGImageRelease(cgImage);
        //                              }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
