# CS193p SwiftUI 实训（Memorize + Emoji Art）

参照 Stanford CS193p *Developing Apps for iOS* (Spring 2023) 编排的实训工程。

## 环境
- Xcode 16+ / iOS 17+ 模拟器
- 工程由 [XcodeGen](https://github.com/yonaskolb/XcodeGen) 从 `project.yml` 生成，`.xcodeproj` 不入库

## 本地构建
```bash
brew install xcodegen
xcodegen generate
open Memorize.xcodeproj      # 或命令行：
xcodebuild -project Memorize.xcodeproj -scheme Memorize \
  -destination 'generic/platform=iOS Simulator' build
```

## CI
`.github/workflows/ios.yml` 在 GitHub Actions 的 `macos-15` runner 上做真实编译验证。
