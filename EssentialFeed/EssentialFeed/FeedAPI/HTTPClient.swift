import Foundation

public enum HTTPClienResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPCLient {
    func get(from url: URL, completion: @escaping (HTTPClienResult) -> Void)
}
