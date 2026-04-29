import Foundation

enum MockCellData {
    static let mockCellData = [
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, title: "1: セルタイトル", detail: "説明テキスト"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, title: "2: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？", detail: "説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, title: "3: セルタイトル", detail: "説明テキスト"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, title: "4: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？", detail: "説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, title: "5: セルタイトル", detail: "説明テキスト"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, title: "6: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？", detail: "説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, title: "7: セルタイトル", detail: "説明テキスト"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, title: "8: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？", detail: "説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, title: "9: セルタイトル", detail: "説明テキスト"),
        CollectionViewCellData(id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!, title: "10: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？", detail: "説明は複数行の設定にしてあるので、全部表示されるのが正解なのだが、どうだろうか？")
    ]

    static func getMockData() async -> [CollectionViewCellData] {
        mockCellData
    }
}
