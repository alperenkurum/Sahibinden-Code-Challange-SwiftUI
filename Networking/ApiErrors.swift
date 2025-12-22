//
//  ApiErrors.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 27.11.2025.
//

import Foundation

enum ApiCallError: Error {
    case urlConvertionFailed
    case invalidResponse
    case decodingFailed
    case imageDecodingFailed
}
