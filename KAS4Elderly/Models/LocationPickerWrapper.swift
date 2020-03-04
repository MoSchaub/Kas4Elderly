//
//  LocationPickerWrapper.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 27.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationPickerWrapper: View {
    @Binding var centerCoordinate : CLLocationCoordinate2D
    @State private var pinDown = false
    @State private var locations = [MKPointAnnotation]()
        
        var body: some View {
            VStack {
                ZStack{
                    Group{
                        LocationPicker(centerCoordinate: $centerCoordinate, annotations: locations)
                            .edgesIgnoringSafeArea(.all)
                        if !pinDown{
                            Image("Pin")
                                .padding(.bottom, 37.0)
                        }
                        VStack {
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.putPinDown()
                                }) {
                                    if pinDown{
                                        Text("Cancel")
                                    } else{
                                        Text("Select")
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.bottom, 5)
                                .padding(.trailing)
                            }
                           
                            
                        }
                    }
                }
            }
        }
        
        func putPinDown(){
            if self.pinDown{
                self.locations = []
                self.pinDown = false
            } else{
                let newLocation = MKPointAnnotation()
                newLocation.title = "Example location"
                newLocation.coordinate = self.centerCoordinate
                self.locations.append(newLocation)
                self.pinDown = true
            }
        }
}

struct LocationPickerWrapper_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerWrapper(centerCoordinate: .constant(CLLocationCoordinate2D()))
    }
}
