//
//  DownloadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class DownloadableSpec: BaseSpec {
    static var startDelegateCalled = false
    static var successDelegateCalled = false
    static var errorDelegateCalled = false

    struct Service: Downloadable {
        typealias Response = HTTPBin

        var path: String? = "get"
        var destination: DownloadRequest.Destination? = { _, _ in (BaseSpec.jsonFileURL, []) }
        var responseSerializer = AnyResponseSerializer<RFResult<Response>>
            .init(dataSerializer: { (request, response, data, error) -> RFResult<Response> in
                Result<Response, RFError>.serialize { try DecodableResponseSerializer()
                    .serialize(
                        request: request,
                        response: response,
                        data: data,
                        error: error
                    )
                }
            })

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
            DownloadableSpec.startDelegateCalled = true
        }

        func request(_ request: DownloadOperation<Service>, didCompleteWithValue value: HTTPBin) {
            DownloadableSpec.successDelegateCalled = true
            expect(value.url.absoluteString).to(equal("https://httpbin.org/get"))
        }

        func request(_ request: DownloadOperation<Service>, didFailWithError error: Error) {
            DownloadableSpec.errorDelegateCalled = true
            fail(error.localizedDescription)
        }
    }

    struct HTTPBin: Decodable {
        let url: URL
    }

    var operation: DownloadOperation<Service>!

    override func spec() {
        describe("Downloadable") {
            it("request should succeed") {
                waitUntil(timeout: self.timeout) { done in
                    // Given
                    let service = Service()
                    var downloadProgressValues: [Double] = []

                    var callbacks: Int = 0 {
                        didSet {
                            if callbacks == 2 {
                                expect(DownloadableSpec.startDelegateCalled).to(beTrue())
                                expect(DownloadableSpec.successDelegateCalled).to(beTrue())
                                expect(DownloadableSpec.errorDelegateCalled).to(beFalse())
                                done()
                            }
                        }
                    }

                    // When
                    do {
                        self.operation = try service.operation(downloadProgressHandler: ({ progress in
                            downloadProgressValues.append(progress.fractionCompleted)
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
                            expect(response.fileURL).toNot(beNil())
                            expect(response.resumeData).to(beNil())
                            expect(response.error).to(beNil())

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
