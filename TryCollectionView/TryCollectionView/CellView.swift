import SwiftUI

struct CellView: View {
    let cellData: CollectionViewCellData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cellData.titleString)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .accessibilityIdentifier("cellTitle_\(cellData.id.uuidString)")

            Text(cellData.detailString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("cellDetail_\(cellData.id.uuidString)")
        }
        .padding(.vertical, 8)
    }
}

