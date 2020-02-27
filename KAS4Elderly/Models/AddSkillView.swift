//
//  AddSkillView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 06.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit
import Parse

struct AddSkillView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userData : UserData
    @State var skill : Skill
    @State private var location = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    let kategorien = Skill.Category.all
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Name")) {
                    TextField("Name eingeben",text: $skill.name)
                }
                
                Section{
                    Picker("Kategorie", selection: $skill.category) {
                        ForEach(kategorien){item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }
                
                Section(header: Text("Gruppengröße")){
                    Stepper("Minimal: \(skill.minimumPeople) Leute", value: $skill.minimumPeople, in: 0 ... skill.maximumPeople)
                    Stepper("Maximal: \(skill.maximumPeople) Leute", value: $skill.maximumPeople, in: skill.minimumPeople ... Int.max)
                }
                
                NavigationLink(destination: LocationPickerWrapper(centerCoordinate: $skill.location)
                    .overlay(
                    VStack{

                        Spacer()

                        Text(userData.errorMessage)
                            .foregroundColor(.red)
                            .animation(.default)
                            .padding()

                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.userData.add(skill: self.skill)
                        }) {
                            Text("einstellen")
                        }
                    .padding()
                    }
                )) {
                    Text("weiter")
                }
                
            }.navigationBarTitle("Skill hinzufügen",displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Abrechen")
                }))
        }
    }
    
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView(userData: UserData(), skill: Skill.example)
    }
}
