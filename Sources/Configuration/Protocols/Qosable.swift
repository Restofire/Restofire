//
//  QualityOfService.swift
//  Restofire
//
//  Created by RahulKatariya on 21/08/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents an `Qosable` that is associated with `Requestable`.
public protocol Qosable {
    /// The operation quality of service.
    var qos: QualityOfService { get }
}

extension Qosable where Self: Configurable {
    /// `configuration.operationQualityOfService`
    public var qos: QualityOfService {
        return configuration.operationQualityOfService
    }
}

/// Represents an `UserInteractiveQosable` that is associated with `Requestable`.
public protocol UserInteractiveQosable: Qosable {}

extension UserInteractiveQosable {
    /// `QualityOfService.userInteractive`
    public var qos: QualityOfService {
        return .userInteractive
    }
}

/// Represents an `UserInitiatedQosable` that is associated with `Requestable`.
public protocol UserInitiatedQosable: Qosable {}

extension UserInitiatedQosable {
    /// `QualityOfService.userInitiated`
    public var qos: QualityOfService {
        return .userInitiated
    }
}

/// Represents an `DefaultQosable` that is associated with `Requestable`.
public protocol DefaultQosable: Qosable {}

extension DefaultQosable {
    /// `QualityOfService.default`
    public var qos: QualityOfService {
        return .default
    }
}

/// Represents an `UtilityQosable` that is associated with `Requestable`.
public protocol UtilityQosable: Qosable {}

extension UtilityQosable {
    /// `QualityOfService.utility`
    public var qos: QualityOfService {
        return .utility
    }
}

/// Represents an `BackgroundQosable` that is associated with `Requestable`.
public protocol BackgroundQosable: Qosable {}

extension BackgroundQosable {
    /// `QualityOfService.background`
    public var qos: QualityOfService {
        return .background
    }
}
