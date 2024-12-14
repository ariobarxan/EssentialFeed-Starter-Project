import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    let client: HTTPCLient

    init(client: HTTPCLient) {
        self.client = client
    }
    func load() {
        client.get(from: URL(string: "https://www.google.com")!)
    }
}

protocol HTTPCLient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPCLient {
    var requestURL: URL?
    
    func get(from url: URL) {
        requestURL = url
    }
}
final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {


        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        XCTAssertNil(client.requestURL)
    }

    func test_load_requestDataFromURL() {

        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}
