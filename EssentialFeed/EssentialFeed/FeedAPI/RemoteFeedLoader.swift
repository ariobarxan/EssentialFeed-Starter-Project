import Foundation

public enum HTTPClienResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
public protocol HTTPCLient {
    func get(from url: URL, completion: @escaping (HTTPClienResult) -> Void)
}

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
            case .success(let data, _):
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    completion(.success([]))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
