//
//  SREpubInfo.h
//  SReader
//
//  Created by JunMing on 2020/5/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SREpubInfo : NSObject
+ (NSDictionary *)fetchEpubInfo:(NSString *)epubPath;
@end

NS_ASSUME_NONNULL_END
