//
//  AlbumInteractor.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//


import UIKit

protocol AlbumBusinessLogic
{
    func fetchAlbumContents(request: Pictures.List.Request)
    func fetchAlbumContentsCache(request: Pictures.List.Request)
}

protocol AlbumDataStore
{
    //not used for now
}

class AlbumInteractor: AlbumBusinessLogic, AlbumDataStore
{
    var presenter: AlbumPresentationLogic?
    var worker: AlbumWorker = AlbumWorker()
    
    func fetchAlbumContents(request: Pictures.List.Request)
    {
        worker.fetchPictures(albumId: request.albumId, page: request.page, size: request.size) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let pics):
                let response = Pictures.List.Response(pictures: pics, hasMore: pics.count == request.size)
                self.presenter?.presentAlbumContents(response: response)
                break
            case .failure(let error):
                self.presenter?.presentError(error: error)
                break
            }
        }
        
        
    }
    
    func fetchAlbumContentsCache(request: Pictures.List.Request)
    {
        worker.fetchCachedPictures(albumId: request.albumId, page: request.page, size: request.size) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let pics):
                let response = Pictures.List.Response(pictures: pics, hasMore: pics.count == request.size)
                self.presenter?.presentAlbumContents(response: response)
                break
            case .failure(let error):
                self.presenter?.presentError(error: error)
                break
            }
        }
        
        
    }
}
