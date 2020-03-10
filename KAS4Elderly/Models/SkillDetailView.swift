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
    
    @State private var editingMode = false
    @State private var showShareSheet = false
    let owned: Bool
    
    @ObservedObject var userData: UserData
    var skill: Skill
    
    var skillIndex: Int {
        userData.localSkills.firstIndex(where: { $0.id == skill.id })!
    }
    
    var body: some View {
        NavigationView{
            Form{
                Image(uiImage: skill.image ?? UIImage(data: Data(base64Encoded: defaultImage)! )!)
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.primary, lineWidth: 1))
                    .shadow(color: .primary, radius: 2)
                    .padding()
                    .animation(.default)
                
                Section(header: Text("Name")){
                    Text(skill.name)
                }
                
                Section(header: Text("Kategorie")) {
                    Text(skill.category.rawValue)
                }
                
                Section(header: Text("Veranstalter")) {
                    Text(skill.category.rawValue)
                }
                
                Section(header: Text("Kontakt")){
                    Text(skill.owner.email)
                }
                
                Section(header: Text("Anzahl Teilnehmer")){
                    Text("Minimal: \(skill.minimumPeople)")
                    
                    Text("Maximal: \(skill.maximumPeople)")
                }
                
                Section(header: Text("Ort")){
                    Text("Ort: \(skill.address) (\(skill.location.latitude); \(skill.location.longitude))")
                        .onLongPressGesture {
                            //show share sheet
                            self.showShareSheet = true
                    }
                }
            }
        }
        .navigationBarTitle(Text(skill.name), displayMode: .inline)
        .navigationBarHidden(!owned)
        .navigationBarItems(trailing: Button(action: {
                if self.owned{
                    if self.editingMode{
                        self.userData.update(skill: self.skill)
                        self.editingMode = false
                    } else{
                        self.editingMode = true
                    }
                }
            }){
                if self.owned{
                    if self.editingMode{
                        Text("Speichern")
                    } else{
                        Text("Bearbeiten")
                    }
                } else{
                    Text("")
                }
                
            }
        )
        .sheet(isPresented: self.$showShareSheet) {
            ShareSheet(activityItems: ["\(self.skill.location)"])
        }
    }
}

struct SkillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SkillDetailView(owned: false, userData: UserData(), skill: Skill.example)
    }
}

extension CLLocationCoordinate2D: CustomDebugStringConvertible{
    public var debugDescription: String {
        "(\(self.latitude), \(self.longitude)"
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
      
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
      
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
