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
    func fetchCachedPictures(page:Int, size:Int, completion: @escaping (Result<[Albums.Contents.ViewModel], APIError>) -> Void) {
        var result:[Albums.Contents.ViewModel] = []
        let cache = RealmService.defaultRealm.objects(Picture.self).filter("id <= %@",size)
        for picture in cache {
            let vm = Albums.Contents.ViewModel(title: picture.title ?? "no_title".translate(), thumbnailURL: picture.thumbnailUrl ?? "", url: picture.url ?? "")
            result.append(vm)
        }
        completion(.success(result))
    }
    
    func fetchPictures(albumId:Int, page:Int, size:Int, completion: @escaping (Result<[Albums.Contents.ViewModel], APIError>) -> Void) {
        AlbumAPIService.shared.getPictures(albumId:albumId, page: page, limit: size) { (result) in
            switch result {
            case .success(let json):
                var result:[Albums.Contents.ViewModel] = []
                for picJson in json.arrayValue {
                    if let picture = Picture.fromJSON(picJson) {
                        let vm = Albums.Contents.ViewModel(title: picture.title ?? "no_title".translate(), thumbnailURL: picture.thumbnailUrl ?? "", url:picture.url ?? "")
                        result.append(vm)
                    }
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}
