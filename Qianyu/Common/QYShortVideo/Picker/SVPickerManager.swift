//
//  SVPickerManager.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import UIKit
import Photos

class SVPickerManager {
    /// 获取当前相册权限类型
    /// - Returns:
    class func authorizationStatus() -> PHAuthorizationStatus {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return status
    }
    ///   请求获取相册权限
    /// - Parameter handler:
    /// - Returns:
    class func requestAuthorization(with handler: @escaping (PHAuthorizationStatus) -> Void) {
        let status = authorizationStatus()
        if status == PHAuthorizationStatus.notDetermined {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { (authorizationStatus) in
                    DispatchQueue.main.async {
                        handler(authorizationStatus)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                    DispatchQueue.main.async {
                        handler(authorizationStatus)
                    }
                }
            }
        } else {
            handler(status)
        }
    }
}
