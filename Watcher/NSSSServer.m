//
//  NSSSServer.m
//  Watcher
//
//  Created by Win10 on 2019/2/25.
//  Copyright © 2019 Hp. All rights reserved.
//

#import "NSSSServer.h"
#import <GCDAsyncSocket.h>
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
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.started = NO;
        self.handlers = [[NSMutableArray alloc] init];
        NSLog(@"%p",self.handlers);
    }
    return self;
}

- (void)start{
    NSError *err = nil;
    if ([self.asyncSocket acceptOnPort:58889 error:&err])
    {
        UInt16 port = [self.asyncSocket localPort];
        NSLog(@"%d",port);
        
        self.started = YES;
    }
    else
    {
        NSLog(@"Error in acceptOnPort:error: -> %@", err);
    }
}
- (void)stop{
    [self.asyncSocket disconnect];
    self.started = NO;
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{

    NSLog(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    
    NSSSHandler * handler = [[NSSSHandler alloc]initWithSocket:newSocket handlersPool:self.handlers];
   
    [self.handlers addObject:handler];
    [handler start];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"dissocket");
}
@end
