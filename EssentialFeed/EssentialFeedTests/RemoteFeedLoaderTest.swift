import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {

    func load() {
        HTTPCLient.shared.requestURL = URL(string: "https://www.google.com")
    }
}

class HTTPCLient {
    static let shared = HTTPCLient()
    private init() {}
    var requestURL: URL?
}
final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        _ = RemoteFeedLoader()

        let client = HTTPCLient.shared

        XCTAssertNil(client.requestURL)
    }

    func test_load_requestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPCLient.shared

        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}
