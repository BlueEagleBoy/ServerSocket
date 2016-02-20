//
//  main.m
//  10086服务器监听
//
//  Created by BlueEagleBoy on 16/2/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEServerSocket.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        BLEServerSocket *serverListen = [[BLEServerSocket alloc]init];
        [serverListen startServer];
        
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [runloop run];
    }
    
    return 0;
}
