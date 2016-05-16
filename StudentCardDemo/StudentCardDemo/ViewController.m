//
//  ViewController.m
//  StudentCardDemo
//
//  Created by RuanSTao on 16/4/1.
//  Copyright © 2016年 JJS-iMac. All rights reserved.
//

#import "ViewController.h"
#import <StudentCardApi/StudentCardApi.h>
#import "MBProgressHUD+MJ.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *yzmField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"NSHomeDirectory---%@",NSHomeDirectory());
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    NSLog(@"document---%@",documentsDirectoryURL);
    //注册服务器识别key
    [KinGuartApi sharedKinGuard].appKey = @"a6b0c023c373971a6523b1960ede0031";
    [KinGuartApi sharedKinGuard].appSecret = @"0be4f5e95593a4d65d6734942b4617e740090527becaf0d3f46d50be179d6933";
    
    //调用方法（请先调用登录获取token值，不要同时调用多个请求）
    
//    [self accountOperation];
    [self kinGuardDevice];
//    [self kinGuardLocation];
//    [self kinGuardRecord];
    
}

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    //登录
    NSString *mobile = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    [[KinGuartApi sharedKinGuard] loginWithMobile:mobile withPassword:pwd success:^(NSDictionary *data) {
        NSLog(@"l:%@",data);
        [MBProgressHUD showSuccess:[data objectForKey:@"desp"]];
    } fail:^(NSString *error) {
        NSLog(@"l:%@",error);
        [MBProgressHUD showError:error];
    }];
}
- (IBAction)regist:(id)sender {
    [self.view endEditing:YES];
    //注册
    NSString *mobile = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    [[KinGuartApi sharedKinGuard] registerAppAccountMobile:mobile withPassword:pwd withSmscode:@"" success:^(NSDictionary *data) {
        NSLog(@"%@",data);
        [MBProgressHUD showSuccess:[data objectForKey:@"desp"]];
    } fail:^(NSString *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:error];
    }];
}
- (IBAction)code:(id)sender {
    //账户注册短信认证
    [self.view endEditing:YES];
    NSString *mobile = self.nameField.text;
    NSString *code = self.yzmField.text;
    [[KinGuartApi sharedKinGuard] regSmsCheckWithMobile:mobile withSmsCode:code success:^(NSDictionary *data) {
        NSLog(@"regsmscheck:%@",data);
        [MBProgressHUD showSuccess:[data objectForKey:@"desc"]];
    } fail:^(NSString *error) {
        NSLog(@"regsmscheck:%@",error);
        [MBProgressHUD showError:error];
    }];
}

- (IBAction)logout:(id)sender {
    //退出登录
    //     [[KinGuartApi sharedKinGuard] loginOutWithMobile:@"18606092764" success:^(NSDictionary *data) {
    //          NSLog(@"o:%@",data);
    //     } fail:^(NSString *error) {
    //          NSLog(@"o:%@",error);
    //     }];
}


/**
 *  账户操作
 */
- (void)accountOperation
{

     
     //密码报失    已做页面
//     [[KinGuartApi sharedKinGuard] reportLostPasswordMobile:@"18606092764" success:^(NSDictionary *data) {
//         NSLog(@"l:%@",data);
//     } fail:^(NSString *error) {
//         NSLog(@"l:%@",error);
//     }];

     
     //修改密码 已做页面
//     [[KinGuartApi sharedKinGuard] revisePasswordMobile:@"18606092764" withOldPwd:@"1234" withNewPwd:@"1234" success:^(NSDictionary *data) {
//          NSLog(@"r:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"r:%@",error);
//     }];

    
    


    //更新用户信息
//    [[KinGuartApi sharedKinGuard] updateUserInfoWithMobile:@"18002566031" withAddr:@"123" withIddno:@"123" withAccName:@"123" withAlias:@"123" withSex:@"F" withBirthdate:@"2001-01-01" success:^(NSDictionary *data)
//    {
//        NSLog(@"updateUser:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"updateUser:%@",error);
//    }];
    
    //获取用户信息
//    [[KinGuartApi sharedKinGuard] getUserInfoSuccess:^(NSDictionary *data) {
//        NSLog(@"getUserInfo:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"getUserInfo:%@",error);
//    }];
    
    //上传头像
//    NSData *head = UIImageJPEGRepresentation([UIImage imageNamed:@"HeadPortrait.JPG"], 1);
//    [[KinGuartApi sharedKinGuard] uploadHeadPortraitByPid:@"c202237b" withImageData:head uploadProgress:^(NSProgress *progress) {
//        NSLog(@"progress: %@",progress);
//    } finished:^(NSDictionary *data) {
//        NSLog(@"getUserInfo:%@",data);
//    } failed:^(NSString *error) {
//        NSLog(@"getUserInfo:%@",error);
//    }];
    
    //下载头像(未上传没有头像)
//    [[KinGuartApi sharedKinGuard] downloadHeadPortraitByPid:@"c202237b" andProgress:^(NSProgress *progress) {
//        NSLog(@"progress: %@",progress);
//    } finished:^(NSDictionary *data) {
//        NSLog(@"getUserInfo:%@",data);
//    } failed:^(NSString *error) {
//        NSLog(@"getUserInfo:%@",error);
//    }];
    

}

/**
 *  设备
 */
- (void)kinGuardDevice
{

     //通过二维码绑定
//     [[KinDeviceApi sharedKinDevice] bindDeviceByQRCode:@"042bd75cb0bf4cdcad4d77038baec47e3ec5" success:^(NSDictionary *data) {
//          NSLog(@"qrcode:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"qrcode:%@",error);
//     }];
 
     
     //通过设备 ID 绑定
//     [[KinDeviceApi sharedKinDevice] bindDeviceByPid:@"c202237b" withKey:@"6ce68d05" success:^(NSDictionary *data) {
//          NSLog(@"pid:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"pid:%@",error);
//     }];
    
     //关注号绑定(二维码)
//     [[KinDeviceApi sharedKinDevice] bindFollowByQRCode:@"042bd75cb0bf4cdcad4d77038baec47e3ec5" withSmscode:nil success:^(NSDictionary *data) {
//          NSLog(@"fllow qrcode:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"fllow qrcode:%@",error);
//     }];
    
     //关注号绑定(设备 ID 号)
//     [[KinDeviceApi sharedKinDevice] bindFollowByPid:@"c202237b" withKey:@"6ce68d05" withSmscode:nil success:^(NSDictionary *data) {
//          NSLog(@"fllow pid:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"fllow pid:%@",error);
//     }];
    
     //设备解绑(通过pid)
//     [[KinDeviceApi sharedKinDevice] unBindDeviceByPid:@"c202237b" withKey:@"6ce68d05" withMainacc:@"18606092764" success:^(NSDictionary *data) {
//          NSLog(@"unbind pid:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"unbind pid:%@",error);
//     }];
    
    //设备解绑（通过二维码）
//    [[KinDeviceApi sharedKinDevice] unBindDeviceByQrcode:@"042bd75cb0bf4cdcad4d77038baec47e3ec5" withMainacc:@"18606092764" success:^(NSDictionary *data) {
//        NSLog(@"unbind qrcode:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"unbind qrcode:%@",error);
//    }];
    
     //关系设定
//     [[KinDeviceApi sharedKinDevice] setRelationshipWithPid:@"c202237b" withRelationship:@"123" success:^(NSDictionary *data) {
//          NSLog(@"relationship:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"relationship:%@",error);
//     }];
    
    //宝贝列表
//    [[KinDeviceApi sharedKinDevice] deviceListSuccess:^(NSDictionary *data) {
//        
//        NSLog(@"device info:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"device info:%@",error);
//        
//    }];

    //宝贝信息
//    [[KinDeviceApi sharedKinDevice] deviceInfoPid:@"c202237b" success:^(NSDictionary *data) {
//        NSLog(@"device info:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"device info:%@",error);
//    }];
    
    //修改宝贝信息
//    [[KinDeviceApi sharedKinDevice] updateDeviceInfoPid:@"c202237b" withAssetname:@"helloworld" withSex:@"F" success:^(NSDictionary *data) {
//        NSLog(@"updateDeviceInfo:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"updateDeviceInfo:%@",error);
//    }];
    
    //监护人信息
    [[KinDeviceApi sharedKinDevice] deviceBindInfoPid:@"c202237b" success:^(NSDictionary *data) {
        NSLog(@"deviceBindInfo:%@",data);
    } fail:^(NSString *error) {
        NSLog(@"deviceBindInfo:%@",error);
    }];
    
    //开始记步
//    [[KinDeviceApi sharedKinDevice] startStepsPid:@"c202237b" success:^(NSDictionary *data) {
//        NSLog(@"startSteps:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"startSteps:%@",error);
//    }];
    
    
    
     //绑定百度推送
//     [[KinDeviceApi sharedKinDevice] bindBaiduPushWithUserid:@"123" withChannelid:@"123" withAppid:@"123" success:^(NSDictionary *data) {
//         NSLog(@"baidu:%@",data);
//     } fail:^(NSString *error) {
//         NSLog(@"baidu:%@",error);
//     }];
    
     //绑定极光推送
//     [[KinDeviceApi sharedKinDevice] bindJpushWithRegisterid:@"123" success:^(NSDictionary *data) {
//         NSLog(@"jpush:%@",data);
//     } fail:^(NSString *error) {
//         NSLog(@"jpush:%@",error);
//     }];
}

/**
 *  定位
 */
- (void)kinGuardLocation
{

     //普通定位申请
//     [[KinLocationApi sharedKinLocation] startNormalLocation:@"c202237b" success:^(NSDictionary *data) {
//          NSLog(@"normal loca:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"normal loca:%@",error);
//     }];
    
     //紧急定位申请
//     [[KinLocationApi sharedKinLocation] startUrgenLocation:@"c202237b" success:^(NSDictionary *data) {
//          NSLog(@"urgen:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"urgen:%@",error);
//     }];

     //监听申请
//     [[KinLocationApi sharedKinLocation] startRecordLocation:@"c202237b" success:^(NSDictionary *data) {
//          NSLog(@"record:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"record:%@",error);
//     }];
    
     //获取定位信息
//     [[KinLocationApi sharedKinLocation] readLocationInfo:@"c202237b" success:^(NSDictionary *data) {
//          NSLog(@"readInfo:%@",data);
//     } fail:^(NSString *error) {
//          NSLog(@"readInfo:%@",error);
//     }];
 
    //获取历史定位信息
//    [[KinLocationApi sharedKinLocation] readPosHisInfo:@"c202237b" withBegdt:@"2016-04-18T08:00:00" withEnddt:@"2016-04-18T16:00:00" success:^(NSDictionary *data) {
//        NSLog(@"posHisInfo:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"posHisInfo:%@",error);
//    }];

    //根据token获取定位信息
//    [[KinLocationApi sharedKinLocation] getLocationByPid:@"c202237b" withLocationToken:@"456164" success:^(NSDictionary *data) {
//        NSLog(@"get by token:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"get by token:%@",error);
//    }];
    
    //设定安全区域
//    [[KinLocationApi sharedKinLocation] setSecZone:@"12" withAction:@"12" withAddr:@"12" withLng:@"122.6786524" withLat:@"36.162736" withIntime:@"2016-04-18T08:00:00" withOuttime:@"2016-04-18T16:00:00" withDays:@"4" withRadius:@"1000" withTokenno:@"12" success:^(NSDictionary *data) {
//        NSLog(@"location:%@",data);
//    } fail:^(NSString *error) {
//        NSLog(@"location:%@",error);
//    }];
    
}

/**
 *  录音
 */
- (void)kinGuardRecord
{
  //监听申请
//    [[KinRecordApi sharedKinRecordApi] applicationMonitorWithDeviceId:@"c202237b" andFinished:^(NSDictionary *data) {
//        NSLog(@"startrecord:%@",data);
//    } failed:^(NSString *error) {
//        NSLog(@"startrecord:%@",error);
//    }];

    //录音信息
//    [[KinRecordApi sharedKinRecordApi] recordInfomationWithDeviceId:@"c202237b" andFinished:^(NSDictionary *data) {
//        NSLog(@"recordInfo:%@",data);
//    } failed:^(NSString *error) {
//        NSLog(@"recordInfo:%@",error);
//    }];
    
    //录音下载
//    [[KinRecordApi sharedKinRecordApi] downloadRecordWithDeviceId:@"c202237b" token:@"432483" andFileName:@"432483.avi" andProgress:^(NSProgress *progress) {
//        NSLog(@"progress:%@",progress);
//    } finished:^(NSDictionary *data) {
//        NSLog(@"down:%@",data);
//    } failed:^(NSString *error) {
//        NSLog(@"down:%@",error);
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.view endEditing:YES];
}

@end
