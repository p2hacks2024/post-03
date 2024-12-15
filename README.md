# P2HACKS2024 アピールシート 

## プロダクト名  

コンセプト  
貯めて、流して、後回しをスッキリ

対象ユーザ  
あとで読もうと思っていた記事のブックマーク、Chromeのリーディングリスト、#timesにあとで見ようと上げた動画のリンク...
そんな「あとまわしリンク」を溜めがちな人へ

利用の流れ  
1. あとまわしリンクを溜める
2. あとまわしリンクを限界まで溜めると、溢れたあとまわしリンクはフレンドにFlushされる、または消えてしまう
3. フレンドに迷惑をかけて社会的なプレッシャーを感じる、またはあとまわしリンクが消えてしまう前に、あとまわしリンクを消化する


### 推しポイント  
- あとまわしリンクに集中するためのシンプルなデザイン
- あとまわしにしたものが共有される
- 友だちを催促できる
- あとまわしリンクをフラッシュする時の爽快感
- あとまわしリンクを見逃さないための体験設計
- 通知が来る
- ネイティブ特有の機能

スクリーンショット(任意)  
<img width="1920" alt="15" src="https://github.com/user-attachments/assets/c912f78f-ec8e-4064-968d-4fdab7db0de0" />


### リンク
- [iOS App Repo](https://github.com/dolater/dolater-ios)
- [API Repo](https://github.com/dolater/dolater-api)
- [API (Internal) Repo](https://github.com/dolater/dolater-internal-api)
- [プロトタイプ](https://www.figma.com/design/bTdDbS0ix3CKSm7cttcUJv/Prototype?node-id=0-1&t=4W6SWC64HQwPsM2A-1)
- [ブレインストーム](https://www.figma.com/board/hfp8oItDdY33GMKFs90R7h/Brainstorm?node-id=0-1&t=LrMIpOZR6LBTSss4-1)
- スライド


## 開発体制

### 役割分担

| メンバー | 担当 |
| --- | --- |
| 及川 寛太 | iOS |
| 大須賀 雅也 | サーバ |
| 萩野 汰一 | デザイン |
| 下村 蒔里萌 | デザイン |

### 開発における工夫した点
- Slack
- App Distribution
- Figma
- Open API
- CI/CD
- 集まってめっちゃやった！

## 開発技術

### 利用したプログラミング言語

- Swift
- Go

### 利用したフレームワーク・ライブラリ

- apple/swift-openapi-generator
- firebase/firebase-ios-sdk
- gin-gonic/gin
- oapi-codegen/oapi-codegen
- Open API
- Apple Frameworks
    - App Extension (Share)
    - AuthenticationService
    - Observation
    - PhotosUI
    - SpriteKit
    - SwiftUI
    - UserNotifications
    - Swift Package Manager
    - Swift Testing

### その他開発に使用したツール・サービス

- fastlane
    - match
    - gym
    - scan
    - pilot
- Figma
- Firebase
    - Analytics
    - App Distribution
    - Authentication
    - IAM
        - Workload Identity Federation
    - Cloud Messaging
    - Cloud Scheduler
    - Cloud Storage
    - Crashlytics
    - Remote Config
- GitHub
- GitHub Actions
- Google Cloud Platform
- Slack
- Swagger UI
- TestFlight
- Xcode
