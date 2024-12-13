//
//  AddHistoryView.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

// Perubahan pada AddHistoryView agar mencatat riwayat transaksi
import SwiftUI

struct AddHistoryView: View {
    var item: Item
    @ObservedObject var viewModel: InventoryViewModel

    @Environment(\.presentationMode) var presentationMode
    @State private var transactionType = "Masuk"
    @State private var quantity = ""
    @State private var date = Date()

    var body: some View {
        Form {
            Section(header: Text("Jenis Transaksi")) {
                Picker("Jenis", selection: $transactionType) {
                    Text("Masuk").tag("Masuk")
                    Text("Keluar").tag("Keluar")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Jumlah Barang")) {
                TextField("Jumlah", text: $quantity)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Tanggal")) {
                DatePicker("Tanggal Transaksi", selection: $date, displayedComponents: .date)
            }

            Button("Simpan") {
                saveHistory()
            }
        }
        .navigationTitle("Tambah Riwayat")
    }

    private func saveHistory() {
        if let quantityInt = Int(quantity) {
            let adjustedQuantity = transactionType == "Masuk" ? quantityInt : -quantityInt
            viewModel.updateStock(for: item, amount: adjustedQuantity, type: transactionType, date: date)
            presentationMode.wrappedValue.dismiss()
        }
    }
}






