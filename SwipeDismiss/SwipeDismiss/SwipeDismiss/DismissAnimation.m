//
//  DismissAnimation.m
//  Miyo
//
//  Created by Miyo on 23/7/12.
//
//

#import "DismissAnimation.h"

@interface DismissAnimation()
@property (nonatomic, strong) UIVisualEffectView *mEffectView;
@property (nonatomic, strong) UIViewController *fromVC;
@end

@implementation DismissAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //拿到前后的两个controller
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.mEffectView.alpha = 0.2;
    [toVC.view addSubview:self.mEffectView];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect initFrame = [transitionContext initialFrameForViewController:self.fromVC];
    //拿到Presenting的最终Frame
    CGRect finalFrame = CGRectOffset(initFrame, 0, screenBounds.size.height);
    //拿到转换的容器view
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        self.fromVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        BOOL complate = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:(!complate)];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
    [UIView animateWithDuration:0.1 animations:^{
        self.mEffectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.mEffectView removeFromSuperview];
    }];
}

#pragma mark - Getter
-(UIVisualEffectView *)mEffectView{
    if (!_mEffectView) {
        _mEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _mEffectView.alpha = 0.2;
        _mEffectView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    }
    return _mEffectView;
}

@end
