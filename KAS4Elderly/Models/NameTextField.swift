//
//  NameTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct NameTextField: View {
    @Binding var name: String
    
    var body: some View {
        TextField("Name eingeben", text: $name)
            .modifier(TextFieldModifier())
            //.textContentType(.username)
    }
    
}

struct NameTextField_Previews: PreviewProvider {
    static var previews: some View {
        NameTextField(name: .constant(""))
    }
}
