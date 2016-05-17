# Colorgy iOS App
[![codebeat badge](https://codebeat.co/badges/e538b932-40f9-41cb-81bc-04941fdd43e2)](https://codebeat.co/projects/github-com-colorgy-colorgyiosnavite)

哦。

## Dependencies
### Cocoapods (炸你專案)
1. FBSDKCoreKit
2. FBSDKLoginKit
3. FBSDKShareKit
4. [Fabric](https://get.fabric.io/)
5. [Crashlytics](https://try.crashlytics.com/)
6. Mixpanel
7. [AFNetworking](https://github.com/AFNetworking/AFNetworking)
2. [SDWebImage](https://github.com/rs/SDWebImage)
3. [SKPhotoBrowser](https://github.com/suzuki-0000/SKPhotoBrowser)
4. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
5. [ImagePickerSheetController](https://github.com/larcus94/ImagePickerSheetController)
6. [Realm](https://realm.io)
7. [keychain-swift](https://github.com/marketplacer/keychain-swift)
8. [Socket.IO-Client-Swift](https://github.com/nuclearace/Socket.IO-Client-Swift)
9. [iVersion](https://github.com/nicklockwood/iVersion)

### Carthage (讚讚讚，以死，不用惹)

**感謝❤️以上作者**

## Project 小解釋
不解釋（誤
### API & Refresh 機制的設計
#### Refresh Center
這個地方會管理 access token 跟 refresh token 的生命。

- 在 APP launch 時，會開始跑一個背景的 job，一直去監看 access token 是不是快過期了，過期就馬上換。
- Access token 有效時間 7200 秒。
- Refresh token 不會過期，但只能被用一次。所以同時 fire 兩次換 token 的 job 會造成錯誤。

當 APP 進入背景
- 整個 center 會暫時 lock 住。
- 背景 job，會被暫停。

當 APP 進入前景
- 背景 job 開始執行。
- 會先檢查 access token 是否過期，過期馬上換一個。
- 再檢查 access token 時，所有 api 都無法動作。

#### 關於 API
因為在 access token 過期或者正在 refresh 的時候，所有的 api call 皆會失敗。

- 每次 call api 時，都會先檢查 refresh center 不在 refresh 才會允許放行。
- 如果 refresh center 正在檢查 access token 狀態，api 將會等待他完成。
- 每次檢查間格設定在 0.1 秒，檢查 100 次，所以這個等待機制將會等待 10 秒。

#### Refesh Center 命名怪怪的
這邊整個 center 好像都是檢查 access token 為主，想改名字勒。


### MVVM 架構
Apple 在 iOS 上的 MVC 被稱為 Massive View Controller，因為在 Controller 之中，要操作 View 跟 邏輯的東西。所以搞到後來整個邏輯跟畫面會混在一起，有時候在 callback 中要處理 View，有時候再更新資料後要處理 View，最後整個專案會很難維護。

