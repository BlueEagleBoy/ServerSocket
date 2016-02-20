# ServerSocket

###准备：
* 下载socket的第三方框架：cocoaAsyncSocket  
  下载地址：
https://github.com/robbiehanson/CocoaAsyncSocket

###项目步骤：

* 创建一个终端项目，模拟10086服务器监听
* 导入cocoaAsyncSocket中的GCDAsyncSocket类
* 编译是否报错

###开发过程

* 创建一个继承自NSObject的BLEServerListen类，
* 在main.m创建一个BLEServerListen对象,并调用监听方法

```
  BLEServerListen *serverListen = [[BLEServerListen alloc]init];
        [serverListen startListen];
        
  //防止程序死掉 保证程序一致在运行
  
 [[NSRunLoop mainRunLoop]run];

```

* 在BLEServerListen类中，定义startListen对象方法，监听客户端连接，.m文件中的具体代码实现 

```
- (void)startListen {
    
    //创建监听服务器 专门用来负责监听有没有客户端服务器连接
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    //绑定客户端 并开启10086服务服务 5288是端口号 端口号要大于1024
    NSError *error = nil;
    [serverSocket acceptOnPort:5288 error:&error];
    
    if (!error) {
        NSLog(@"连接10086成功");
    }else {
        NSLog(@"连接10086失败");
    }
    //延长生命周期 不然serverSocket会被释放
    self.serverSocket = serverSocket;
    
}
```


* 利用终端去连接服务器
   
   1.打开终端输入 telnet 本机IP 10086端口号  例如：telnet 192.168.1.22 5288
   
  ```
  连接后出现：
  Trying 192.168.1.22...
Connected to localhost.
Escape character is '^]'.
  
  ```
  
  2.此时可以进行数据的发送了。
  

*  客户端连接后调用的代理方法

```

// 当有客户端连接的时候调用
- (void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket {
    
    NSLog(@"serverSocket:%@  clientSocket:%@",serverSocket,clientSocket);
    
    //解决clientsocket是局部变量导致连接关闭的状况
    [self.clientSocket addObject:clientSocket];
    
    //-1表示永不超时
    [clientSocket readDataWithTimeout:-1 tag:0];
    
}
```

* 接收到客户端发送数据调用的方法


```

//读取客户端的数据
- (void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag {
    
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",dataStr);
    
    [clientSocket readDataWithTimeout:-1 tag:0];
}


```

这是一个简单的服务器端的监听连接，socket的用途之强大。有兴趣的同学一起学习。
详细代码下载：



