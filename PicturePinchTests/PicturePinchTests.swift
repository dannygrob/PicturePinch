//
//  PicturePinchTests.swift
//  PicturePinchTests
//
//  Created by Danny Grob on 07/04/2021.
//

import XCTest
import SwiftyJSON

class PicturePinchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_parse_albums() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "albums", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let jsonData = try? Data(contentsOf: url), let json = try? JSON(data: jsonData) {
                XCTAssert(json.arrayValue.count == 10)
                for jsonAlbum in json.arrayValue {
                    let album = Album.fromJSON(jsonAlbum)
                    XCTAssert(album?.id != nil && album?.userId != nil && album?.title != nil)
                }
            }
            
        }
    }

    func test_parse_pictures() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "album", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let jsonData = try? Data(contentsOf: url), let json = try? JSON(data: jsonData) {
                XCTAssert(json.arrayValue.count == 10)
                for jsonPicture in json.arrayValue {
                    let picture = Picture.fromJSON(jsonPicture)
                    XCTAssert(picture?.url != nil && picture?.title != nil && picture?.id != nil)
                }
            }
            
        }
    }

}
