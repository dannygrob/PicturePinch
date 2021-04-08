//
//  AlbumWorker.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.
//

import UIKit

class AlbumWorker
{
    func fetchCachedPictures(albumId:Int, page:Int, size:Int, completion: @escaping (Result<[Pictures.List.ViewModel], APIError>) -> Void) {
        var result:[Pictures.List.ViewModel] = []
        let cache = RealmService.defaultRealm.objects(Picture.self).filter("albumId = %@ && id > %@ && id <= %@",albumId, (page - 1) * size, page * size)
        for picture in cache {
            let vm = Pictures.List.ViewModel(id:picture.id, title: picture.title ?? "no_title".translate(), thumbnailURL: picture.thumbnailUrl ?? "", url: picture.url ?? "")
            result.append(vm)
        }
        completion(.success(result))
    }
    
    func fetchPictures(albumId:Int, page:Int, size:Int, completion: @escaping (Result<[Pictures.List.ViewModel], APIError>) -> Void) {
        AlbumAPIService.shared.getPictures(albumId:albumId, page: page, limit: size) { (result) in
            switch result {
            case .success(let json):
                var result:[Pictures.List.ViewModel] = []
                var resultPictures:[Picture] = []
                for picJson in json.arrayValue {
                    if let picture = Picture.fromJSON(picJson) {
                        let vm = Pictures.List.ViewModel(id:picture.id, title: picture.title ?? "no_title".translate(), thumbnailURL: picture.thumbnailUrl ?? "", url:picture.url ?? "")
                        result.append(vm)
                        resultPictures.append(picture)
                    }
                }
                
                RealmService.write {
                    RealmService.defaultRealm.add(resultPictures, update: .modified)
                }
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}
