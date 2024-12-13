//
//  ItemListView.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import SwiftUI

struct ItemListView: View {
    @ObservedObject var viewModel: InventoryViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                        HStack {
                            if let uiImage = loadImageFromPath(item.photoPath) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            } else {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 50)
                                    .overlay(Text("No Image").font(.caption))
                            }

                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Kategori: \(item.category)")
                                    .font(.subheadline)
                                Text("Harga: \(item.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                Text("Stok: \(item.stock)")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Daftar Barang")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddItemView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    // Fungsi untuk menghapus barang
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = viewModel.items[index]
            viewModel.deleteItem(item: item)
        }
    }

    // Fungsi untuk memuat gambar dari path
    private func loadImageFromPath(_ path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}





