//
//  InventoryManagementAppApp.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import SwiftUI

@main
struct InventoryManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ItemListView(viewModel: InventoryViewModel())
        }
    }
}
