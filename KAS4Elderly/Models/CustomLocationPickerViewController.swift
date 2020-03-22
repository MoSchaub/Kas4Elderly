//
//  CustomLocationPickerViewController.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/29/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import LocationPicker
import LocationPickerViewController
import MapKit

class CustomLocationPickerViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D()
    var locationAddress = ""
    
    var showingPicker = false
    
    var popUp = false
    
    var userData : UserData!
    
    var historyLocationList: [LocationItem] {
        get {
            if let locationDataList = UserDefaults.standard.array(forKey: "HistoryLocationList") as? [Data] {
                // Decode NSData into LocationItem object.
                return locationDataList.map({ NSKeyedUnarchiver.unarchiveObject(with: $0) as! LocationItem })
            } else {
                return []
            }
        }
        set {
            // Encode LocationItem object.
            let locationDataList = newValue.map({ NSKeyedArchiver.archivedData(withRootObject: $0) })
            UserDefaults.standard.set(locationDataList, forKey: "HistoryLocationList")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if popUp{
            self.presentLocationPicker(animated: false)
        } else{
            self.pushLocationPicker(animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: MKMapView
    
    // MARK: Navigation
    
    @IBAction func pushLocationPickerButtonDidTap(button: UIButton) {
        if popUp{
            self.presentLocationPicker()
        } else{
            self.pushLocationPicker()
        }
        
    }
    
    func pushLocationPicker(animated: Bool = true){
        // Push Location Picker via codes.
        let locationPicker = LocationPicker()
        locationPicker.alternativeLocations = historyLocationList.reversed()
        locationPicker.isAlternativeLocationEditable = true
        locationPicker.preselectedIndex = 0
        locationPicker.alternativeLocationIconColor = UIColor.orange
        locationPicker.currentLocationText = "Ihr Standort"
        locationPicker.locationDeniedCancelText = "Abrechen"
        locationPicker.locationDeniedGrantText = "Erlauben"
        locationPicker.locationDeniedAlertTitle = "Standortdaten verweigert"
        locationPicker.locationDeniedAlertMessage = "Erlaube Zugriffauf Standortdaten um den aktuellen Satndort zu nutzen"
        locationPicker.searchBarPlaceholder = "Suche nach Ort"
        locationPicker.tableViewBackgroundColor = UIColor.systemBackground
        
        // Completion closures
        locationPicker.selectCompletion = { selectedLocationItem in
            print("Select completion closure: " + selectedLocationItem.name)
        }
        locationPicker.pickCompletion = { pickedLocationItem in
            self.showLocation(locationItem: pickedLocationItem)
            self.storeLocation(locationItem: pickedLocationItem)
            locationPicker.dismiss(animated: true, completion: nil)
        }
        locationPicker.deleteCompletion = { locationItem in
            self.historyLocationList.remove(at: self.historyLocationList.firstIndex(of: locationItem)!)
        }
        navigationController!.pushViewController(locationPicker, animated: animated)
        self.showingPicker = true
        if !animated{
            navigationController!.dismiss(animated: animated, completion: nil)
        }
    }
    
    func presentLocationPicker(animated: Bool = true){
        // Present Location Picker subclass via codes.
        // Create LocationPicker subclass.
        let customLocationPicker = CustomLocationPicker()
        customLocationPicker.viewController = self
        let navigationController = UINavigationController(rootViewController: customLocationPicker)
        present(navigationController, animated: animated, completion: nil)
        self.showingPicker = true
    }

    // Location Picker Delegate
    
    func locationDidSelect(locationItem: LocationItem) {
        print("Select delegate method: " + locationItem.name)
    }
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem: locationItem)
        storeLocation(locationItem: locationItem)
    }
    
    
    @IBAction func weiter(_ sender: UIButton) {
        self.userData.addSkillWeiter(location: self.coordinate)
    }
    
    @IBAction func zurück(_ sender: UIButton) {
        self.userData.addSkillZurück()
    }
    
    
    // Location Picker Data Source
    
    func numberOfAlternativeLocations() -> Int {
        return historyLocationList.count
    }
    
    func alternativeLocation(at index: Int) -> LocationItem {
        return historyLocationList.reversed()[index]
    }
    
    func commitAlternativeLocationDeletion(locationItem: LocationItem) {
        historyLocationList.remove(at: historyLocationList.firstIndex(of: locationItem)!)
    }
    
    
    
    func showLocation(locationItem: LocationItem) {
        locationNameLabel.text = locationItem.name
        locationAddressLabel.text = locationItem.formattedAddressString
        coordinate =  CLLocationCoordinate2D(latitude: locationItem.coordinate?.latitude ?? 0, longitude: locationItem.coordinate?.longitude ?? 0)
        locationAddress = locationItem.name + " " + (locationItem.formattedAddressString ?? "")
        if popUp{
            userData.localUser.location = CLLocationCoordinate2D(latitude: locationItem.coordinate?.latitude ?? 0, longitude: locationItem.coordinate?.longitude ?? 0)
        }
    }
    
    func storeLocation(locationItem: LocationItem) {
        if let index = historyLocationList.firstIndex(of: locationItem) {
            historyLocationList.remove(at: index)
        }
        historyLocationList.append(locationItem)
    }

}
