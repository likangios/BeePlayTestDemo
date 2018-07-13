//
//  JKDSNetworkManager.h
//  jkds
//
//  Created by perfay on 2018/3/26.
//  Copyright © 2018年 perfaylk. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#define RequestSuc 0 //成功

@interface DTDSNetworkManager : AFHTTPSessionManager

+ (id)shareInstance;
+(NSString *)requestGetURL:(NSString *)url params:(NSDictionary *)params;
- (void)requestPOST:(NSString *)URLString
         parameters:(id)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
- (void)requestGET:(NSString *)URLString
        parameters:(id)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
- (void)requestUploadFile:(NSString *)URLString
                  FileUrl:(NSURL *)fileUrl
                 FileName:(NSString *)fileName
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
@end

