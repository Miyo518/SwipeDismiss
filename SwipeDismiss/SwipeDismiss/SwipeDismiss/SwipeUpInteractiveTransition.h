//
//  SwipeUpInteractiveTransition.h
//  Miyo
//
//  Created by Miyo on 23/7/12.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) BOOL shouldComplete;

- (instancetype)init:(UIViewController *)vc;
@end
