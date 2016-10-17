//
//  GCDViewController.m
//  ChatRoom
//
//  Created by Groupfly on 16/9/12.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 
 一、NSThread
 1、NSThread是轻量级的多线程开发
 2、创建方法:
    a、+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument直接将操作添加到线程中并启动
    b、- (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(id)argument 创建一个线程对象，然后调用start方法启动线程
 
 */
- (void)aboutThread{
    
    // a
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];

    
    // b
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
    [thread start];
}
/**
 *  加载图片方法
 */
- (void)loadImage{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
