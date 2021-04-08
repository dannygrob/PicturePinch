//
//  AlbumsWorker.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.
//

import UIKit

class AlbumsWorker
{
    func fetchCachedAlbums(page:Int, size:Int, completion: @escaping (Result<[Albums.List.ViewModel], APIError>) -> Void) {
        var result:[Albums.List.ViewModel] = []
        let cache = RealmService.defaultRealm.objects(Album.self).filter("id > %@ && id <= %@",(page - 1) * size, page * size)
        for album in cache {
            let vm = Albums.List.ViewModel(id: album.id, title: album.title ?? "no_title".translate())
            result.append(vm)
        }
        completion(.success(result))
    }
    
    func fetchAlbums(page:Int, size:Int, completion: @escaping (Result<[Albums.List.ViewModel], APIError>) -> Void) {
        AlbumAPIService.shared.getAlbums(page: page, limit: size) { (result) in
            switch result {
            case .success(let json):
                var result:[Albums.List.ViewModel] = []
                var resultAlbums:[Album] = []
                for albumJson in json.arrayValue {
                    if let album = Album.fromJSON(albumJson) {
                        let vm = Albums.List.ViewModel(id:album.id, title: album.title ?? "no_title".translate())
                        result.append(vm)
                        resultAlbums.append(album)
                    }
                }
                
                RealmService.write {
                    RealmService.defaultRealm.add(resultAlbums, update: .modified)
                }
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }

}
