//
//  ViewController.m
//  SwipeDismiss
//
//  Created by Miyo on 2023/7/25.
//

#import "ViewController.h"
#import "SwipeDismissController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.center = self.view.center;
    [btn setTitle:@"Present" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(PresentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)PresentAction{
    SwipeDismissController *SwipeDismissVC = [SwipeDismissController new];
    SwipeDismissVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:SwipeDismissVC animated:YES completion:nil];
}

@end
