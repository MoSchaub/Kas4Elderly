//
//  AddSkillView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 06.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct AddSkillView: View {
    
    @ObservedObject var userData : UserData
    
    var body: some View {
        Form{
            Picker(selection: $userData.skill.category, label: Text("Kategorie")) {
                ForEach(Skill.Category.all,id: \.hashValue){
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())

        }
    }
}

struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView(userData: UserData())
    }
}
