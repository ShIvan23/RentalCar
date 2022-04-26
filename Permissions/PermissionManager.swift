//
//  PermissionManager.swift
//  RentalCar
//
//  Created by Ivan on 26.04.2022.
//

import UIKit
import CoreLocation
import AVFoundation
import Photos

final class PermissionManager {
    
    func requestGeolocationPermission(success: @escaping () -> Void, failure: @escaping () -> Void) {
        let status = PermissionStatus.geolocationStatus
        guard status != .authorized else {
            DispatchQueue.main.async {
                success()
            }
            return
        }
        
        if status == .notDetermined {
            
        }
    }
    
    func requestPhotoLibrary(success: @escaping () -> Void, failure: @escaping () -> Void) {
        let status = PermissionStatus.photoLibraryStatus
        guard status != .authorized else {
            DispatchQueue.main.async {
                success()
            }
            return
        }
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        success()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                failure()
            }
        }
    }
    
    func requestCamera(success: @escaping () -> Void, failure: @escaping () -> Void) {
        let status = PermissionStatus.videoStatus
        guard status != .authorized else {
            DispatchQueue.main.async {
                success()
            }
            return
        }
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        success()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                failure()
            }
        }
    }
}
