//
//  AnyDataResponseSerializerProtocol.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

private class _AnyDataResponseSerializerProtocolBase<SerializedObject>: DataResponseSerializerProtocol {
    
    // All the properties in the DataResponseSerializerProtocol go here.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<SerializedObject> {
        fatalError("Must override")
    }
    
    // Let's make sure that init() cannot be called to initialise this class.
    init() {
        guard type(of: self) != _AnyDataResponseSerializerProtocolBase.self else {
            fatalError("Cannot initialise, must subclass")
        }
    }
    
}

private final class _AnyDataResponseSerializerProtocolBox<ConcreteDataResponseSerializerProtocol: DataResponseSerializerProtocol>: _AnyDataResponseSerializerProtocolBase<ConcreteDataResponseSerializerProtocol.SerializedObject> {
    
    // Store the concrete type
    var concrete: ConcreteDataResponseSerializerProtocol
    
    // All the properties in the DataResponseSerializerProtocol go here.
    override var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<SerializedObject> {
        return concrete.serializeResponse
    }
    
    // Define init()
    init(_ concrete: ConcreteDataResponseSerializerProtocol) {
        self.concrete = concrete
    }
    
}

final class AnyDataResponseSerializerProtocol<SerializedObject>: DataResponseSerializerProtocol {
    // Store the box specialised by content.
    // This line is the reason why we need an abstract class _AnyDataResponseSerializerProtocolBase. We cannot store here an instance of _AnyDataResponseSerializerProtocolBox directly because the concrete type for Cup is provided by the initialiser, at a later stage.
    private let box: _AnyDataResponseSerializerProtocolBase<SerializedObject>
    
    // All properties for the protocol DataResponseSerializerProtocol call the equivalent Box proerty
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<SerializedObject> {
        return box.serializeResponse
    }
    
    // Initialise the class with a concrete type of Cup where the content is restricted to be the same as the genric paramenter
    init<Concrete: DataResponseSerializerProtocol>(_ concrete: Concrete) where Concrete.SerializedObject == SerializedObject {
        box = _AnyDataResponseSerializerProtocolBox(concrete)
    }
    
}

