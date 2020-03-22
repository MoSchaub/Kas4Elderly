//
//  ImagePickerView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 24.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct ImagePickerView: View {
    @State private var image: Image = Image("user")
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @Binding var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Bild auswählen")
                .font(.largeTitle)
            
            Spacer()
            
            image
                .resizable()
                .scaledToFit()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.primary, lineWidth: 1))
                .shadow(color: .primary, radius: 2)
                .padding()
                .animation(.default)
            
            Button("bearbeiten") {
                self.showingActionSheet = true
            }
            
            Spacer()
                
            .actionSheet(isPresented: $showingActionSheet){
                ActionSheet(title: Text("Bild auswählen"), buttons: [
                    .default(Text("Foto auswählen"), action: {
                        self.showingImagePicker = true
                    }),
                    .destructive(Text("Bild entfernen"), action: {
                        self.inputImage = nil
                        self.loadImage()
                    })
                ])
            }
        }
        .sheet(isPresented: $showingImagePicker,onDismiss: self.loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .onAppear{
            self.loadImage()
        }
    }
    
    func loadImage() {
        if let inputImage = inputImage {
        image = Image(uiImage: inputImage)
        } else {
            image = Image(uiImage: UIImage(named: "user")!)
        }
    }
    
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(inputImage: .constant(nil))
    }
}
