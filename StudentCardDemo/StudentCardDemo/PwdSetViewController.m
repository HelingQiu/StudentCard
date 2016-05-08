//
//  PwdSetViewController.m
//  StudentCardDemo
//
//  Created by Rainer on 16/4/20.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "PwdSetViewController.h"
#import <StudentCardApi/StudentCardApi.h>
#import "MBProgressHUD+MJ.h"

@interface PwdSetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@end

@implementation PwdSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)catchSms:(id)sender {
    //  (获取短信验证码)(填 0 或“账号注册”、1 或“密码重置”、2 或“关 注宝贝”)
    [self.view endEditing:YES];
    NSString *mobile = self.nameField.text;
    [[KinGuartApi sharedKinGuard] catchSmsCodeWithMobile:mobile withSmstype:@"1" success:^(NSDictionary *data) {
        NSLog(@"catchSms:%@",data);
    } fail:^(NSString *error) {
        NSLog(@"catchSms:%@",error);
    }];
}
- (IBAction)setPwd:(id)sender {
    [self.view endEditing:YES];
    NSString *mobile = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    NSString *code = self.codeField.text;
    //密码设置
    [[KinGuartApi sharedKinGuard] setNewPasswordMobile:mobile withPassword:pwd withSmscode:code success:^(NSDictionary *data) {
        NSLog(@"p:%@",data);
        [MBProgressHUD showSuccess:[data objectForKey:@"desc"]];
    } fail:^(NSString *error) {
        NSLog(@"p:%@",error);
        [MBProgressHUD showError:error];
    }];
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
- (IBAction)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
