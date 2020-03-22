//
//  MySkillsView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 21.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct MySkillsView: View {
    
    @ObservedObject var userData: UserData
    @State private var showAddSkillView = false
    
    
    var body: some View {
        NavigationView{
            List{
                Section(footer: Text(userData.errorMessage).foregroundColor(.red)){
                    ForEach(userData.localUserSkills) { item in
                        NavigationLink(destination: SkillDetailView(owned: true,image: Image(uiImage: item.image ?? UIImage(named: "user")!), userData: self.userData, skill: item)) {
                            SkillRow(userData: self.userData, skill: item)
                        }
                    }
                    .onDelete(perform: self.userData.deleteSkills)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Deine Skills",displayMode: .inline)
            .navigationBarItems(leading: EditButton(),trailing: Button(action: {
                self.showAddSkillView.toggle()
            }){
                Image(systemName: "plus")
            })
                .sheet(isPresented: $showAddSkillView) {
                    AddSkillView(userData: self.userData, skill: Skill(name: "Skill", maximumPeople: 10, minimumPeople: 3, location: self.userData.localUser.location, category: .other, user: self.userData.localUser, address: " "))
            }
        }
    }
}

struct MySkills_Previews: PreviewProvider {
    static var previews: some View {
        MySkillsView(userData: UserData())
    }
}

struct SkillRow: View {
    
    @ObservedObject var userData: UserData
    @State var skill: Skill
    
    var skillIndex: Int? {
        userData.localSkills.firstIndex(where: { $0.id == skill.id})
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(skill.name)
                    .font(.headline)
                Text(skill.category.rawValue)
            }
            Spacer()
            Text(skill.address)
        }
        .onAppear{
            if let skillIndex = self.skillIndex{
                self.skill = self.userData.localSkills[skillIndex]
            }
        }
    }
}
