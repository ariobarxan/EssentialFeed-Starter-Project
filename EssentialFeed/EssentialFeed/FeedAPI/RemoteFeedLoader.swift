import Foundation

public protocol HTTPCLient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPCLient

    public enum Error: Swift.Error {
        case connectivity
    }
    public init(url: URL, client: HTTPCLient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (RemoteFeedLoader.Error) -> Void) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
