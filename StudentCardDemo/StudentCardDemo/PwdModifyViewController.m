//
//  PwdModifyViewController.m
//  StudentCardDemo
//
//  Created by RuanSTao on 16/4/21.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "PwdModifyViewController.h"

@interface PwdModifyViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *oldPwd;
@property (strong, nonatomic) IBOutlet UITextField *nePwd;

@end

@implementation PwdModifyViewController

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
- (IBAction)modifyAction:(id)sender {
    //修改密码 已做页面
    [[KinGuartApi sharedKinGuard] revisePasswordMobile:self.phoneNumber.text?:@"" withOldPwd:self.oldPwd.text withNewPwd:self.nePwd.text success:^(NSDictionary *data) {
              NSLog(@"r:%@",data);
        
        [MBProgressHUD showSuccess:[data objectForKey:@"desp"]];
         } fail:^(NSString *error) {
              NSLog(@"r:%@",error);
         }];
}

@end
