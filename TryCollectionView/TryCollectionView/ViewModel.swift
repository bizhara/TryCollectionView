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
