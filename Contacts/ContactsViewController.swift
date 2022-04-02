//
//  ContactsViewController.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import YandexMapsMobile
import SnapKit
import UIKit

final class ContactsViewController: UIViewController {
    
    private let mapView = YMKMapView()
    
    private var mapObjects: YMKMapObjectCollection {
        return mapView.mapWindow.map.mapObjects
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupMap()
    }
    
    private func setupMap() {
        let point = YMKPoint(latitude: 55.723828, longitude: 37.688591)
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: point, zoom: 15.5, azimuth: 0, tilt: 0))
        
        let placemark: YMKPlacemarkMapObject = mapObjects.addPlacemark(with: point) //, image: <#T##UIImage#>)
    }
    
    private func layout() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.width.equalTo(ScreenSize.width)
            make.left.right.equalToSuperview()
        }
    }
}
