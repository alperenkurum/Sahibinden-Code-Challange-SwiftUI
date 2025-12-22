//
//  NetworkResponse.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 17.11.2025.
//

import Foundation

struct NetworkResponse<T: Decodable>: Decodable {
    let model: T
    let nextURL: URL?
}
