//
//  AlbumsInteractor.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.

import UIKit

protocol AlbumsBusinessLogic
{
    func fetchAlbums(request: Albums.List.Request)
    func fetchAlbumsCache(request: Albums.List.Request)
}

protocol AlbumsDataStore
{
    
}

class AlbumsInteractor: AlbumsBusinessLogic, AlbumsDataStore
{
    var presenter: AlbumsPresentationLogic?
    var worker: AlbumsWorker = AlbumsWorker()
    
    func fetchAlbums(request: Albums.List.Request)
    {
        worker.fetchAlbums(page: request.page, size: request.size, completion: { (result) in
            switch result {
            case .success(let vms):
                let response = Albums.List.Response(albums: vms, hasMore: vms.count == request.size)
                self.presenter?.presentAlbums(response: response)
                break
            case .failure(let error):
                self.presenter?.presentError(error: error)
                break
            }
        })
    }
    
    func fetchAlbumsCache(request: Albums.List.Request)
    {
        worker.fetchCachedAlbums(page: request.page, size: request.size, completion: { (result) in
            switch result {
            case .success(let vms):
                let response = Albums.List.Response(albums: vms, hasMore: vms.count == request.size)
                self.presenter?.presentAlbums(response: response)
                break
            case .failure(let error):
                self.presenter?.presentError(error: error)
                break
            }
        })
    }
}
