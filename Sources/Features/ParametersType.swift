//
//  ParametersType.swift
//  Restofire
//
//  Created by RahulKatariya on 05/02/19.
//  Copyright © 2019 Restofire. All rights reserved.
//

import Foundation

struct EmptyCodable: Codable {}

public enum ParametersType<T: Encodable> {
    case any(Any?)
    case encodable(T)
}
