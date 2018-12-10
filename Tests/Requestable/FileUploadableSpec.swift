//
//  FileUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class FileUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("FileUploadable") {
            
            it("request should succeed") {
                
                waitUntil(timeout: self.timeout) { done in
                    struct Service: FileUploadable {
                        
                        typealias Response = Any
                        var responseSerializer = AnyResponseSerializer<Result<Response>>
                            .init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                                return Result { try JSONResponseSerializer()
                                    .serialize(request: request,
                                               response: response,
                                               data: data,
                                               error: error)
                                }
                            })
                        
                        var path: String? = "post"
                        let url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "jpg")
                        
                        func prepare<R: _Requestable>(_ request: URLRequest, requestable: R) -> URLRequest {
                            var request = request
                            let header = HTTPHeader.authorization(username: "user", password: "password")
                            request.setValue(header.value, forHTTPHeaderField: header.name)
                            expect(request.value(forHTTPHeaderField: "Authorization"))
                                .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                            return request
                        }
                        
                        func didSend<R: _Requestable>(_ request: Request, requestable: R) {
                            expect(request.request?.value(forHTTPHeaderField: "Authorization")!)
                                .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                            FileUploadableSpec.startDelegateCalled = true
                        }
                        
                        func request(_ request: UploadOperation<Service>, didCompleteWithValue value: Response) {
                            FileUploadableSpec.successDelegateCalled = true
                            expect(value).toNot(beNil())
                        }
                        
                        func request(_ request: UploadOperation<Service>, didFailWithError error: Error) {
                            FileUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let service = Service()
                    var uploadProgressValues: [Double] = []
                    var downloadProgressValues: [Double] = []
                    
                    var callbacks: Int = 0 {
                        didSet {
                            if callbacks == 2 {
                                expect(FileUploadableSpec.startDelegateCalled).to(beTrue())
                                expect(FileUploadableSpec.successDelegateCalled).to(beTrue())
                                expect(FileUploadableSpec.errorDelegateCalled).to(beFalse())
                                done()
                            }
                        }
                    }
                    
                    // When
                    do {
                        let operation = try service.execute { response in
                            
                            defer { callbacks = callbacks + 1 }
                            
                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                            
                            if let value = response.value as? [String: Any],
                                let data = value["data"] as? String {
                                expect(data).toNot(beEmpty())
                            } else {
                                fail("response value should not be nil")
                            }
                            
                            var previousUploadProgress: Double = uploadProgressValues.first ?? 0.0
                            
                            for uploadProgress in uploadProgressValues {
                                expect(uploadProgress).to(beGreaterThanOrEqualTo(previousUploadProgress))
                                previousUploadProgress = uploadProgress
                            }
                            
                            if let lastUploadProgressValue = uploadProgressValues.last {
                                expect(lastUploadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in uploadProgressValues should not be nil")
                            }
                            
                            var previousDownloadProgress: Double = downloadProgressValues.first ?? 0.0
                            
                            for downloadProgress in downloadProgressValues {
                                expect(downloadProgress).to(beGreaterThanOrEqualTo(previousDownloadProgress))
                                previousDownloadProgress = downloadProgress
                            }
                            
                            if let lastDownloadProgressValue = downloadProgressValues.last {
                                expect(lastDownloadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in downloadProgressValues should not be nil")
                            }
                        }
                        
                        operation.completionBlock = { callbacks = callbacks + 1 }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
            
        }
    }
    
}
