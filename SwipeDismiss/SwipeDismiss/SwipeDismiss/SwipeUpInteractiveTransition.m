//
//  SwipeUpInteractiveTransition.m
//  Miyo
//
//  Created by Miyo on 23/7/12.
//
//

#import "SwipeUpInteractiveTransition.h"

@interface SwipeUpInteractiveTransition()<UIGestureRecognizerDelegate>
// 手势添加的View
@property (nonatomic, strong) UIViewController *gestureVC;
// 记录手势结束前的点击位置
@property (nonatomic, assign) CGPoint oldTranslation;
// 是不是需要返回,这里是需要猜想并判断用户是不是存在返回行为
@property (nonatomic, assign) BOOL isNeedDismiss;
@end

@implementation SwipeUpInteractiveTransition
- (instancetype)init:(UIViewController *)gestureVC
{
    self = [super init];
    if (self) {
        _gestureVC = gestureVC;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
        pan.delegate = self;
        [_gestureVC.view addGestureRecognizer:pan];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    // 获取手势触控的点在作用View的相对位置
    CGPoint translation = [gesture translationInView:gesture.view];
    // 每次手势触发的时候,重置,也就是用户不存在返回意图
    self.isNeedDismiss = NO;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 手势开始
            // 交互动画判断
            _isInteracting = YES;
            [_gestureVC dismissViewControllerAnimated:YES completion:nil];

            break;
        }
        case UIGestureRecognizerStateChanged: {
        // 当前触控点的赋值
            self.oldTranslation = translation;
            // 触控点的转化,因为updateInteractiveTransition的参数范围是[0.1],所以这里需要左边比例的转换
            CGFloat fraction = (translation.y / [[UIScreen mainScreen]bounds].size.height);
            // 保证范围
            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
            // 这里进行滑动中的判断,取的是黄金比例,也就是,如果滑动距离占比约38%,即可判断用户存在返回的行为
            _shouldComplete = fraction > 0.382;
            // 更新进度
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded: {
           // 这里是重要的判断
           // 如果用户存在快速向下滑动的行为(等同于全屏快速向右滑动返回的行为),self.isNeedDismiss为YES
           // 而这个判断的快速范围如下
            CGPoint speed = [gesture velocityInView:gesture.view];
           // 这个数据经过了大量测试和舒适度的数据,大家可以参考,具体的还需要根据实际情况而定.可以看我的量
            if (speed.y >= 920) {
                self.isNeedDismiss = YES;
                _shouldComplete = YES;
            }
            // 手势交互结束
            _isInteracting = NO;
            // 下面进行之前判断的处理
            // 使用dispatch_source_t定时回调,进行改变self.oldTranslation的数据,进行模拟手势移动,因为如果直接调用[self cancelInteractiveTransition];或者[self updateInteractiveTransition:fraction];就会发现,动画瞬间变化,瞬间复位或者瞬间消失返回.考虑到用户体验,如下
            dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //定时器模式  事件源
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
            //NSEC_PER_SEC是秒，＊1是每秒
            dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 0.0002, 0);
            //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
            dispatch_source_set_event_handler(timer, ^{
                //回调主线程，在主线程中操作UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_isNeedDismiss && (!_shouldComplete || gesture.state == UIGestureRecognizerStateCancelled)) {
                        if (self.oldTranslation.y <= 0) {
                        // 当满足条件,执行取消动画
                            [self cancelInteractiveTransition];
                            // 移除时间回调
                            dispatch_source_cancel(timer);
                        } else {
                        // 模拟上滑行为
                            CGFloat fraction = (self.oldTranslation.y / [[UIScreen mainScreen]bounds].size.height);
                            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
                            self.oldTranslation = CGPointMake(self.oldTranslation.x, self.oldTranslation.y - 0.3);

                            [self updateInteractiveTransition:fraction];
                        }
                    } else {
                        if (self.oldTranslation.y > [[UIScreen mainScreen]bounds].size.height) {
                        // 当滑出当前屏幕,执行完成动画
                            [self finishInteractiveTransition];
                                                        // 移除时间回调
                            dispatch_source_cancel(timer);
                        } else {
                        // 模拟下滑行为
                            CGFloat fraction = (self.oldTranslation.y / [[UIScreen mainScreen]bounds].size.height);
                            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
                            self.oldTranslation = CGPointMake(self.oldTranslation.x, self.oldTranslation.y + 0.3);

                            [self updateInteractiveTransition:fraction];
                        }
                    }
                });
            });
            //启动源
            dispatch_resume(timer);
            break;
        }
        default:
            break;
    }
}

- (void)applicationWillResignActive{
    UIPanGestureRecognizer *pan = [UIPanGestureRecognizer new];
    pan.state = UIGestureRecognizerStateEnded;
    [self panGestureHandler:pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewCellContentView"]||[touch.view isKindOfClass:[UITableView class]]) {
        //防止因为下拉手势导致tableview无法侧滑edit
        return NO;
    } else {
        return YES;
    }
    
}

@end
