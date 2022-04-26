//
//  PermissionStatus.swift
//  RentalCar
//
//  Created by Ivan on 25.04.2022.
//

import Foundation
import CoreLocation
import AVFoundation
import Photos

enum PermissionState {
    case authorized
    case notDetermined
    case denied
}

final class PermissionStatus {
    static var geolocationStatus: PermissionState {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        default:
            return .denied
        }
    }
    
    static var videoStatus: PermissionState {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        default:
            return .denied
        }
    }
    
    static var photoLibraryStatus: PermissionState {
        let state = PHPhotoLibrary.authorizationStatus()
        
        switch state {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        default:
            return .denied
        }
    }
}
