//
//  HLJMapHandyJSON.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
import Moya
import HandyJSON
import SwiftyJSON
import RxSwift
extension Response {
    func mapHljObject<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) throws -> D {
        let json = try JSON(data: data)
        // 判断retCode
        let statusString = json["status"].rawString()
        let status = HLJStatusItem.deserialize(from: statusString)
        if status?.retCode != 0 {
            throw QYHandyJSONMapError.dataError(errorStatus: status)
        }
        let jsonString = json.rawString()
        if let obj = D.deserialize(from: jsonString, designatedPath: keyPath) {
            return obj
        }
        throw QYHandyJSONMapError.mapError(errorDescribe: kMapException)
    }
    func mapHljArray<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) throws -> [D] {
        let json = try JSON(data: self.data)
        // 判断retCode
        let statusString = json["status"].rawString()
        let status = HLJStatusItem.deserialize(from: statusString)
        if status?.retCode != 0 {
            throw QYHandyJSONMapError.dataError(errorStatus: status)
        }
        let jsonString = json.rawString()
        if let objs = [D].deserialize(from: jsonString, designatedPath: keyPath) as? [D] {
            return objs
        }
        throw QYHandyJSONMapError.mapError(errorDescribe: kMapException)
    }
}
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapHljObject<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) -> Single<D> {
        return flatMap { response -> Single<D> in
            return Single.just(try response.mapHljObject(type, atKeyPath: keyPath))
        }
    }
    
    func mapHljArray<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) -> Single<[D]> {
        
        return flatMap { response -> Single<[D]> in
            return Single.just(try response.mapHljArray(type, atKeyPath: keyPath))
        }
    }
}

extension ObservableType where Element == Response {
    
   func mapHljObject<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return Observable.just(try response.mapHljObject(type, atKeyPath: keyPath))
        }
    }
    func mapHljArray<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) -> Observable<[D]> {
        return flatMap { response -> Observable<[D]> in
            return Observable.just(try response.mapHljArray(type, atKeyPath: keyPath))
        }
    }
}
