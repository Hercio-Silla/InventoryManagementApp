//
//  ContentView.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ItemListView(viewModel: InventoryViewModel())
    }
}

#Preview {
    ContentView()
}
