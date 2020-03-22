//
//  LocationPickerViewControllerWrapper.swift
//  LocationPickerTest
//
//  Created by Moritz Schaub on 08.03.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationPickerViewControllerWrapper: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userData: UserData
    
    @State private var firstTime = true
    
    let popUp: Bool
    let skill: Skill?
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var address: String
    
    func makeUIViewController(context: Context) -> CustomLocationPickerViewController {
        let storyboard = UIStoryboard(name: "LocationPicker", bundle: Bundle.main)
        let nav = storyboard.instantiateViewController(identifier: "LocationPicker")
        let customController =  nav.children.first! as! CustomLocationPickerViewController
        customController.userData = self.userData
        customController.popUp = self.popUp
        return customController
    }
    
    func updateUIViewController(_ viewController: CustomLocationPickerViewController, context: Context) {
        
        if viewController.coordinate.latitude != self.coordinate.latitude || viewController.coordinate.longitude != self.coordinate.longitude {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.coordinate = viewController.coordinate
                self.address = viewController.locationAddress
            }
        }
        
        if popUp{
            if firstTime{
                viewController.presentLocationPicker()
                DispatchQueue.main.async {
                    self.firstTime = false
                }
            }
            if !firstTime && !viewController.showingPicker{
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                    if self.popUp{
                        if let skill = self.skill{
                            DispatchQueue.main.async {
                                self.userData.update(skill: skill)
                            }
                        } else{
                            DispatchQueue.main.async {
                                self.userData.updateUser()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}
