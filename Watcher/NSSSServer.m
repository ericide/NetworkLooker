//
//  NSSSServer.m
//  Watcher
//
//  Created by Win10 on 2019/2/25.
//  Copyright © 2019 Hp. All rights reserved.
//

#import "NSSSServer.h"
#import "NSSSHandler.h"


@interface NSSSServer()<GCDAsyncSocketDelegate>
@property (nonatomic,strong) GCDAsyncSocket * asyncSocket;
@property (nonatomic,strong) NSMutableArray * handlers;


@end
@implementation NSSSServer


static NSSSServer* instance = nil;

+(instancetype)sharedInstance{
    if (instance == nil) {
        instance = [[NSSSServer alloc] init];
    }
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)start{
}
- (void)stop{
}


@end
