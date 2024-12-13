//
//  ItemDetailView.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//
// Penambahan pada ItemDetailView untuk menampilkan riwayat transaksi
import SwiftUI

struct ItemDetailView: View {
    var item: Item
    @ObservedObject var viewModel: InventoryViewModel

    var body: some View {
        VStack {
            if let uiImage = loadImageFromPath(item.photoPath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Text("Foto tidak tersedia")
                    .foregroundColor(.gray)
            }

            Text(item.name)
                .font(.largeTitle)
            Text(item.description)
            Text("Harga: \(item.price, specifier: "%.2f")")
            Text("Kategori: \(item.category)")
            Text("Stok: \(item.stock)")
            Spacer()

            NavigationLink(destination: AddHistoryView(item: item, viewModel: viewModel)) {
                Text("Tambah Riwayat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List {
                Section(header: Text("Riwayat Transaksi")) {
                    ForEach(viewModel.histories.filter { $0.itemId == item.id }) { history in
                        HStack {
                            Text(history.type)
                                .bold()
                            Spacer()
                            Text("\(history.quantity)")
                            Text("@ \(history.date, formatter: dateFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Detail Barang")
    }

    private func loadImageFromPath(_ path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}












