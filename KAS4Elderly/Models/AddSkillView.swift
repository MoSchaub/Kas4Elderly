//
//  AddSkillView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 06.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct AddSkillView: View {
    
    @ObservedObject var userData : UserData
    
    @State var skill = Skill(name: "Skill", maximumPeople: 100, minimumPeople: 5, location: CLLocationCoordinate2D(latitude: 20, longitude: 20), category: .other)
    @State private var isValid = false
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Name")) {
                    TextField("Name eingeben",text: $skill.name)
                }
                
                Section(header: Text("Kategorie")){
                    Picker(selection: $skill.category, label: Text("Kategorie")) {
                        ForEach(Skill.Category.all, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Gruppengröße")){
                    Stepper("Minimal: \(skill.minimumPeople) Leute", value: $skill.minimumPeople, in: 0 ... skill.maximumPeople)
                    Stepper("Maximal: \(skill.maximumPeople) Leute", value: $skill.maximumPeople, in: skill.minimumPeople ... Int.max)
                }
                
                NavigationLink(destination: LocationPickerView(location: $skill.location)
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
                            Text("einstellen")
                        }
                    .padding()
                    }
                )) {
                    Text("weiter")
                }
                
            }.navigationBarTitle("Skill hinzufügen",displayMode: .inline)
        }
    }
    
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView(userData: UserData())
    }
}
