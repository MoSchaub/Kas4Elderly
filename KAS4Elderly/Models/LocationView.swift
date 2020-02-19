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
    
    @ObservedObject var userData: UserData
    
    
    var body: some View {
        VStack{
            LocationPickerView(location: $userData.localUser.location).edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack{
                        
                        Spacer()
                        
                        Text(userData.errorMessage)
                            .foregroundColor(.red)
                            .animation(.default)
                            .padding()
                        
                        Button(action: {
                            self.userData.weiter()
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

struct LocationPicker_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(userData: UserData())
            .environment(\.colorScheme, .dark)
    }
}
