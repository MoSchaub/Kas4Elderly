//
//  ProfileView.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 24.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData = UserData()
    @State private var showImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Image(uiImage: userData.localUser.image ?? UIImage(named: "user")!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.secondary, lineWidth: CGFloat(integerLiteral: 4)))
                        .padding()
                        .sheet(isPresented: self.$showImagePicker) {
                            UserImagePicker(image: self.$userData.localUser.image, userData: self.userData)
                    }
                }
                
                
                HStack {
                    Text("Name: \(userData.localUser.name)").padding()
                    Spacer()
                    Button(action: {
                        self.userData.editing = true
                        self.userData.editNumber = 0
                    }) {
                        Image(systemName: "pencil.circle")
                    }.padding()
                }
                
                HStack {
                    Text("Alter: \(userData.localUser.age)").padding()
                    Spacer()
                    Button(action: {
                        self.userData.editing = true
                        self.userData.editNumber = 2
                    }) {
                        Image(systemName: "pencil.circle")
                    }.padding()
                        .sheet(isPresented: self.$userData.editing){
                            EditSheet(userData: self.userData,number: self.userData.editNumber )
                    }
                }
                
                HStack {
                    Text("E-mail: \(userData.localUser.email)").padding()
                    Spacer()
                    Button(action: {
                        self.userData.editing = true
                        self.userData.editNumber = 3
                    }) {
                        Image(systemName: "pencil.circle")
                    }.padding()
                }
                
                Text(userData.errorMessage).foregroundColor(.red)
                
                //wohnort change
                HStack {
                    Text("Wohnort \(userData.localUser.location.latitude); \(userData.localUser.location.longitude)").padding()
                    Spacer()
                    Button(action: {
                        self.userData.editing = true
                        self.userData.editNumber = 4
                    }) {
                        Image(systemName: "pencil.circle")
                    }.padding()
                }
                
                
                Button("Passwort ändern"){
                    self.userData.resetPassword(for: self.userData.localUser.email)
                }
                
                Button(action: {
                    self.userData.logOut()
                }) {
                    Text("Abmelden").multilineTextAlignment(.leading)
                }
                
            }
        }
    }
}

extension String {
    var hidden : String{
        var returnVal = ""
        for _ in self {
            returnVal += "*"
        }
        
        return returnVal
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userData: UserData())
    }
}
