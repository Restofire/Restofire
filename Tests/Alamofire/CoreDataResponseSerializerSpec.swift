//
//  CoreDataResponseSerializerSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreDataStack
@testable import Restofire

@available(iOS 10.0, OSX 10.12, tvOS 10.0, *)
class CoreDataResponseSerializerSpec: BaseSpec {
    
    lazy var model: NSManagedObjectModel = {
        return Bundle(for: type(of: self)).managedObjectModel(name: "Restofire")
    }()
    
    lazy var container: NSPersistentContainer = {
        return NSPersistentContainer(name: "Restofire", managedObjectModel: self.model)
    }()
    
    override func spec() {
        
        describe("CoreData") {
            
            beforeEach {
                waitUntil(timeout: self.timeout) { done in
                    let configuration = NSPersistentStoreDescription()
                    configuration.type = NSInMemoryStoreType
                    self.container.persistentStoreDescriptions = [configuration]
                    self.container.loadPersistentStores() { _, error in
                        if let error = error as NSError? {
                            fail("Unresolved error \(error), \(error.userInfo)")
                        }
                        done()
                    }
                }
            }
            
            it("request should import response to coredata") {
                // Given
                struct Request: ARequestable {
                    var scheme: String = "https://"
                    var baseURL: String = "www.mocky.io"
                    var version: String? = "v2"
                    var path: String? = "5a6e1f7f2e0000f220b8db59"
                }
                
                let request = Request().request()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        defer { done() }
                        
                        if let values = response.value as? [String: Any] {
                            let object = Book(context: self.container.viewContext)
                            object.title = values["title"] as! String
                            if let publisherValue = values["publisher"] as? [String: Any] {
                                let publisher = Publisher(context: self.container.viewContext)
                                publisher.name = publisherValue["name"] as! String
                                object.publisher = publisher
                            }
                            if let authorsValue = values["authors"] as? [[String: Any]] {
                                authorsValue.forEach({ authorValue in
                                    let author = Author(context: self.container.viewContext)
                                    author.firstName = authorValue["firstName"] as! String
                                    author.lastName = authorValue["lastName"] as! String
                                    object.addToAuthors(author)
                                })
                            }
                            expect(object.title).to(equal("The Holy Bible"))
                        }
                        
                        //Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                    })
                }
            }
            
        }
    }
    
}

