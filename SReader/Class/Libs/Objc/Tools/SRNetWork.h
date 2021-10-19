//
//  SRNetWork.h
//  SReader
//
//  Created by JunMing on 2020/5/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^uploadStatus)(BOOL success, id  _Nullable responseObject, NSString * _Nullable url);
@interface SRNetWork : NSObject
/* 基础上传方法 */
+ (void)uploadFile:(NSString *)URLString fileName:(NSString *)fileName mimeType:(NSString *)mimeType params:(NSDictionary *)params data:(NSData *)data status:(uploadStatus)status;

/* 上传epub文件 */
+ (void)epub:(NSString *)url filePath:(NSString *)filePath fileName:(NSString *)fileName status:(uploadStatus)status;

/* 上传反馈照片 */
+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params status:(uploadStatus)status;

+ (void)feedback:(NSString *)data sratus:(void(^)(id info))sta;
@end

NS_ASSUME_NONNULL_END
