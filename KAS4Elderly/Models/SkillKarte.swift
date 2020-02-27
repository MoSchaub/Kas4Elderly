//
//  SkillKarte.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 23.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct SkillKarte: View {
    
    @ObservedObject var userData: UserData
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 50.9317, longitude: 6.9582)
    @State private var locations = [SkillAnnotation]()
    @State private var selectedPlace: SkillAnnotation?
    @State private var showingPlaceDetails = false
    
    var body: some View {
        ZStack{
            MapView(userData: userData, centerCoordinate: $centerCoordinate,selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            
        }
        .sheet(isPresented: $showingPlaceDetails, content: {
            SkillDetailView(userData: self.userData, skill: self.selectedPlace!.skill )
        })
        .onAppear{
            self.locations = self.userData.allLocations()
        }
    }
    
}

struct SkillKarte_Previews: PreviewProvider {
    static var previews: some View {
        SkillKarte(userData: UserData())
    }
}

class SkillAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    
    var skill: Skill
    
    var title: String?
    
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, skill: Skill) {
        self.coordinate = coordinate
        self.skill = skill
    }
    
    init(annotation: MKAnnotation, skill: Skill){
        self.coordinate = annotation.coordinate
        
        if let title = annotation.title{
            self.title = title
        }
        if let subtitle = annotation.subtitle{
            self.subtitle = subtitle
        }
        
        self.skill = skill
    }
    
    
}
