//
//  SkillEditSheet.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 11.03.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct SkillEditSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userData: UserData
    
    @Binding var skill: Skill
    let number: Int
    let kategorien = Skill.Category.all
    
    var body: some View {
        NavigationView {
            VStack {
                if self.number == 1 {
                    TextField("Name eingeben", text: $skill.name){
                    self.update()
                    }.modifier(TextFieldModifier())
                } else if self.number == 2 {
                    ImagePickerView(inputImage: $skill.image)
                } else if number == 3 {
                    Picker("Kategorie", selection: $skill.category) {
                        ForEach(kategorien){item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                } else if self.number == 4 {
                    Stepper("Minimal: \(skill.minimumPeople) Leute", value: $skill.minimumPeople, in: 0 ... skill.maximumPeople)
                    Stepper("Maximal: \(skill.maximumPeople) Leute", value: $skill.maximumPeople, in: skill.minimumPeople ... Int.max)
                } else if self.number == 5 {
                    LocationPickerViewControllerWrapper(userData: userData, popUp: true, skill: skill, coordinate: $skill.location, address: $skill.address)
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
            .navigationBarTitle(Text(skill.name + " bearbeiten"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.update()
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Speichern")
            })
        }
        .onDisappear{
            self.userData.update(skill: self.skill)
        }
    }
    
    func update(){
        userData.update(skill: skill)
    }
    
}

struct SkillEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        SkillEditSheet(userData: UserData(), skill: .constant(Skill.example), number: 2)
    }
}
