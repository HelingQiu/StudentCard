//
//  PwdLostViewController.m
//  StudentCardDemo
//
//  Created by RuanSTao on 16/4/20.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "PwdLostViewController.h"
#import <StudentCardApi/StudentCardApi.h>
#import "MBProgressHUD+MJ.h"

@interface PwdLostViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation PwdLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)pwdLostAction:(id)sender {
    //密码报失
    [[KinGuartApi sharedKinGuard] reportLostPasswordMobile:self.textField.text?:@"" success:^(NSDictionary *data) {
             NSLog(@"l:%@",data);
        [MBProgressHUD showSuccess:[data objectForKey:@"desp"]];
         } fail:^(NSString *error) {
             NSLog(@"l:%@",error);
         }];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
