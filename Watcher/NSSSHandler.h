//
//  NSSSHandler.h
//  Watcher
//
//  Created by Win10 on 2019/2/25.
//  Copyright © 2019 Hp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSSHandler : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic,strong) NSString * source;
@property (nonatomic,strong) NSString * destination;




@property (nonatomic,strong) GCDAsyncSocket * asyncSocket;
- (instancetype)initWithSocket:newSocket handlersPool:(NSMutableArray *)pool;
- (void)start;
@end

NS_ASSUME_NONNULL_END
