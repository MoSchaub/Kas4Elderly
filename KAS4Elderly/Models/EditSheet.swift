//
//  EditSheet.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 13.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import Parse

struct EditSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userData: UserData
    
    @State private var user = User(PFUser.current()!)
    @State private var secondPassword = ""
    @State private var secondEmail = ""
    
    
    
    var number : Int
    
    var body: some View {
        Group{
            if self.userData.editNumber == 0{
                TextField("Name eingeben", text: $userData.localUser.name,onCommit: self.update)
                .modifier(TextFieldModifier())
            } else if self.userData.editNumber ==  2{
                TextField(" Alter eingeben", text: $userData.localUser.age, onCommit: self.update)
                .keyboardType(.numbersAndPunctuation)
                .modifier(TextFieldModifier())
            } else if self.userData.editNumber == 3{
                TextField("E-mail eingeben", text: $user.email,onCommit: self.update)
                               .modifier(TextFieldModifier())
                               .keyboardType(.emailAddress)
                               //.textContentType(.emailAddress)
                           
                           TextField(" Email erneut eingeben", text: $secondEmail,onCommit: self.update)
                               .modifier(TextFieldModifier())
                               .keyboardType(.emailAddress)
                               //.textContentType(.emailAddress)
            }else if self.userData.editNumber == 4 {
                LocationPickerViewControllerWrapper(userData: userData, popUp: true,coordinate: $user.location, address: .constant(""))
            }
        }
    }
    
    func update(){
        if self.userData.validate(name: user.name, password: user.password, secondPassword: self.secondPassword, age: user.age, email: user.email, secondEmail: self.secondEmail, currentPoperty: userData.editNumber){
            userData.updateUser()
        }
    }
    
}

struct EditSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditSheet(userData: UserData(),number: 1)
    }
}
