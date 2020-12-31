//
//  QYShortVideo.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import UIKit
/// 完成
typealias QYShortVideoCompleteHandler = (() -> Void)
/// 取消
typealias QYShortVideoCancelHandler = (() -> Void)
class QYShortVideo: NSObject {
    lazy var configuration: QYShortVideoConfiguration = {
        return QYShortVideoConfiguration()
    }()
    deinit {
        logDebug("QYShortVideo 释放了")
    }
}
extension QYShortVideo {
    /// 相册入口
    /// - Parameters:
    ///   - visibleController: 当前控制器
    ///   - completionHandler:
    ///   - cancelHandler:
    func openPhotoPicker(in visibleController: UIViewController,
                         withCompletionHandler completionHandler: QYShortVideoCompleteHandler? = nil,
                         didCancel cancelHandler: QYShortVideoCancelHandler? = nil) {
        SVPickerManager.requestAuthorization { (status) in
            if status == .denied || status == .notDetermined || status == .restricted {
                logDebug("请在iPhone的\"设置-隐私-照片\"选项中，允许访问你的照片")
            } else {
                self.showPhotoPicker(in: visibleController, withCompletionHandler: completionHandler, didCancel: cancelHandler)
            }
        }
    }
}

private extension QYShortVideo {
    func showPhotoPicker(in visibleController: UIViewController,
                         withCompletionHandler completionHandler: QYShortVideoCompleteHandler? = nil,
                         didCancel cancelHandler: QYShortVideoCancelHandler? = nil) {
//        SVPickerManager.getCameraRollAlbum(for: configuration.pickerConfiguration.selectType) { [weak self] (collectionItem) in
//            guard let `self` = self else { return }
//            let picker = SVPickerController(albumCollectionItem: collectionItem, configuration: self.configuration)
//            let pickerNa = SVNavigationController(rootViewController: picker)
//            visibleController.present(pickerNa, animated: true, completion: nil)
//        }
    }
}
