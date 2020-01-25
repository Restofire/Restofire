//
//  Result+Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/20.
//  Copyright © 2020 Restofire. All rights reserved.
//

import Foundation
import Alamofire

extension Result {
    public static func serialize<Success>(catching body: () throws -> Success) -> RFResult<Success> {
        return Result<Success, Error>(catching: body)
            .mapError { error in
                error as? RFError ??
                    RFError.responseSerializationFailed(reason: .customSerializationFailed(error: error))
            }
    }
}
