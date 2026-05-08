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
