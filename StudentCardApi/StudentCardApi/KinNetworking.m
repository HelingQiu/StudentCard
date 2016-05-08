//
//  KSModel.m
//  TaiPoFun
//
//  Created by Rainer on 4/1/16.
//  Copyright (c) 2016 KineticSpace Limited. All rights reserved.
//

#import "KinNetworking.h"
#import <AFNetworkActivityIndicatorManager.h>

@implementation KinNetworking
@synthesize httpMethod;

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"POST";
    }
    return self;
}

+ (id)sharedInstance
{
    static KinNetworking *sharedNetworking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworking = [[self alloc] init];
    });
    return sharedNetworking;
}

+ (void)startMonitoringNetwork
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *message = nil;
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
                
                message = [NSString stringWithFormat:@"当前网络不可用"];
                
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                message = [NSString stringWithFormat:@"当前网络已切换为WiFi"];
                
                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
                message = [NSString stringWithFormat:@"当前网络已切换为2G/3G/4G网络"];
                
                break;
                
            }
                
            default:
                
                break;
                
        }
    }];
}

+ (BOOL)isNetworkReachable
{
    return ((AFNetworkReachabilityManager *)[AFNetworkReachabilityManager sharedManager]).reachable;
}

#pragma mark -
#pragma mark request data from ks server with params
- (void)requestDataFromWSWithParams:(NSDictionary *)params forPath:(NSString *)path finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer.timeoutInterval = 60;
    sessionManager.responseSerializer= [AFHTTPResponseSerializer serializer];
    [sessionManager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        NSString *iso = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:dutf8 options:NSJSONReadingMutableContainers error:&error];
        if (resultDic == nil) {
            resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        }
        if (!error) {
            finished(resultDic);
        }else{
            failed(iso);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failed(error.localizedDescription);
        
    }];
}
- (void)getDataFromParams:(NSDictionary *)params
                   forUrl:(NSString *)url
//                   isJson:(BOOL)isJson
                 finished:(KSFinishedBlock)finished
                   failed:(KSFailedBlock)failed
{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer.timeoutInterval = 60;

//    if (!isJson) {

        sessionManager.responseSerializer= [AFHTTPResponseSerializer serializer];

//    } else {
//
//        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//    }
    [sessionManager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (isJson) {
//            if (((NSHTTPURLResponse *)task.response).statusCode == 200) {
//                if([responseObject isKindOfClass:[NSDictionary class]])
//                {
//                    NSDictionary *resultDic = (NSDictionary *)responseObject;
//                    if ([resultDic[@"success"] integerValue] == 1) {
//                        finished(resultDic);
//                    } else {
//                        failed(resultDic[@"errorMsg"]);
//                    }
//                } else {
//                    failed(@"失败");
//                }
//
//            } else {
//                failed(responseObject);
//            }
//        } else {
            NSError *error;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject                                                                                         options:kNilOptions error:&error];
            if (!error) {
                if (((NSHTTPURLResponse *)task.response).statusCode == 200) {
                    if ([resultDic[@"success"] integerValue] == 1) {
                        finished(resultDic);
                    } else {
                        failed(resultDic[@"errorMsg"]);
                    }
                } else {
                    failed(resultDic[@"errorMsg"]);
                }
            } else {
                failed(@"失败");
            }
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code == -1009) {

            failed(@"网络出错");

        } else {

            failed(@"失败");

        }

    }];
}

#pragma mark -
#pragma mark upload file to ks server
- (void)uploadPhotoFile:(NSData *)fileData path:(NSString *)path photoName:(NSString *)photoName fileName:(NSString *)fileName params:(NSDictionary *)params uploadProgress:(KSUploadProgress)uploadProgress finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed;
{
    NSString *mimeType = @"text/html";//[self contentTypeForImageData:fileData];

    [self uploadFileToPath:path andFileData:fileData fileName:fileName name:photoName mimeType:mimeType params:params uploadProgress:uploadProgress finished:finished failed:failed];

}

- (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (void)uploadAudioFileToPath:(NSString *)path
             andFileData:(NSData *)fileData
                fileName:(NSString *)fileName
                    name:(NSString *)name
//                mimeType:(NSString *)mimeType
                  params:(NSDictionary *)params
          uploadProgress:(KSUploadProgress)ksUploadProgress
                finished:(KSFinishedBlock)finished
                  failed:(KSFailedBlock)failed
{
    NSString *mimeType = @"audio/basic";

    [self uploadFileToPath:path andFileData:fileData fileName:fileName name:name mimeType:mimeType params:params uploadProgress:ksUploadProgress finished:finished failed:failed];
    
}

- (void)uploadFileToPath:(NSString *)path
             andFileData:(NSData *)fileData
                fileName:(NSString *)fileName
                    name:(NSString *)name
                mimeType:(NSString *)mimeType
                  params:(NSDictionary *)params
          uploadProgress:(KSUploadProgress)ksUploadProgress
                finished:(KSFinishedBlock)finished
                  failed:(KSFailedBlock)failed
{

    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:self.httpMethod URLString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } error:nil];

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithRequest:request fromData:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        if (ksUploadProgress) {
            ksUploadProgress(uploadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error == nil) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            result = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//
//            result = [result substringFromIndex:1];
//            result = [result substringToIndex:result.length - 1];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];

            NSError *error;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data                                                                                         options:kNilOptions error:&error];

            if (!error) {
                if (((NSHTTPURLResponse *)response).statusCode == 200) {

                    finished(resultDic);

                } else {
                    failed(nil);
                }
            } else {
                failed(nil);
            }
        }else{
            failed(@"网络出错");
        }
    }];
    [uploadTask resume];
}

#pragma mark -
#pragma mark download file from server

- (void)downloadFileFromPath:(NSString *)path withParams:(NSDictionary *)params andFileName:(NSString *)fileName progress:(KSUploadProgress)progress finished:(KSFinishedBlock)finished failed:(KSFailedBlock)failed
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:self.httpMethod URLString:path parameters:params error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        if (progress) {
            progress(downloadProgress);
        }
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        if (fileName && fileName.length > 0) {
            return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        }else{
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if (!error) {
//                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:response                                                                                         options:kNilOptions error:&error];
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                finished(@{@"filePath":filePath});
                } else {
                    failed([NSString stringWithFormat:@"%@",@(httpResponse.statusCode)]);
                }
        } else {
            failed(error.description);
        }
        
    }];
    [downloadTask resume];
    
}


@end
