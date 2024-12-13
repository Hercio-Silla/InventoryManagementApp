//
//  ItemModel.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import Foundation

struct Item: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var price: Double
    var category: String
    var stock: Int
    var photoPath: String // Path file gambar yang disimpan
}

