import Foundation

struct CollectionViewCellData: Identifiable, Equatable {
    let id: UUID
    let titleString: String
    let detailString: String

    init(id: UUID = UUID(), title: String, detail: String) {
        self.id = id
        self.titleString = title
        self.detailString = detail
    }
}
