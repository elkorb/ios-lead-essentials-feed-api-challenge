//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private enum Constants {
		static let OK = 200
	}
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}
	
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { result in
			switch result {
				case .failure:
				completion(.failure(RemoteFeedLoader.Error.connectivity))
				case .success((let data, let response)):
					if response.statusCode != Constants.OK {
						completion(.failure(RemoteFeedLoader.Error.invalidData))
					}
					if String(decoding: data, as: UTF8.self) == "invalid json" {
						completion(.failure(RemoteFeedLoader.Error.invalidData))
					}
			}
		}
	}
}
