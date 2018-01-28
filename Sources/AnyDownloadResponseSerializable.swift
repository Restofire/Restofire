//
//  AnyDownloadResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

private class _AnyDownloadResponseSerializerProtocolBase<SerializedObject>: DownloadResponseSerializerProtocol {
    
    // All the properties in the DownloadResponseSerializableProtocol go here.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<SerializedObject> {
        fatalError("Must override")
    }
    
    // Let's make sure that init() cannot be called to initialise this class.
    init() {
        guard type(of: self) != _AnyDownloadResponseSerializerProtocolBase.self else {
            fatalError("Cannot initialise, must subclass")
        }
    }
    
}

private final class _AnyDownloadResponseSerializerProtocolBox<ConcreteDownloadResponseSerializerProtocol: DownloadResponseSerializerProtocol>: _AnyDownloadResponseSerializerProtocolBase<ConcreteDownloadResponseSerializerProtocol.SerializedObject> {
    
    // Store the concrete type
    var concrete: ConcreteDownloadResponseSerializerProtocol
    
    // All the properties in the DownloadResponseSerializableProtocol go here.
    override var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<SerializedObject> {
        return concrete.serializeResponse
    }
    
    // Define init()
    init(_ concrete: ConcreteDownloadResponseSerializerProtocol) {
        self.concrete = concrete
    }
    
}

final class AnyDownloadResponseSerializerProtocol<SerializedObject>: DownloadResponseSerializerProtocol {
    // Store the box specialised by content.
    // This line is the reason why we need an abstract class _AnyDownloadResponseSerializableBase. We cannot store here an instance of _AnyDownloadResponseSerializableBox directly because the concrete type for Cup is provided by the initialiser, at a later stage.
    private let box: _AnyDownloadResponseSerializerProtocolBase<SerializedObject>
    
    // All properties for the protocol DownloadResponseSerializableProtocol call the equivalent Box proerty
    var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<SerializedObject> {
        return box.serializeResponse
    }
    
    // Initialise the class with a concrete type of Cup where the content is restricted to be the same as the genric paramenter
    init<Concrete: DownloadResponseSerializerProtocol>(_ concrete: Concrete) where Concrete.SerializedObject == SerializedObject {
        box = _AnyDownloadResponseSerializerProtocolBox(concrete)
    }
    
}


