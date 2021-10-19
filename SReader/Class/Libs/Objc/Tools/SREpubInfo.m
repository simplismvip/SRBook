//
//  SREpubInfo.m
//  SReader
//
//  Created by JunMing on 2020/5/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import "SREpubInfo.h"
#import "SRunZipTool.h"
//#import <Zip/Zip.h>
//#import <SSZipArchive/SSZipArchive.h>

@implementation SREpubInfo
+ (NSDictionary *)fetchEpubInfo:(NSString *)epubPath {
    NSString *desPath = [self unzipEpub:epubPath];
    return [self getBookInfo:desPath];
}

// 解压epub
+ (NSString *)unzipEpub:(NSString *)epubPath {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *epubFolder = [epubPath.lastPathComponent stringByReplacingOccurrencesOfString:@".epub" withString:@""];
    NSString *desPath = [cache stringByAppendingPathComponent:epubFolder];
    if ([SRunZipTool unzipFileAtPath:epubPath toDestination:desPath]) {
        NSLog(@"解压成功");
    }
    return desPath;
}

// 获取图书信息返回字段
+ (NSDictionary *)getBookInfo:(NSString *)path {
    // 先判断是否存在文件 iTunesMetadata.plist
    NSString *plist = [self findFields:path extension:@"plist"];
    // 不存在遍历查找 .opf 文件, 读取文件内容
    NSDictionary *dic;
    if (!plist) {
        NSString *opf = [self findFields:path extension:@"opf"];
        dic = [self getOpfContent:opf];
    }else{
        dic = [self getPlistContent:plist];
    }
    return dic;
}

+ (NSDictionary *)getPlistContent:(NSString *)path {
    //newsTest.plist文件
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // 遍历查找 cover.jpg
    NSString *str = [NSString stringWithFormat:@"/%@", path.lastPathComponent];
    NSString *cover = [self findFields:[path stringByReplacingOccurrencesOfString:str withString:@""] extension:@"jpg"];
    
    NSArray *desc = dic[@"playlistName"];
    NSString *title = dic[@"itemName"];
    NSString *creator = dic[@"artistName"];
    // NSString *genre = dic[@"genre"];
    
    if (cover) {
        NSString *docu = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *coverPath = [NSString stringWithFormat:@"%@/Covers/local_%@_%@",docu,title,cover.lastPathComponent];
        NSData *dataIma = [NSData dataWithContentsOfFile:cover];
        [dataIma writeToFile:coverPath atomically:YES];
        return @{@"bookName":title?:@"", @"author":creator?:@"", @"description":desc?:@"", @"cover":coverPath.lastPathComponent};
    }
    
    return @{@"bookName":title?:@"", @"author":creator?:@"", @"description":desc?:@""};
}

// 读取opf 文件内容
+ (NSDictionary *)getOpfContent:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *contrnt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *titles = [contrnt componentsSeparatedByString:@"dc:title"];
    NSArray *creators = [contrnt componentsSeparatedByString:@"dc:creator"];
    NSArray *descriptions = [contrnt componentsSeparatedByString:@"dc:description"];
    // opf:file-as="［日］ 斋藤康毅" opf:role="aut">［日］ 斋藤康毅</
    // opf:file-as="［日］ 斋藤康毅" opf:role="aut">［日］ 斋藤康毅
    NSString *title = titles.count > 2 ? [titles[1] substringWithRange:NSMakeRange(1, [titles[1] length]-3)]:@"";
    NSString *creator = creators.count>2 ? [creators[1] substringWithRange:NSMakeRange(1, [creators[1] length]-3)]:@"";
    NSString *desc = descriptions.count>2 ? [descriptions[1] substringWithRange:NSMakeRange(1, [descriptions[1] length]-3)]:@"";
    creator = [creator componentsSeparatedByString:@">"].lastObject;
    creator = [creator stringByReplacingOccurrencesOfString:@"著" withString:@""];
    // 遍历查找 cover.jpg
    NSString *str = [NSString stringWithFormat:@"/%@", path.lastPathComponent];
    NSString *cover = [self findFields:[path stringByReplacingOccurrencesOfString:str withString:@""] extension:@"jpg"];
    if (cover) {
        NSString *docu = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *coverPath = [NSString stringWithFormat:@"%@/Covers/local_%@_%@",docu,title,cover.lastPathComponent];
        NSData *dataIma = [NSData dataWithContentsOfFile:cover];
        [dataIma writeToFile:coverPath atomically:YES];
        return @{@"bookName":title?:@"", @"author":creator?:@"", @"description":desc?:@"", @"cover":coverPath.lastPathComponent};
    }
    return @{@"bookName":title?:@"", @"author":creator?:@"", @"description":desc?:@""};
}

// 遍历查找某文件, 找到返回文件路径
+ (NSString *)findFields:(NSString *)path extension:(NSString *)ext {
    BOOL dir = NO;
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL exist = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exist) {return nil;}
    
    if (dir) {
        NSString *final;
        NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
        for (NSString *fileName in array) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, fileName];
            final = [self findFields:filePath extension:ext];
            if (final) {return final;}
        }
        return final;
    }else{
        
        if ([ext isEqualToString:@"jpg"]) {
            NSString *extension = [[path pathExtension] lowercaseString];
            if ([extension isEqualToString:ext] || [extension isEqualToString:@"jpeg"]) {
                NSString *coverName = path.lastPathComponent.lowercaseString;
                if ([coverName isEqualToString:@"cover.jpg"] || [coverName isEqualToString:@"cover.jpeg"] || ([coverName hasPrefix:@"cover"] && [coverName hasSuffix:@"jpeg"])) {
                    return path;
                }else{
                    return nil;
                }
            }
            return nil;
        }else{
            NSString *extension = [[path pathExtension] lowercaseString];
            if ([extension isEqualToString:ext]) {return path;}
            return nil;
        }
    }
}
@end
