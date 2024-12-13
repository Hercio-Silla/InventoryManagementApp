//
//  HistoryModel.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import Foundation

struct History: Identifiable, Codable {
    var id = UUID()
    var itemId: UUID
    var type: String // "Masuk" atau "Keluar"
    var quantity: Int
    var date: Date
}

