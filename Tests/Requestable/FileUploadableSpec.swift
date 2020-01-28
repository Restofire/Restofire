//
//  FileUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
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

    struct Service: FileUploadable {
        typealias Response = Any
        var responseSerializer = AnyResponseSerializer<RFResult<Response>>
            .init(dataSerializer: { (request, response, data, error) -> RFResult<Response> in
                Result<Response, RFError>.serialize { try JSONResponseSerializer()
                    .serialize(
                        request: request,
                        response: response,
                        data: data,
                        error: error
                    )
                }
            })

        var path: String? = "post"
        let url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "png")

        func prepare<R: BaseRequestable>(_ request: URLRequest, requestable: R) -> URLRequest {
            var request = request
            let header = HTTPHeader.authorization(username: "user", password: "password")
            request.setValue(header.value, forHTTPHeaderField: header.name)
            expect(request.value(forHTTPHeaderField: "Authorization"))
                .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
            return request
        }

        func willSend<R: BaseRequestable>(_ request: Request, requestable: R) {
            let value = request.request?.value(forHTTPHeaderField: "Authorization")!
            expect(value).to(equal("Basic dXNlcjpwYXNzd29yZA=="))
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

    var operation: UploadOperation<Service>!

    override func spec() {
        describe("FileUploadable") {
            it("request should succeed") {
                waitUntil(timeout: self.timeout) { done in
                    // Given
                    let service = Service()
                    var uploadProgressValues: [Double] = []

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
                        self.operation = try service.operation(uploadProgressHandler: ({ progress in
                            uploadProgressValues.append(progress.fractionCompleted)
                        }, nil)) { response in

                            defer { callbacks = callbacks + 1 }

                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }

                            expect(response.value).toNot(beNil())
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
                        }

                        self.operation.start()
                        self.operation.completionBlock = { callbacks = callbacks + 1 }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
        }
    }
}
