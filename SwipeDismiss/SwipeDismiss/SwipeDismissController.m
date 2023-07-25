//
//  SwipeDismissController.m
//  SwipeDismiss
//
//  Created by Miyo on 2023/7/25.
//

#import "SwipeDismissController.h"

#import "DismissAnimation.h"
#import "PresentedAnimation.h"
#import "SwipeUpInteractiveTransition.h"

@interface SwipeDismissController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) SwipeUpInteractiveTransition *interactiveTransition;
@end

@implementation SwipeDismissController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.interactiveTransition = [[SwipeUpInteractiveTransition alloc]init:self];
    self.transitioningDelegate = self;
}

#pragma mark === UIViewControllerTransitioningDelegate ======
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [[PresentedAnimation alloc]init];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissAnimation alloc]init];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return (self.interactiveTransition.isInteracting ? self.interactiveTransition : nil);
}

@end
