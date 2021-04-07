//
//  Picture.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Picture:Object {
    @objc dynamic var id:Int = -1
    @objc dynamic var albumId:Int = -1
    @objc dynamic var title:String?
    @objc dynamic var url:String?
    @objc dynamic var thumbnailUrl:String?
    @objc dynamic var thumbnailData:Data?
    @objc dynamic var pictureData:Data?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func fromJSON(_ json: JSON) -> Picture? {
        if json == JSON.null {
            return nil
        }
        let picture = Picture()
        if let id = json["id"].int {
            picture.id = id
        }
        if let albumId = json["albumId"].int {
            picture.albumId = albumId
        }
        if let title = json["title"].string {
            picture.title = title
        }
        if let thumb = json["thumbnailUrl"].string {
            picture.thumbnailUrl = thumb
        }
        if let url = json["url"].string {
            picture.url = url
        }
        return picture
    }
}
