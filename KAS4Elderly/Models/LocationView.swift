//
//  LocationView.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 02.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userData: UserData
    @State private var locations = [MKPointAnnotation]()
    
    var body: some View {
        VStack{
            LocationPickerWrapper(centerCoordinate: $userData.localUser.location).edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack{
                        
                        Spacer()
                        
                        Text(userData.errorMessage)
                            .foregroundColor(.red)
                            .animation(.default)
                            .padding()
                        
                        Button(action: {
                            self.userData.weiter()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("weiter")
                                
                        }
                        
                       Button(action: {
                        self.userData.zurück()
                        }) {
                            Text("zurück")
                       }.padding()
                    }
            )
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(userData: UserData())
            .environment(\.colorScheme, .dark)
    }
}
