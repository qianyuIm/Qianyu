//
//  QYAlert.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import UIKit
import SwiftEntryKit

class QYAlert {
    
    /// 通用弹窗
    /// - Parameters:
    ///   - title: 默认 ""
    ///   - message: 默认 ""
    ///   - cancel: 默认 "取消"
    ///   - done: 默认 "确定"
    ///   - cancelAction:
    ///   - doneAction:
    class func alert(title: String = "",
                     message: String = "",
                     cancel: String = "取消",
                     done: String = "确定",
                     doneAction: (() -> Void)? = nil,
                     cancelAction: (() -> Void)? = nil) {
        // title
        let titleWrapper = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: QYFont.fontMedium(15),
                color: .black,
                alignment: .center,
                displayMode: .dark))
        // message
        let messageWrapper = EKProperty.LabelContent(
            text: message,
            style: .init(
                font: QYFont.fontRegular(13),
                color: .black,
                alignment: .center,
                displayMode: .dark))
        let simpleMessage = EKSimpleMessage(
            title: titleWrapper,
            description: messageWrapper
        )
        let buttonFont = QYFont.fontMedium(16)
        /// 取消按钮
        let cancelSenderColor = EKColor(QYColor.color333)
        let cancelSenderLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: cancelSenderColor,
            displayMode: .dark
        )
        let cancelSenderLabel = EKProperty.LabelContent(
            text: cancel,
            style: cancelSenderLabelStyle
        )
        let cancelSenderWrapper = EKProperty.ButtonContent(
            label: cancelSenderLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: .clear,
            displayMode: .dark) {
            SwiftEntryKit.dismiss()
            cancelAction?()
        }
        // 确认按钮
        let doneSenderColor = EKColor(QYColor.color("F83244"))
        let doneSenderLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: doneSenderColor,
            displayMode: .dark
        )
        let doneSenderLabel = EKProperty.LabelContent(
            text: done,
            style: doneSenderLabelStyle
        )
        let doneSenderWrapper = EKProperty.ButtonContent(
            label: doneSenderLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: .clear,
            displayMode: .dark) {
            SwiftEntryKit.dismiss()
            doneAction?()
        }
        // Generate the content
        let senderContent = EKProperty.ButtonBarContent(
            with: cancelSenderWrapper, doneSenderWrapper,
            separatorColor: .init(QYColor.color("E6E6E6")),
            displayMode: .dark,
            expandAnimatedly: true
        )
        let alertMessage = EKAlertMessage(
            simpleMessage: simpleMessage,
            buttonBarContent: senderContent
        )
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: alertAttributes())
    }
    
    class func dismiss() {
        SwiftEntryKit.dismiss()
    }
}
private extension QYAlert {
    class func alertAttributes() -> EKAttributes {
        var attributes: EKAttributes = .centerFloat
        attributes.displayMode = .dark
        attributes.windowLevel = .alerts
        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.screenBackground = .color(color: .init(UIColor.black.withAlphaComponent(0.5)))
        attributes.entryBackground = .color(color: .white)
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        )
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0.9,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            fade: .init(
                from: 0,
                to: 1,
                duration: 0.3
            )
        )
        attributes.exitAnimation = .init(
            fade: .init(
                from: 1,
                to: 0,
                duration: 0.2
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        return attributes
    }
}
