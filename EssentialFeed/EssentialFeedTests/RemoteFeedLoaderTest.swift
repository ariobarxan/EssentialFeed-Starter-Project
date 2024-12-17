import XCTest
import EssentialFeed

final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestURL)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load()

        XCTAssertEqual(client.requestURL, url )
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load()
        sut.load()

        XCTAssertEqual(client.requestURLs, [url, url])
    }

    // MARK: - Helpers
    private func makeSUT(withURL url: URL = URL(string: "https://www.facebook.com")!) -> (sut:RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPCLient {
        var requestURL: URL?
        var requestURLs = [URL]()

        func get(from url: URL) {
            requestURL = url
            requestURLs.append(url)
        }
    } 
}
