//
//  UserImagePicker.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 27.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct UserImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userData: UserData
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: UserImagePicker
        
        init(_ parent: UserImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.userData.localUser.image = uiImage
                parent.userData.updateUser()
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> UserImagePicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
}

struct UserImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        UserImagePicker(image: .constant(nil), userData: UserData())
    }
}
