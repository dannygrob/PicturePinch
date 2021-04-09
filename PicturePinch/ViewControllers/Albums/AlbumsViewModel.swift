//
//  AlbumsViewModel.swift
//  PicturePinch
//
//  Created by Danny Grob on 09/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumsViewModel {
    
    let items = PublishSubject<[Albums.List.ViewModel]>()
    
    func fetchCachedAlbums(page:Int, size:Int) {
        var result:[Albums.List.ViewModel] = []
        let cache = RealmService.defaultRealm.objects(Album.self).filter("id > %@ && id <= %@",(page - 1) * size, page * size)
        for album in cache {
            let vm = Albums.List.ViewModel(id: album.id, title: album.title ?? "no_title".translate())
            result.append(vm)
        }
        self.items.onNext(result)
        self.items.onCompleted()
    }
    
    func fetchAlbumList(page:Int, size:Int) {
        fetchCachedAlbums(page: page, size: size)
        
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
                
                self.items.onNext(result)
                self.items.onCompleted()
                
            case .failure(_):
                //TODO:Errorhandling
                break
            }
        }
    
    }
    
}
