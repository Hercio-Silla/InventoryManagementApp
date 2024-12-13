//
//  InventoryViewModel.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

// History ViewModel untuk menyimpan dan memanipulasi riwayat transaksi
import Foundation
import SwiftUI

class InventoryViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var histories: [History] = [] // Menyimpan daftar riwayat transaksi

    // Fungsi untuk menambahkan barang baru
    func addItem(name: String, description: String, price: Double, category: String, stock: Int, photo: String) {
        let newItem = Item(name: name, description: description, price: price, category: category, stock: stock, photoPath: photo)
        items.append(newItem)
        saveItems()
    }

    // Fungsi untuk menambahkan riwayat transaksi
    func addHistory(itemId: UUID, type: String, quantity: Int, date: Date) {
        let newHistory = History(itemId: itemId, type: type, quantity: quantity, date: date)
        histories.append(newHistory)
        saveHistories()
    }
    
    // Fungsi untuk menghapus barang
       func deleteItem(item: Item) {
           items.removeAll { $0.id == item.id }
           saveItems()
       }

    // Fungsi untuk memperbarui stok barang
    func updateStock(for item: Item, amount: Int, type: String, date: Date) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].stock += amount
            addHistory(itemId: item.id, type: type, quantity: abs(amount), date: date)
            saveItems()
        }
    }

    // Fungsi untuk menyimpan data items ke UserDefaults
    func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "inventory_items")
        } catch {
            print("Gagal menyimpan data barang: \(error)")
        }
    }

    // Fungsi untuk memuat data items dari UserDefaults
    func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: "inventory_items") else { return }
        do {
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("Gagal memuat data barang: \(error)")
        }
    }

    // Fungsi untuk menyimpan data histories ke UserDefaults
    func saveHistories() {
        do {
            let data = try JSONEncoder().encode(histories)
            UserDefaults.standard.set(data, forKey: "inventory_histories")
        } catch {
            print("Gagal menyimpan data riwayat: \(error)")
        }
    }

    // Fungsi untuk memuat data histories dari UserDefaults
    func loadHistories() {
        guard let data = UserDefaults.standard.data(forKey: "inventory_histories") else { return }
        do {
            histories = try JSONDecoder().decode([History].self, from: data)
        } catch {
            print("Gagal memuat data riwayat: \(error)")
        }
    }

    init() {
        loadItems()
        loadHistories()
    }
}







