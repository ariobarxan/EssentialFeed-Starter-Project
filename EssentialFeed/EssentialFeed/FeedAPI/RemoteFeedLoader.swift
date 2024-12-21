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
            case .success(let data, let response):
                do {
                   let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private class FeedItemsMapper { 
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return try JSONDecoder().decode(Root.self, from: data) .items.map {$0.item}
    }
}

