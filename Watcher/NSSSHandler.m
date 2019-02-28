//
//  NSSSHandler.m
//  Watcher
//
//  Created by Win10 on 2019/2/25.
//  Copyright © 2019 Hp. All rights reserved.
//

#import "NSSSHandler.h"
#import "AppDelegate.h"


@interface NSSSHandler()<GCDAsyncSocketDelegate>






@property (nonatomic,weak) NSMutableArray * pool;
@property (nonatomic,strong) dispatch_queue_t connectionQueue;
@property (nonatomic,strong) dispatch_queue_t routerQueue;
@property (nonatomic,assign) BOOL started;

@property (nonatomic,strong) GCDAsyncSocket * asyncSocket2;


@property (nonatomic,assign) NSInteger step;
@end

@implementation NSSSHandler
- (instancetype)initWithSocket:asyncSocket handlersPool:(NSMutableArray *)pool;
{
    self = [self init];
    if (self) {
        self.pool = pool;
        self.asyncSocket = asyncSocket;
        
        self.connectionQueue = dispatch_queue_create("HTTPConnection", NULL);
        self.routerQueue = dispatch_queue_create("routerQueue", NULL);
        self.step = 0;
        self.asyncSocket2 = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.routerQueue];
        
        
        self.source = [NSString stringWithFormat:@"%@:%hu",self.asyncSocket.connectedHost,self.asyncSocket.connectedPort];
        
        [_asyncSocket setDelegate:self delegateQueue:self.connectionQueue];
    }
    return self;
}



- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if ([sock isEqual:self.asyncSocket2]) {
        
        NSLog(@"remote -------> %@",data);
        
        [self.asyncSocket writeData:data withTimeout:0 tag:0];
        dispatch_async(self.routerQueue, ^{ @autoreleasepool {
            [self.asyncSocket2 readDataWithTimeout:-1 tag:self.step];
        }});
    } else {
        NSLog(@"%ld -------> %@",tag,data);
        if (self.step == 0) {
            unsigned char rdatabytes[] = {0x05,0x00};
            NSData * rdata = [NSData dataWithBytes:rdatabytes length:2];
            
            self.step = 1;
            [self.asyncSocket writeData:rdata withTimeout:0 tag:self.step];
        } else if (self.step == 1) {
            unsigned char b[1024];
            [data getBytes:b range:NSMakeRange(1, 1)];
            if (b[0] == 1) {
                [data getBytes:b range:NSMakeRange(3, 1)];
                
                NSString * host = @"";
                unsigned short port  = 0;
                if (b[0] == 1) {
                    [data getBytes:b range:NSMakeRange(4, 6)];
                    port = b[4]*256 + b[5];
                    host = [NSString stringWithFormat:@"%d.%d.%d.%d",b[0],b[1],b[2],b[3]];
                    NSLog(@"%d.%d.%d.%d:%hu",b[0],b[1],b[2],b[3],port);
                }
                if (b[0] == 3) {
                    [data getBytes:b range:NSMakeRange(4, 1)];
                    int length = b[0];
                    [data getBytes:b range:NSMakeRange(5, length)];
                    host = [[NSString alloc]initWithData:[NSData dataWithBytes:b length:length] encoding:NSASCIIStringEncoding];
                    
                    [data getBytes:b range:NSMakeRange(5 + length,2)];
                    port = b[0]*256 + b[1];
                    NSLog(@"%@:%hu",host,port);
                }
                
                self.destination = [NSString stringWithFormat:@"%@:%hu",host,port];
                
                
                AppDelegate * apd = [NSApplication sharedApplication].delegate;
                [apd.windowController adddata:self.source des:self.destination];
                
                
                
                NSError * error = nil;
                if ([self.asyncSocket2 connectToHost:host onPort:port error:&error]) {
                    self.step = 2;
                    unsigned char rdatabytes[] = {0x00};
                    NSData * rdata = [NSData dataWithBytes:rdatabytes length:1];
                    [self.asyncSocket writeData:rdata withTimeout:-1 tag:self.step];
                    dispatch_async(self.routerQueue, ^{ @autoreleasepool {
                        [self.asyncSocket2 readDataWithTimeout:-1 tag:self.step];
                    }});
                    NSLog(@"connect remote success!");
                } else {
                    NSLog(@"Error in acceptOnPort:error: -> %@", error);
                }
            }
        } else if (self.step == 2){
            
            [self.asyncSocket2 writeData:data withTimeout:-1 tag:0];
        }
        
        dispatch_async(self.connectionQueue, ^{ @autoreleasepool {
            [self.asyncSocket readDataWithTimeout:-1 tag:self.step];
        }});
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    [sock readDataWithTimeout:0 tag:1];
    
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if ([sock isEqual:self.asyncSocket2]) {
        if ([self.asyncSocket isConnected]) {
            [self.asyncSocket disconnect];
        }
    } else {
        if ([self.asyncSocket2 isConnected]) {
            [self.asyncSocket2 disconnect];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.pool containsObject:self]) {
            [self.pool removeObject:self];
        }
    });
    
}
- (void)start
{
    dispatch_async(self.connectionQueue, ^{ @autoreleasepool {
        
        if (!self.started)
        {
            self.started = YES;
            [self startConnection];
        }
    }});
}
- (void)startConnection
{
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
