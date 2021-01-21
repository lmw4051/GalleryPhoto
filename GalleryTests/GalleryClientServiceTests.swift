//
//  GalleryTests.swift
//  GalleryTests
//
//  Created by David on 2021/1/22.
//  Copyright © 2021 David. All rights reserved.
//

import XCTest
@testable import Gallery

class GalleryClientServiceTests: XCTestCase {
  var sut: GalleryClient?
  
  override func setUp() {
    super.setUp()
    sut = GalleryClient()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func test_fetch_photoItems() {
    let sut = self.sut!
    
    let expect = XCTestExpectation(description: "callback")
    
    sut.loadPhotos(query: "", perPage: 10, pageNumber: 1, completion: { items in
      expect.fulfill()
      XCTAssertEqual(items?.count, 10)
      
      guard let items = items, items.count > 0 else {
        return
      }
      
      for item in items {
        XCTAssertNotNil(item.urls)
      }
      self.wait(for: [expect], timeout: 3)
    }) { error in
      XCTAssertNotNil(error)
    }
  }
}
