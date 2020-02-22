//
//  LocationPickerView.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 02.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import LocationPickerViewController
import MapKit

struct LocationPickerView: UIViewControllerRepresentable {
    
    @Binding var location : CLLocationCoordinate2D
    @State private var locationPicker = LocationPicker()
    
    func makeUIViewController(context: Context) -> UIViewController {
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
            self.location = CLLocationCoordinate2D(latitude: pickedLocationItem.coordinate?.latitude ?? 0, longitude: pickedLocationItem.coordinate?.longitude ?? 0)
        }
        return locationPicker
    }


    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
            self.location = CLLocationCoordinate2D(latitude: pickedLocationItem.coordinate?.latitude ?? 0, longitude: pickedLocationItem.coordinate?.longitude ?? 0)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerView(location: .constant(CLLocationCoordinate2D(latitude: 20, longitude: 20))) .environment(\.colorScheme,.dark)
    }
}
