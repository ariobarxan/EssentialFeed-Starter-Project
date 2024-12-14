import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {

    func load() {
        HTTPCLient.shared.get(from: URL(string: "https://www.google.com")!)
    }
}

class HTTPCLient {
    static var shared = HTTPCLient()

    func get(from url: URL) {}

}

class HTTPClientSpy: HTTPCLient {
    var requestURL: URL?
    
    override func get(from url: URL) {
        requestURL = url
    }
}
final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        _ = RemoteFeedLoader()

        let client = HTTPClientSpy()
        HTTPCLient.shared = client

        XCTAssertNil(client.requestURL)
    }

    func test_load_requestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClientSpy()
        HTTPCLient.shared = client

        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}
