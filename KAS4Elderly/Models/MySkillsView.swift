//
//  MySkillsView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 21.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import LocationPickerViewController
import MapKit

struct MySkillsView: View {
    
    @ObservedObject var userData: UserData
    @State private var showAddSkillView = false
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    ForEach(userData.localSkills) { item in
                        HStack {
                            VStack {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.category.rawValue)
                            }
                            Spacer()
                            Text(" ")
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
                    AddSkillView(userData: self.userData)
            }
        }
    }
}

struct MySkills_Previews: PreviewProvider {
    static var previews: some View {
        MySkillsView(userData: UserData())
    }
}
