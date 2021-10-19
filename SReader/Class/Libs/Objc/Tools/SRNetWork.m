//
//  SRNetWork.m
//  SReader
//
//  Created by JunMing on 2020/5/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import "SRNetWork.h"
#import "HYBIPHelper.h"
#import "SRunZipTool.h"

//#import <Zip/Zip.h>
//#import <SSZipArchive/SSZipArchive.h>
#define KSavePath @"/var/www/html/files/epub/images"
#define KHost @"http://119.23.42.43/files/"
#define kEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation SRNetWork
// 上传epub文件
+ (void)epub:(NSString *)url filePath:(NSString *)filePath fileName:(NSString *)fileName status:(uploadStatus)status {
    NSString *urlStr = @"http://192.168.0.104:10086";
    if ([url hasPrefix:@"http"] && [url hasSuffix:@"10086"] && (url.length == 26)) {
        urlStr = [url stringByAppendingPathComponent:@"upload.html"];
    }else {
        status(NO,nil,@"");
        return;
    }
    
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *tempFileName = filePath.lastPathComponent;
    if (!data && [self isDir:filePath]) {
        tempFileName = [tempFileName stringByReplacingOccurrencesOfString:@"epub" withString:@"zip"];
        NSString *newPath = [NSString stringWithFormat:@"%@/%@",kCachePath,tempFileName];
        if ([SRunZipTool createZipFileAtPath:newPath withContentsOfDirectory:filePath]) {
            data = [NSData dataWithContentsOfFile:newPath];
        }
        NSLog(@"是文件夹📁");
    }
    
    // [NSString stringWithFormat:@"http://%@:10086/upload.html",[HYBIPHelper deviceIPAdress]];
    // @"http://192.168.0.104:10086/upload.html";
    NSDictionary *params = @{@"path":@"",@"uname":@""};
    [self uploadFile:urlStr fileName:tempFileName mimeType:@"image/png" params:params data:data status:^(BOOL success, id  _Nullable responseObject, NSString * _Nullable url) {
        if (status) {
            status(success,responseObject,url);
        }
        NSLog(@"%@",success?@"成功😀😀😀":@"失败😭😭😭");
    }];
}

// 上传反馈照片
+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params status:(uploadStatus)status
{
    // 文件上传
    NSString *urlStr = @"http://www.restcy.com/source/api/masterboard_upload.php";
    [self uploadFile:urlStr fileName:@"fgedddd.png" mimeType:@"image/png" params:params  data:data status:^(BOOL success, id  _Nullable responseObject, NSString * _Nullable url) {
        if (status) {
            status(success,responseObject,url);
        }
        NSLog(@"%@",success?@"成功😀😀😀":@"失败😭😭😭");
    }];
}

#pragma mark -- GET上传反馈
+ (void)feedback:(NSString *)data sratus:(void(^)(id info))sta {
    NSString *url = @"http://www.restcy.com/source/api/feedback.php";
    NSString *urlStr = [NSString stringWithFormat:@"%@?target=0&feed_info=%@&user=00000000",url,data];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newString = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newString]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            id getData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            sta(getData);
        }else{
            NSLog(@"%@",error.description);
        }
    }];
    
    [task resume];
}

+ (NSMutableData *)httpBody:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimeType params:(NSDictionary *)params fileData:(NSData *)data  {
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:kEncode(@"--WebKitFormBoundaryUFNaH6losNxu4xDq\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:kEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:kEncode(type)];
    
    [body appendData:kEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:kEncode(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:kEncode(@"--WebKitFormBoundaryUFNaH6losNxu4xDq\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:kEncode(disposition)];
        
        [body appendData:kEncode(@"\r\n")];
        [body appendData:kEncode(obj)];
        [body appendData:kEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    // YY--\r\n
    [body appendData:kEncode(@"--WebKitFormBoundaryUFNaH6losNxu4xDq--\r\n")];
    
    return body;
}

#pragma mark -- 上传文件
+ (void)uploadFile:(NSString *)URLString fileName:(NSString *)fileName mimeType:(NSString *)mimeType params:(NSDictionary *)params data:(NSData *)data status:(uploadStatus)status {
    
    // URL
    NSURL *URL= [NSURL URLWithString:URLString];
    
    // 可变请求
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:URL];

    // 设置请求方法
    requestM.HTTPMethod = @"POST";
    
    // 设置请求
    requestM.HTTPBody = [self httpBody:@"file" fileName:fileName mimeType:mimeType params:params fileData:data];
    
    // 设置请求头信息
    [requestM setValue:@"multipart/form-data; boundary=WebKitFormBoundaryUFNaH6losNxu4xDq" forHTTPHeaderField:@"Content-Type"];
    [requestM setValue:[NSString stringWithFormat:@"%zd", requestM.HTTPBody.length] forHTTPHeaderField:@"Content-Length"];
    
    // 发送请求实现图片上传
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 处理响应
        if (error == nil && data != nil) {
            // 反序列化
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@",result);
            if (status) {
                NSString * url = [NSString stringWithFormat:@"%@%@/MasterBoard/%@", KHost,KSavePath.lastPathComponent,result[@"fileName"]];
                status(YES,response,url);
            }
        } else {
            if (status) {
                status(NO,response,error.description);
            }
            NSLog(@"%@",error);
        }
        
    }] resume];
}

// 根据路径删除文件
+ (BOOL)isDir:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 文件夹路径
    NSString *pathDir = fileName;
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:pathDir isDirectory:&isDir];
    // 文件夹不存在直接返回
    if (isDir){
        NSLog(@"%@---是文件夹",fileName);
    }else{ // 文件夹存在
        NSLog(@"%@***不是文件夹",fileName);
    }
    return isDir;
}
@end
