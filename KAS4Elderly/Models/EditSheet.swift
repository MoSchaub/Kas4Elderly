//
//  EditSheet.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 13.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct EditSheet: View {
    
    @ObservedObject var userData: UserData
    
    @State var number : Int
    
    var body: some View {
        Group{
            if self.userData.editNumber == 0{
                NameTextField(userData: userData)
            } else if self.userData.editNumber == 1{
                PasswordTextField(userData: userData)
            }else if self.userData.editNumber ==  2{
                AgeTextField(userData: userData)
            } else if self.userData.editNumber == 3{
                EmailTextField(userData: userData)
            }else if self.userData.editNumber == 4 {
                LocationView(userData: userData)
            }
        }
    }
}

struct EditSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditSheet(userData: UserData(),number: 1)
    }
}
