//
//  AddItemView.swift
//  InventoryManagementApp
//
//  Created by Hercio Venceslau Silla on 10/12/24.
//

import SwiftUI
import UIKit
import AVFoundation

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InventoryViewModel

    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var category = ""
    @State private var stock = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isCameraActive = false // Track which button is active

    var body: some View {
        Form {
            Section(header: Text("Informasi Barang")) {
                TextField("Nama Barang", text: $name)
                TextField("Deskripsi", text: $description)
                TextField("Harga", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Kategori", text: $category)
                TextField("Stok", text: $stock)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Foto Barang")) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Text("Belum ada foto")
                        .foregroundColor(.gray)
                }

                HStack {
                    Button("Ambil Foto") {
                        isCameraActive = true // Activate camera button
                        checkCameraAuthorizationStatus()
                    }
                    .disabled(isCameraActive) // Disable if camera is active

                    Spacer()

                    Button("Pilih dari Galeri") {
                        isCameraActive = false // Deactivate camera button
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                    .disabled(!isCameraActive) // Disable if gallery is active
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }

            Button("Simpan") {
                saveItem()
            }
        }
        .navigationTitle("Tambah Barang")
    }

    func saveItem() {
        if let price = Double(price), let stock = Int(stock), let image = selectedImage {
            let imageName = "\(UUID().uuidString).jpg"
            if let imagePath = saveImageToDocuments(image: image, imageName: imageName) {
                viewModel.addItem(name: name, description: description, price: price, category: category, stock: stock, photo: imagePath)
                dismiss()
            }
        }
    }

    func saveImageToDocuments(image: UIImage, imageName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent(imageName)

        do {
            try data.write(to: filePath)
            return filePath.path
        } catch {
            print("Gagal menyimpan gambar: \(error)")
            return nil
        }
    }

    func checkCameraAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            print("Akses kamera diizinkan")
            openCamera()
        case .notDetermined:
            print("Meminta akses kamera")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.openCamera()
                    } else {
                        print("Akses kamera ditolak")
                    }
                }
            }
        case .denied:
            print("Akses kamera ditolak")
            showSettingsAlert()
        case .restricted:
            print("Akses kamera dibatasi")
        @unknown default:
            print("Status tidak diketahui")
        }
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sourceType = .camera
            showImagePicker = true
        } else {
            print("Kamera tidak tersedia pada perangkat ini.")
        }
    }

    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Akses Kamera Diperlukan",
            message: "Harap izinkan aplikasi untuk mengakses kamera melalui Pengaturan.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Batal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Pengaturan", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}








