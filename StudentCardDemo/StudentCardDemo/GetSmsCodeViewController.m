//
//  GetSmsCodeViewController.m
//  StudentCardDemo
//
//  Created by RuanSTao on 16/4/21.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "GetSmsCodeViewController.h"

@interface GetSmsCodeViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segMent;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation GetSmsCodeViewController

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
- (IBAction)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendSmsCode:(id)sender {
    //  (获取短信验证码)(填 0 或“账号注册”、1 或“密码重置”、2 或“关 注宝贝”)
    [self.view endEditing:YES];
    NSString *mobile = self.phoneNumber.text;
    NSString *type = [NSString stringWithFormat:@"%@",@(self.segMent.selectedSegmentIndex)];
    [[KinGuartApi sharedKinGuard] catchSmsCodeWithMobile:mobile withSmstype:type success:^(NSDictionary *data) {
        NSLog(@"catchSms:%@",data);
    } fail:^(NSString *error) {
        NSLog(@"catchSms:%@",error);
    }];
}
@end
