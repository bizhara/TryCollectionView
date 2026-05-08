# Swift Testing化

## 概要

`TryCollectionViewTests/ViewModelTests.swift` の単体テストを XCTest から Swift Testing に置き換えました。

## 変更内容

- `import XCTest` を `import Testing` に変更
- `Bundle` を参照するため `import Foundation` を追加
- `XCTestCase` を継承した `final class ViewModelTests` を `struct ViewModelTests` に変更
- テストメソッドに `@Test` を付与
- `XCTAssertEqual` を `#expect` に置き換え
- `ViewModel` が `@MainActor` のため、各テストの `@MainActor` 指定は維持

## 対象テスト

- `titleString()`
- `fetchStoresMockData()`

## 検証結果

Xcode のテスト一覧で Swift Testing のテストとして 2 件が検出されることを確認しました。

対象テストのみ実行し、以下の結果になりました。

- 2 tests
- 2 passed
- 0 failed
- 0 skipped

## 変更後の主な形

```swift
import Foundation
import Testing
@testable import TryCollectionView

struct ViewModelTests {
    @Test @MainActor
    func titleString() {
        let viewModel = ViewModel()

        #expect(viewModel.titleString == Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
    }

    @Test @MainActor
    func fetchStoresMockData() async {
        let viewModel = ViewModel()

        await viewModel.fetch()

        #expect(viewModel.cellData.count == MockCellData.mockCellData.count)
        #expect(viewModel.cellData == MockCellData.mockCellData)
    }
}
```
