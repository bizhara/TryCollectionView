import XCTest
@testable import TryCollectionView

final class ViewModelTests: XCTestCase {
    @MainActor
    func testTitleString() {
        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.titleString, Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
    }

    @MainActor
    func testFetchStoresMockData() async {
        let viewModel = ViewModel()

        await viewModel.fetch()

        XCTAssertEqual(viewModel.cellData.count, MockCellData.mockCellData.count)
        XCTAssertEqual(viewModel.cellData, MockCellData.mockCellData)
    }
}
