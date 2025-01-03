import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPCLient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable  {
        case success([FeedItem])
        case failure(Error)
    }
    public init(url: URL, client: HTTPCLient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (RemoteFeedLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
