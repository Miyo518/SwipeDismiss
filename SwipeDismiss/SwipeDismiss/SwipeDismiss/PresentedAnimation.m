//
//  PresentedAnimation.m
//  Miyo
//
//  Created by Miyo on 23/7/12.
//
//

#import "PresentedAnimation.h"

@implementation PresentedAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //拿到前后的两个controller
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到Presenting的最终Frame
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    //拿到转换的容器view
    UIView *containerView = [transitionContext containerView];
    CGRect bounds = [UIScreen mainScreen].bounds;
    toVC.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height);
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.alpha = 0.5;
        toVC.view.frame = finalFrameForVC;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        fromVC.view.alpha = 1.0;
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
}
@end
