import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    let client: HTTPCLient
    let url: URL
    init(url: URL, client: HTTPCLient) {
        self.client = client
        self.url = url
    }

    func load() {
        client.get(from: url)
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
        let url = URL(string: "https://www.facebook.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)

        XCTAssertNil(client.requestURL)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://www.facebook.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        sut.load()

        XCTAssertEqual(client.requestURL, url )
    }
}
