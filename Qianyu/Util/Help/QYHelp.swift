//
//  QYHelp.swift
//  Qianyu
//
//  Created by cyd on 2021/1/7.
//

import Foundation
class QYHelp {
    /// 获取本地json数据
    /// - Parameter json: json 文件名
    /// - Returns:
    class func jsonLocalData(with json: String) -> Data {
        let jsonPath = Bundle.main.path(forResource: json, ofType: "json")
        let jsonUrl = URL(fileURLWithPath: jsonPath!)
        let data = try? Data(contentsOf: jsonUrl)
        return data ?? "".data(using: String.Encoding.utf8)!
    }
}
