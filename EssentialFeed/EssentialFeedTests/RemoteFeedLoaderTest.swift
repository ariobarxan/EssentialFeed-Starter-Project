import XCTest
import EssentialFeed

final class RemoteFeedLoaderTest: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load{_ in}

        XCTAssertEqual(client.requestURLs, [url])
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load{_ in}
        sut.load{_ in}

        XCTAssertEqual(client.requestURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        let clientError = NSError(domain: "Test", code: 0)
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0)}
        client.complete(with: clientError)

        XCTAssertEqual(capturedErrors , [.connectivity])
    }

    // MARK: - Helpers
    private func makeSUT(withURL url: URL = URL(string: "https://www.facebook.com")!) -> (sut:RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPCLient {
        private var messages = [(url: URL, completion: (Error) -> Void)] ()
        var requestURLs: [URL] {
            messages.map(\.url)
        }

        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }


        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }
}
