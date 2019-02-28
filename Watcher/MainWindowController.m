//
//  MainWindowController.m
//  Watcher
//
//  Created by junlei on 2019/2/24.
//  Copyright © 2019 Hp. All rights reserved.
//

#import "MainWindowController.h"
#import "NSSSServer.h"

@interface MainWindowController ()<NSTableViewDelegate,NSTableViewDataSource>
@property(nonatomic,strong) NSMutableArray * datas;
@end

@implementation MainWindowController


- (void)adddata:(NSString *)source des:(NSString *)des
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"1%p",self.datas);
        
        NSDictionary * dic = @{
                               @"time":[@([NSDate date].timeIntervalSince1970) stringValue],
                               @"source":source,
                               @"destination":des,
                               @"protocol":@"TCP",
                               @"length":@"",
                               @"info":@"",
                               };
        [self.datas insertObject:dic atIndex:0];
        [self.tableView reloadData];
    });
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.datas = [NSMutableArray array];
    
    [self.tableView reloadData];
    
    
    self.serverBtn.target = self;
    self.serverBtn.action = @selector(btnDidClick);
    self.serverBtn.image = [NSImage imageNamed:@"power_button_off"];
}

- (void)btnDidClick
{
    NSSSServer * server = [NSSSServer sharedInstance];
    if ([server started]){
        [server stop];
        self.serverBtn.image = [NSImage imageNamed:@"power_button_off"];
    } else {
        [server start];
        self.serverBtn.image = [NSImage imageNamed:@"power_button_on"];
    }
}

- (NSNibName)windowNibName
{
    return @"MainWindowController";
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.datas.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString * key = tableColumn.identifier;
    if ([key isEqualToString:@"no"]) {
        return [@(self.datas.count - row) stringValue];
    }
    
    NSDictionary * data = self.datas[row];
    NSString * value = data[key];
    return value;
}
//- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    NSTableCellView * view = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
//    NSTextField * field = [view viewWithTag:100];
//    field.stringValue = @"100";
//    return view;
//}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
//    NSLog(@"%@",cell);
}




@end
