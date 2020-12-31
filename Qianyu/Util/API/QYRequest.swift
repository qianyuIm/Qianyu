//
//  QYRequest.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit
import Moya
import RxSwift
/// 服务器异常 请求超时
let kServerException = "请求异常!"
let kMapException = "数据解析异常"

enum QYHandyJSONMapError: Swift.Error {
    case mapError(errorDescribe: String)
    case dataError(errorStatus: HLJStatusItem?)
    var errorDescribe: String {
        switch self {
        case .mapError(errorDescribe: let error):
            return error
        case .dataError(errorStatus: let status):
            return status?.msg ?? kServerException
        }
    }
}

extension Error {
    var asHandyJSONMapError: QYHandyJSONMapError? {
        self as? QYHandyJSONMapError
    }
}
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) -> Void in
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 15
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}
let apiProvider = MoyaProvider<MultiTarget>(requestClosure: timeoutClosure)

extension Moya.TargetType {
    func request() -> Single<Moya.Response> {
        return apiProvider.rx.request(.target(self))
    }
}

