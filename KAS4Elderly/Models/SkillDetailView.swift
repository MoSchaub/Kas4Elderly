//
//  SkillDetailView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 23.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct SkillDetailView: View {
    
    @ObservedObject var userData: UserData
    var skill: Skill
    
    var skillIndex: Int {
        userData.localSkills.firstIndex(where: { $0.id == skill.id })!
    }
    
    var body: some View {
        Form{
            Text(skill.name)
        }
    }
}

struct SkillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SkillDetailView(userData: UserData(), skill: Skill.example)
    }
}
