//
//  ZFPlayer+Rx.swift
//  Qianyu
//
//  Created by cyd on 2021/1/6.
//

import Foundation
import ZFPlayer
import RxSwift
import RxCocoa
extension Reactive where Base: ZFPlayerController {
    var isStopCurrentPlayingCell: Binder<Bool> {
        Binder(self.base) { (player, stop) in
            if !stop {
                player.stopCurrentPlayingCell()
            }
        }
    }
}
