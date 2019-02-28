//
//  NSSSServer.h
//  Watcher
//
//  Created by Win10 on 2019/2/25.
//  Copyright © 2019 Hp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSSServer : NSObject
+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@property (nonatomic,assign) BOOL started;
@end

NS_ASSUME_NONNULL_END
