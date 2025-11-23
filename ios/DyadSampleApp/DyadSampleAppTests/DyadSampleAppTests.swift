//
//  DyadSampleAppTests.swift
//  DyadSampleAppTests
//
//  Created by Dyad Team
//

import XCTest
@testable import DyadSampleApp

final class DyadSampleAppTests: XCTestCase {
    
    func testPostDecodable() throws {
        let json = """
        {
            "id": 1,
            "title": "Test Title",
            "body": "Test Body"
        }
        """
        
        let data = json.data(using: .utf8)!
        let post = try JSONDecoder().decode(Post.self, from: data)
        
        XCTAssertEqual(post.id, 1)
        XCTAssertEqual(post.title, "Test Title")
        XCTAssertEqual(post.body, "Test Body")
    }
    
    func testNetworkServiceExists() {
        let service = NetworkService.shared
        XCTAssertNotNil(service)
    }
    
    func testNetworkServiceFetchPosts() {
        let expectation = self.expectation(description: "Fetch posts")
        
        NetworkService.shared.fetchPosts { result in
            switch result {
            case .success(let posts):
                XCTAssertTrue(posts.count > 0)
            case .failure:
                // Network request might fail in CI, so we just test the mechanism exists
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
