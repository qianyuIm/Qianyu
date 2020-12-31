//
//  CGFloatExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
import AutoInch
extension CGFloat: QianyuCompatible {}

// MAEK: - Properties
extension QianyuWrapper where Base == CGFloat {
    /// 向上取值
    var flat: CGFloat {
        return flatSpecific(0)
    }
    /// 适配并向上取值
    var autoFlat: CGFloat {
        return base.auto()
    }
    /// 向下取值
    var floor: CGFloat {
        return floorSpecific(0)
    }
    /// 向下取值并适配
    var floorAuto: CGFloat {
        let floor = floorSpecific(0)
        return floor.auto()
    }
}
// MAEK: - Methods
extension QianyuWrapper where Base == CGFloat {
    ///  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
     /// issue: https://github.com/QMUI/QMUI_iOS/issues/203
    func removeFloatMin() -> CGFloat {
        return base == CGFloat.leastNormalMagnitude ? 0 : base
    }
    /// 用于居中运算
    func center(_ child: CGFloat) -> CGFloat {
        return ((base - child) / 2.0).ext.flat
    }
    /// 像素向上取整 eg: 2x: 2.1 -> 2.5 3x:  2.1 ->  2.333
    /// - Parameter scale:
    /// - Returns:
    func flatSpecific(_ scale: CGFloat) -> CGFloat {
        let sca = scale == 0 ? UIScreen.main.scale : scale
        return ceil(self.base * sca) / sca
    }
    
    /// 像素向下取整 eg: 2x: 2.4 -> 2.0 3x:  2.4 ->  2.333
    /// - Parameter scale:
    /// - Returns:
    func floorSpecific(_ scale: CGFloat) -> CGFloat {
        let sca = scale == 0 ? UIScreen.main.scale : scale
        return Darwin.floor(self.base * sca) / sca
    }
}
