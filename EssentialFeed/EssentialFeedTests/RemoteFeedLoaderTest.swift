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


final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestURL)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load()

        XCTAssertEqual(client.requestURL, url )
    }

    // MARK: - Helpers
    private func makeSUT(withURL url: URL = URL(string: "https://www.facebook.com")!) -> (sut:RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPCLient {
        var requestURL: URL?

        func get(from url: URL) {
            requestURL = url
        }
    }
}
