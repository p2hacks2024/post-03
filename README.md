# P2HACKS2024 アピールシート

## あとまわしリンク

コンセプト  
貯めて、流して、後回しをスッキリ

対象ユーザ  
あとで読もうと思っていた記事のブックマーク、Chrome のリーディングリスト、#times にあとで見ようと上げた動画のリンク...
そんな「あとまわしリンク」を溜めがちな人へ

利用の流れ

1. あとまわしリンクを溜める
2. あとまわしリンクを限界まで溜めると、溢れたあとまわしリンクはフレンドに Flush される、または消えてしまう
3. フレンドに迷惑をかけて社会的なプレッシャーを感じる、またはあとまわしリンクが消えてしまう前に、あとまわしリンクを消化する

### 推しポイント

- あとまわしリンクに集中するためのシンプルなデザイン
- あとまわしにしたものが共有される
- 友だちを催促できる
- あとまわしリンクをフラッシュする時の爽快感
- あとまわしリンクを見逃さないための体験設計
- 通知が来る
- ネイティブアプリ特有の機能
- iOS アプリは Unity などの物理エンジンを用いずに 100%Swift で実装
- 幅広い技術スタック

スクリーンショット(任意)  
<img width="1920" alt="15" src="https://github.com/user-attachments/assets/c912f78f-ec8e-4064-968d-4fdab7db0de0" />

### リンク

- [iOS App Repo](https://github.com/dolater/dolater-ios)
- [API Repo](https://github.com/dolater/dolater-api)
- [API (Internal) Repo](https://github.com/dolater/dolater-internal-api)
- [プロトタイプ](https://www.figma.com/design/bTdDbS0ix3CKSm7cttcUJv/Prototype?node-id=0-1&t=4W6SWC64HQwPsM2A-1)
- [ブレインストーム](https://www.figma.com/board/hfp8oItDdY33GMKFs90R7h/Brainstorm?node-id=0-1&t=LrMIpOZR6LBTSss4-1)
- [スライド](https://www.figma.com/slides/99WQhkmzgyt0A7uxPwcs2r/Presentation?node-id=38-32&t=kcMZ52ZDAQl73yXv-1)

## 開発体制

### 役割分担

| メンバー    | 担当     |
| ----------- | -------- |
| 及川 寛太   | iOS      |
| 大須賀 雅也 | サーバ   |
| 萩野 汰一   | デザイン |
| 下村 蒔里萌 | デザイン |

### 開発における工夫した点

- Firebase App Distribution を活用したデザイナーの実機によるデザインチェック
- fastlane による証明書管理・ビルド・テスト・配信ワークフローの自動化
- Slack への通知によりチームメンバーへの迅速なテスト結果、配信のフィードバック、クラッシュ検知
- Open API と Swagger UI を活用したスキーマ駆動開発
- GitHub Actions を活用した CI/CD
- Figma の開発モードを用いたデザイナー・エンジニア間のコミュニケーションの円滑化
- 集まってめっちゃやった！！

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
