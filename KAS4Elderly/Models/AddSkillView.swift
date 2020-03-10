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
    
    //@State var currentStep = 1
    
    var body: some View {
        
        VStack{
            if self.userData.addSkillStep == 1 {
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
                        
                    }.navigationBarTitle("Skill hinzufügen",displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Abrechen")
                        }))
                }
            } else if userData.addSkillStep == 2{
                NavigationView{
                    
                    LocationPickerViewControllerWrapper(userData: userData, popUp: false, coordinate: $skill.location, address: $skill.address)
                        .navigationBarTitle(" ",displayMode: .inline)
                }
            } else{
                Spacer()
                ImagePickerView(inputImage: $skill.image)
                Spacer()
                
                Button(action: {
                    self.zurück()
                }){
                    Text("zurück")
                }
                .padding()
                
            }
            
            Text(userData.errorMessage).animation(.default)
            if userData.addSkillStep != 2{
                Button(action: {
                    self.weiter()
                }){
                    if self.userData.addSkillStep < 3{
                        Text("Weiter")
                    } else{
                        Text("Einstellen")
                    }
                }
                .padding()
            }
        }
        
        
    }
    
    func weiter(){
        userData.addSkillWeiter(location: self.skill.location)
        if userData.addSkillStep == 3{
            self.userData.add(skill: skill)
            self.presentationMode.wrappedValue.dismiss()
            self.userData.addSkillStep = 1
        }
    }
    
    func zurück(){
        self.userData.addSkillZurück()
    }
    
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView(userData: UserData(), skill: Skill.example)
    }
}
