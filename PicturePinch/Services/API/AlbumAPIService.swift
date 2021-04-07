//
//  AlbumAPIService.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//

import Foundation
import SwiftyJSON

class AlbumAPIService: APIService {
    static let shared:AlbumAPIService = AlbumAPIService()
    
    func getAlbums(page:Int, limit:Int, completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.get(path: "albums?_page=\(page)&limit=\(limit)") { (result) in
            switch result {
            case .success(let json):
                completion(.success(json))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func getPictures(albumId:Int, page:Int, limit:Int, completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.get(path: "photos?albumId=\(albumId)&_page=\(page)&limit=\(limit)") { (result) in
            switch result {
            case .success(let json):
                completion(.success(json))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }

}
