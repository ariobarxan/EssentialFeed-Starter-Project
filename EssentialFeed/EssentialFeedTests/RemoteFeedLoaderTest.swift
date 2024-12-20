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
        sut.load()

        XCTAssertEqual(client.requestURLs, [url])
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://www.facebook.com")!
        let (sut, client) = makeSUT(withURL: url)
        sut.load()
        sut.load()

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
        var requestURLs = [URL]()
        var completions = [(Error) -> Void]()

        func get(from url: URL, completion: @escaping (Error) -> Void) {

             completions.append(completion)
             requestURLs.append(url)
        }


        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
}
