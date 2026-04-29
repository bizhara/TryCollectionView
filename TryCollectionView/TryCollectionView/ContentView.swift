import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.cellData) { cellData in
                CellView(cellData: cellData)
            }
            .listStyle(.plain)
            .navigationTitle(viewModel.titleString)
        }
        .accessibilityIdentifier("contentView")
        .task {
            await viewModel.fetch()
        }
    }
}

