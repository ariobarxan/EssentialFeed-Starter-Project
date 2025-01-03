import Foundation

internal final class FeedItemsMapper {
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

    private static var OK_2oo: Int {return 200}

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_2oo else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return try JSONDecoder().decode(Root.self, from: data) .items.map {$0.item}
    }
}
