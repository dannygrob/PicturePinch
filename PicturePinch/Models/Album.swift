//
//  Album.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Album:Object {
    @objc dynamic var id:Int = -1
    @objc dynamic var userId:Int = -1
    @objc dynamic var title:String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func fromJSON(_ json: JSON) -> Album? {
        if json == JSON.null {
            return nil
        }
        let album = Album()
        if let id = json["id"].int {
            album.id = id
        }
        if let userId = json["userId"].int {
            album.userId = userId
        }
        if let title = json["title"].string {
            album.title = title
        }
        return album
    }
}
