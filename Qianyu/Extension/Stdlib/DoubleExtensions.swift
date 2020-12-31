//
//  DoubleExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
extension Double: QianyuCompatible {}
// MAEK: - Properties
extension QianyuWrapper where Base == Double {
    /// 向上取值
    var flat: Double {
        return flatSpecific(0)
    }
    /// 适配并向上取值
    var autoFlat: Double {
        return base.auto()
    }
    /// 向下取值
    var floor: Double {
        return floorSpecific(0)
    }
    /// 向下取值并适配
    var floorAuto: Double {
        let floor = floorSpecific(0)
        return floor.auto()
    }
}
// MAEK: - Methods
extension QianyuWrapper where Base == Double {
    /// 像素向上取整 eg: 2x: 2.1 -> 2.5 3x:  2.1 ->  2.333
    /// - Parameter scale:
    /// - Returns:
    func flatSpecific(_ scale: CGFloat) -> Double {
        let sca = scale == 0 ? Double(UIScreen.main.scale) : Double(scale)
        return ceil(self.base * sca) / sca
    }
    
    /// 像素向下取整 eg: 2x: 2.1 -> 2.5 3x:  2.1 ->  2.333
    /// - Parameter scale:
    /// - Returns:
    func floorSpecific(_ scale: CGFloat) -> Double {
        let sca = scale == 0 ? Double(UIScreen.main.scale) : Double(scale)
        return Darwin.floor(self.base * sca) / sca
    }
}
