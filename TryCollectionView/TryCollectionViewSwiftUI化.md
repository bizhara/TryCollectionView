# TryCollectionView SwiftUI化 設計例

## 目的

既存のUIKit実装をSwiftUIベースへ置き換え、Storyboard/Xib/UICollectionView依存を取り除く。
現在の画面仕様はシンプルで、アプリ名のタイトル表示と、非同期に取得したセルデータの一覧表示で構成されているため、SwiftUIでは `App`、`ContentView`、`CellView`、`ViewModel`、`CollectionViewCellData` に責務を分ける。

## 現状のUIKit構成

| 既存ファイル | 現在の責務 | SwiftUI化後の扱い |
| --- | --- | --- |
| `AppDelegate.swift` | `UIWindow` を生成し、Storyboardから `ViewController` を表示 | `@main App` に置き換える |
| `ViewController.swift` | タイトル設定、UICollectionView設定、データ取得、reload | `ContentView` と `ViewModel` に分割 |
| `ViewModel.swift` | タイトル取得、セルデータ保持、件数返却 | `ObservableObject` または `@Observable` なViewModelにする |
| `CollectionViewCell.swift` | XibのLabelへデータを反映 | `CellView` に置き換える |
| `CollectionViewCell.xib` | セルレイアウト | SwiftUIレイアウトで置き換える |
| `CollectionViewCellData.swift` | セル表示用データ | `Identifiable` に対応させて `List` / `ForEach` で扱う |
| `MockCellData.swift` | モックデータ生成 | 継続利用。必要に応じてRepository化 |
| `UseStoryboard.swift` | Storyboard読み込み補助 | 不要 |
| `UseXib.swift` | Xib読み込み補助 | 不要 |

## SwiftUI化後の推奨ファイル構成

```text
TryCollevtionView/
  TryCollectionViewApp.swift
  ContentView.swift
  CellView.swift
  ViewModel.swift
  CollectionViewCellData.swift
  MockCellData.swift
  Assets.xcassets
  Info.plist
```

UIKit専用の以下は、移行完了後に削除候補とする。

```text
AppDelegate.swift
ViewController.swift
ViewController.storyboard
CollectionViewCell.swift
CollectionViewCell.xib
Commons/UseStoryboard.swift
Commons/UseXib.swift
```

## 画面設計

### `TryCollectionViewApp`

アプリのエントリポイントを担当する。`UIApplicationMain` と `AppDelegate` を廃止し、SwiftUIの `@main` を使う。

```swift
import SwiftUI

@main
struct TryCollectionViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### `ContentView`

画面全体を担当する。既存の `titleLabel` と `collectionView` は、SwiftUIでは `Text` と `List` へ置き換える。

主な責務:

- `ViewModel` を保持する
- アプリ名を表示する
- セルデータ一覧を表示する
- 初回表示時に非同期でデータを取得する

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.titleString)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            List(viewModel.cellData) { cellData in
                CellView(cellData: cellData)
            }
            .listStyle(.plain)
        }
        .task {
            await viewModel.fetch()
        }
    }
}
```

### `CellView`

既存の `CollectionViewCell.xib` と `CollectionViewCell.swift` の代替。タイトルは1行で末尾省略、詳細は複数行表示する。

```swift
import SwiftUI

struct CellView: View {
    let cellData: CollectionViewCellData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cellData.titleString)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(cellData.detailString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 8)
    }
}
```

### `ViewModel`

SwiftUIから状態変更を監視できる形にする。既存の `numberOfSections` や `numberOfItems` は `List` が配列を直接扱うため、原則不要になる。

```swift
import Foundation

@MainActor
final class ViewModel: ObservableObject {
    @Published private(set) var cellData: [CollectionViewCellData] = []

    var titleString: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }

    func fetch() async {
        cellData = await MockCellData.getMockData()
    }
}
```

### `CollectionViewCellData`

`List` / `ForEach` で利用するため `Identifiable` に準拠させる。モックデータを再生成しても表示上問題がないなら `UUID` でよい。

```swift
import Foundation

struct CollectionViewCellData: Identifiable, Equatable {
    let id = UUID()
    let titleString: String
    let detailString: String

    init(title: String, detail: String) {
        self.titleString = title
        self.detailString = detail
    }
}
```

## データ取得設計

現状の `MockCellData.getMockData()` は `async` なので、そのままSwiftUIの `.task` から呼び出せる。
将来的にAPI通信へ差し替える可能性がある場合は、以下のようにデータ取得元を分離する。

```swift
protocol CellDataRepository {
    func fetchCellData() async throws -> [CollectionViewCellData]
}

struct MockCellDataRepository: CellDataRepository {
    func fetchCellData() async throws -> [CollectionViewCellData] {
        await MockCellData.getMockData()
    }
}
```

ただし、現在の規模ではRepository導入は必須ではない。まずは `MockCellData` を直接利用し、実データ取得が必要になった段階で分離するのが実装量を抑えられる。

## 移行手順

1. `TryCollectionViewApp.swift` を追加し、SwiftUIのエントリポイントを作る。
2. `ContentView.swift` を追加し、タイトルと一覧表示を実装する。
3. `CellView.swift` を追加し、Xibセルの表示仕様をSwiftUIへ移す。
4. `ViewModel.swift` を `ViewController` のネスト型から独立した型へ変更する。
5. `CollectionViewCellData` を `Identifiable` に準拠させる。
6. `MockCellData` が新しい `CollectionViewCellData` の初期化方式で動くことを確認する。
7. 起動設定からStoryboard依存を外す。
8. ビルドが通ったら、不要になったUIKitファイルとStoryboard/Xibを削除する。
9. Unit TestとUI TestをSwiftUI構成に合わせて更新する。

## テスト方針

### Unit Test

`ViewModel` を直接検証する。既存の `ViewController.ViewModel` 参照は、独立した `ViewModel` 参照へ置き換える。

検証対象:

- `titleString` がBundle名を返すこと
- `fetch()` 後に `cellData` の件数が `MockCellData.mockCellData.count` と一致すること
- 任意のセルの `titleString` / `detailString` がモックデータと一致すること

### UI Test

最低限、以下を確認する。

- アプリが起動する
- タイトルが表示される
- 1件目のセルタイトルが表示される
- 長いタイトルが存在するセルも表示される

SwiftUIの `List` はアクセシビリティ要素として扱いやすいため、必要に応じて `accessibilityIdentifier` を `ContentView` や `CellView` に追加する。

```swift
Text(viewModel.titleString)
    .accessibilityIdentifier("appTitle")

List(viewModel.cellData) { cellData in
    CellView(cellData: cellData)
}
.accessibilityIdentifier("cellList")
```

## 実装時の注意点

- `AppDelegate.swift` と `@main App` は同時にアプリのエントリポイントになり得るため、完全移行時はどちらか一方にする。
- `ViewModel` を `@MainActor` にしておくと、非同期取得後のUI状態更新を安全に扱える。
- `List` はセルの高さを内容に応じて自動調整するため、既存の `preferredLayoutAttributesFitting` 相当の処理は不要。
- 詳細テキストは複数行表示したいため、`fixedSize(horizontal: false, vertical: true)` を付けると意図が明確になる。
- 既存のStoryboard/Xibを削除する前に、ターゲットのBuild PhasesとInfo.plistのStoryboard設定を確認する。

## 最小実装イメージ

SwiftUI化後の最小構成は以下の責務分割になる。

```text
TryCollectionViewApp
  -> ContentView
      -> ViewModel
      -> List<CollectionViewCellData>
          -> CellView
MockCellData
  -> CollectionViewCellData
```

この構成で、現在のUIKit版と同等の表示仕様をSwiftUIで再現できる。
