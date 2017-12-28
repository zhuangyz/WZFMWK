##### SWSNetworking 说明
这个网络库是在 [casa 的 RTNetworking](https://github.com/casatwy/RTNetworking) 的基础上增删了一些功能。这个库的封装思路可参考 [casa 的这篇文章](https://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)。

##### 使用说明
简单使用：
1. 创建 SWSBaseAPIManager 的子类，假设子类名为 AAPI。
2. 在 AAPI 中遵循 SWSAPIManagerConfig 协议，并实现协议。
3. 在需要这个 API 的地方创建一个 AAPI 实例，并设置它的 paramsSource 和 delegate，并实现 SWSAPIManagerParamSource 和 SWSAPIManagerCallBackDelegate 协议。
4. 调用 AAPI 的 loadData 或 loadDataWithContext: 方法发起请求。

SWSRequestProxyConfigurator 允许使用者配置网络请求的参数，可以在 -application:didFinishLaunchingWithOptions: 里配置。

建议：
在一些情况下，子类对请求方法和请求参数进行封装是有益的，比如：
* 请求用户详情时，假设只需要 userID 参数并且 userID 是固定的，那么可以在 API 子类中创建一个 initWithUserID: 方法，并将 paramsSource 设置为 API 自己，这样外部不需要知道需要那些具体的参数以及参数名，只知道必须要这个 userID 的值就够了。
* 在列表中点赞的时候，通常只有一个 API 实例，那么可以在 API 子类中设置 paramSource 为自己，创建一个 likeWithID: 方法，在这个方法里调用 loadData 方法。这样外部只要调用 likeWithID: 就可以了。

SWSBaseListAPIManager 是基于 SWSBaseAPIManager 的、针对列表 API 封装出来的基类。
和 SWSBaseAPIManager 的区别：
* 用 listParamSource 和 listDelegate 取代 SWSBaseAPIManager 的 paramsSource 和 delegate，它们对应的协议也不一样；
* 发起请求时应该使用 loadFirstPage 和 loadNextPage 方法。
















