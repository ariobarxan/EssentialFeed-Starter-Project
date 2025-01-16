import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession

    init(session: HTTPSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClienResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTasksWithURL() {
        let url = URL(string: "https://example.com")!
        let session = HTTPSessionSpy()
        let task = HTTPSessionTaskkSpy()
        session.stub(url: url, task: task)

        let sut = URLSessionHTTPClient(session: session)

        sut.get(from: url) {_ in }

        XCTAssertEqual(task .resumeCallCount , 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://example.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = HTTPSessionSpy()
        session.stub(url: url, error: error)

        let sut = URLSessionHTTPClient(session: session)

        let expectation = expectation(description: "wait for completion")

        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error) got \(result) instead")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }


    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()

        private struct Stub {
            let taak: HTTPSessionTask
            let error: Error?
        }

        func stub(url: URL, task: HTTPSessionTask = FakeHTTPSessionTask(), error: Error? = nil)  {
            stubs[url] = Stub(taak: task, error: error)

        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.taak
        }
    }

    private class FakeHTTPSessionTask: HTTPSessionTask {
        func resume() {}
    }
    private class HTTPSessionTaskkSpy: HTTPSessionTask {
        var resumeCallCount = 0

        func resume() {
            resumeCallCount += 1
        }
    }
}
