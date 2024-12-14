import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {

}

class HTTPCLient {
    var requestURL: URL?
}
final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        _ = RemoteFeedLoader()

        let client = HTTPCLient()

        XCTAssertNil(client.requestURL)
    }
}
