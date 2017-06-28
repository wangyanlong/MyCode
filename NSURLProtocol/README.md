# NSURLProtocol

###NSURLProtocol能拦截哪些网络请求

NSURLProtocol能拦截所有基于URL Loading System的网络请求。
这里先贴一张URL Loading System的图：

![](http://upload-images.jianshu.io/upload_images/872807-b7f17b6fbaf25831.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所以，可以拦截的网络请求包括NSURLSession，NSURLConnection以及UIWebVIew。
基于CFNetwork的网络请求，以及WKWebView的请求是无法拦截的。
现在主流的iOS网络库，例如AFNetworking，Alamofire等网络库都是基于NSURLSession或NSURLConnection的，所以这些网络库的网络请求都可以被NSURLProtocol所拦截。
还有一些年代比较久远的网络库，例如ASIHTTPRequest，MKNetwokit等网路库都是基于CFNetwork的，所以这些网络库的网络请求无法被NSURLProtocol拦截。

--

使用NSURLProtocol的主要可以分为5个步骤：
注册—>拦截—>转发—>回调—>结束

--

###多个NSURLProtocol嵌套使用

若一个项目中存在多个NSURLProtocol，那么NSURLProtocol的拦截顺序跟注册的方式和顺序有关。

对于使用registerClass方法注册的情况：
多个NSURLProtocol拦截顺序为注册顺序的反序，**即后注册的的NSURLProtocol先拦截。** 


对于通过配置NSURLSessionConfiguration对象的protocolClasses属性来注册的情况：
protocolClasses这个数组里只有**第一个NSURLProtocol会起作用。**

--

######参考文章:
[NSURLProtocol全攻略](http://www.jianshu.com/p/02781c0bbca9)

