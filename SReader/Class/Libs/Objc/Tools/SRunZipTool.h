//
//  SRunZipTool.h
//  SReader
//
//  Created by JunMing on 2021/4/25.
//  Copyright © 2021 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRunZipTool : NSObject
+(BOOL)unzipFileAtPath:(NSString *)epubPath toDestination:(NSString *)toDestination;
+(BOOL)createZipFileAtPath:(NSString *)newPath withContentsOfDirectory:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
