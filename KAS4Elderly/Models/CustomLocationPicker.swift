//
//  CustomLocationPicker.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import LocationPickerViewController
import MapKit

class CustomLocationPicker: LocationPicker{
    
    var viewController: CustomLocationPickerViewController!

    override func viewDidLoad() {
        alternativeLocationIconColor = UIColor.orange
        currentLocationText = "Ihr Standort"
        locationDeniedCancelText = "Abrechen"
        locationDeniedGrantText = "Erlauben"
        locationDeniedAlertTitle = "Standortdaten verweigert"
        locationDeniedAlertMessage = "Erlaube Zugriffauf Standortdaten um den aktuellen Satndort zu nutzen"
        searchBarPlaceholder = "Suche nach Ort"
        super.tableViewBackgroundColor = UIColor.systemBackground
        super.addBarButtons()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewController.showingPicker = false
        if viewController.popUp{
            viewController.userData.updateUser()
        }
    }
    
    @objc override func locationDidSelect(locationItem: LocationItem) {
        print("Select overrided method: " + locationItem.name)
        viewController.coordinate = CLLocationCoordinate2D(latitude: locationItem.coordinate?.latitude ?? 0, longitude: locationItem.coordinate?.longitude ?? 0)
    }
    
    @objc override func locationDidPick(locationItem: LocationItem) {
        viewController.showLocation(locationItem: locationItem)
        viewController.storeLocation(locationItem: locationItem)
        viewController.showingPicker = false
    }
    

}
