//
//  BLEServerSocket.m
//  10086服务器监听
//
//  Created by BlueEagleBoy on 16/2/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEServerSocket.h"
#import "GCDAsyncSocket.h"

@interface BLEServerSocket ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong)GCDAsyncSocket *serverSocket;
@property (nonatomic, strong)NSMutableArray *clienSocket;

@end

@implementation BLEServerSocket

- (NSMutableArray *)clienSocket{
    
    if (!_clienSocket) {
        
        _clienSocket = [NSMutableArray array];
        
    }
    
    return _clienSocket;
    
}

- (void)startServer {
    
    //创建一个服务监听对象 负责监听有没有客户端连接
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    //绑定接口并监听
    NSError *error = nil;
    [serverSocket acceptOnPort:5288 error:&error];
    
    if (!error) {
        NSLog(@"开启10086服务成功");
    }else {
        NSLog(@"开启10086服务失败");
    }
    
    
    self.serverSocket = serverSocket;
}

#pragma  mark 有客户端的对象连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    NSLog(@"serverSocket:%@  clientSocket:%@",sock,newSocket);
    
    //因为newSocket要一致链接 所以不能被释放 所以就放在一个数组中强yinyong
    [self.clienSocket  addObject:newSocket];
    
    
    NSMutableString *serverStr = [NSMutableString string];
    [serverStr appendString:@"[0]在线充值\n"];
    [serverStr appendString:@"[1]在线优惠\n"];
    [serverStr appendString:@"[2]在线打折\n"];
    [serverStr appendString:@"[3]在线充值\n"];

    
    [newSocket writeData:[serverStr dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
    
    [newSocket readDataWithTimeout:-1 tag:0];
    
}

- (void)socket:(GCDAsyncSocket *)clientSock didReadData:(NSData *)data withTag:(long)tag {
    
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSInteger index = [dataStr integerValue];
    NSString *response = nil;
    
    switch (index) {
        case 0:
            response = @"没有充值服务\n";
            break;
        case 1:
            response = @"没有优惠服务\n";
            break;
        case 2:
            response = @"没有打折服务\n";
            break;
        case 3:
            response = @"推出成功\n";
            break;
            
        default:
            break;
    }
    
    [clientSock writeData:[response dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    if (index == 3) {
        
        [self.clienSocket removeObject:clientSock];
        
    }
    
    //接收到数据之后监听就会断开 所以需要重新监听
    [clientSock readDataWithTimeout:-1 tag:0];
}









@end
