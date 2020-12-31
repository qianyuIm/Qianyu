//
//  QYLogger.swift
//  QianyuIm
//
//  Created by cyd on 2020/6/30.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import Foundation
import SwiftyBeaver

let QYLogger = SwiftyBeaver.self
func logDebug(_ message: Any, _ file: String = #file,
              _ function: String = #function, line: Int = #line,
              context: Any? = nil) {
    QYLogger.debug(message, file, function, line: line, context: context)
}

func logError(_ message: Any, _ file: String = #file,
              _ function: String = #function, line: Int = #line,
              context: Any? = nil) {
    QYLogger.error(message, file, function, line: line, context: context)
}

func logInfo(_ message: Any, _ file: String = #file,
             _ function: String = #function, line: Int = #line,
             context: Any? = nil) {
    QYLogger.info(message, file, function, line: line, context: context)
}

func logVerbose(_ message: Any, _ file: String = #file,
                _ function: String = #function, line: Int = #line, context: Any? = nil) {
    QYLogger.verbose(message, file, function, line: line, context: context)
}

func logWarning(_ message: Any, _ file: String = #file,
                _ function: String = #function, line: Int = #line, context: Any? = nil) {
    QYLogger.warning(message, file, function, line: line, context: context)
}
