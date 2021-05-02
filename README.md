## flutter デプロイ方法
1. Xcodeの設定  
```
open ios/Runner.xcworkspace
```
でXcodeを開き、左メニューの上のRunnerをクリック  
Signin & Capabillitiesの部分でアカウントを追加  
2. iOS用にビルドする。  
```
flutter build ios
```
3. PCとiPhoneを接続する  
4. iPhoneのデバイスIDを調べる  
```
flutter devices
```
5. インストールする  
```
flutter install -d [デバイスID]
```
※アプリを開く時はiPhone上で  
設定 -> 一般 -> プロファイルとデバイス管理  
からアプリを信頼する必要あり