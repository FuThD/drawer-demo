//
//  ViewController.m
//  chouti
//
//  Created by FTD on 15/12/16.
//  Copyright © 2015年 ftd. All rights reserved.
//

#import "ViewController.h"
#define QHY 80
#define MAXR 300
#define MAXL -245
@interface ViewController ()
@property (nonatomic , weak) UIView *zuov;
@property (nonatomic , weak) UIView *youv;
@property (nonatomic , weak) UIView *mainv;
@property (nonatomic , assign) BOOL ismove;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self chuangjianview];

    //KVO
    [self.mainv addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
}

//当添加监听方法的属性发生变化时调用
#pragma mark - /********************** observeValueForKeyPath **********************/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (self.mainv.frame.origin.x>0) {
        self.zuov.hidden = NO;
        self.youv.hidden = YES;
    }else{
        
        self.zuov.hidden = YES;
        self.youv.hidden = NO;
    }
    
}



#pragma mark - /********************** 创建view **********************/
-(void) chuangjianview{
    
    //创建一个左view
    UIView *zuov = [[UIView alloc]initWithFrame:self.view.bounds];
    zuov.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:zuov];
    self.zuov =zuov;
    
    //创建一个右view
    UIView *youv = [[UIView alloc]initWithFrame:self.view.bounds];
    youv.backgroundColor = [UIColor blueColor];
    [self.view addSubview:youv];
    self.youv = youv;
    
    //创建一个mainview
    UIView *mainv = [[UIView alloc]initWithFrame:self.view.bounds];
    mainv.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainv];
    self.mainv = mainv;
    
}

#pragma mark - /********************** touchesMoved **********************/
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    //获取现在的手指位置
    CGPoint newp = [touch locationInView:self.view];
    
    //获取上一个手指位置
    CGPoint lastp = [touch previousLocationInView:self.view];
    
    //计算偏移量
    CGFloat x = newp.x - lastp.x;
    
    //获取mainview的frame
    CGRect mainvf = self.mainv.frame;
    
    mainvf.origin.x += x;
    
//     //赋值frame
    self.mainv.frame = mainvf;
//    self.mainv.frame = [self frameWithx:x];
    
    self.ismove = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

#pragma mark - /********************** 根据x偏移量计算frame **********************/
-(CGRect)frameWithx : (CGFloat) x {
    
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    
    //求y轴偏移量
    CGFloat y  = x * QHY / sw;
    
    //求缩放比例
    CGFloat suo = (sh - y*2)/sh;
    
    //判断 如果mainv的x值为负值
    if (self.mainv.frame.origin.x < 0) {
        
        suo =  (sh + y*2)/sh;
    }
    
    CGRect fame = self.mainv.frame;
    fame.origin.x += x;
    fame.size.height = fame.size.height * suo;
    fame.size.width = fame.size.width * suo;
    fame.origin.y = (sh - fame.size.height) / 2;
    
    return fame;
    
}


#pragma mark - /********************** touchesEnded **********************/
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.ismove==NO && self.mainv.frame.origin.x != 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.mainv.frame = self.view.bounds;
        }];
    }
    
    CGRect frame = self.mainv.frame;
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat pian = 0;
    //当结束时 判断是否超过屏幕w的一半
    if (frame.origin.x > sw*0.5 ) {
        pian = MAXR;
    }else if( CGRectGetMaxX(self.mainv.frame) < sw*0.5 ){
        pian = MAXL;
        
    }
    
    if (pian == 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.mainv.frame = self.view.bounds;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            //获取偏移量
            CGFloat x = pian - frame.origin.x;
            
            self.mainv.frame = [self frameWithx:x];
        }];

    }
    self.ismove = NO;

}


@end
