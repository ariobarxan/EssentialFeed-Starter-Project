import Foundation

public protocol HTTPCLient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPCLient

    public init(url: URL, client: HTTPCLient) {
        self.client = client
        self.url = url
    }

    public func load() {
        client.get(from: url)
    }
}
