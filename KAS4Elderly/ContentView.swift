//
//  ContentView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 05.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userData = UserData()
    
    var body: some View {
        Group{
            if userData.loggedIn{
                TabView {
                    MySkillsView(userData: userData)
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Skills")
                    }
                    SkillKarte(userData: userData)
                        .tabItem{
                            Image(systemName: "map")
                            Text("Karte")
                    }
                    ProfileView(userData: userData)
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profil")
                    }
                }
            } else if !userData.loggedIn{
                StartView(userData: userData)
            } else{
                Text("Etwas ist Schiefgelaufen")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, Locale(identifier: "de"))
    }
}
