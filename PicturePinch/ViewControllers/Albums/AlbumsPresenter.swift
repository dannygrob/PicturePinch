//
//  AlbumsPresenter.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//

import UIKit

protocol AlbumsPresentationLogic
{
    func presentAlbums(response: Albums.List.Response)
    func presentError(error:Error)
}

class AlbumsPresenter: AlbumsPresentationLogic
{
    weak var viewController: AlbumsDisplayLogic?
    
    func presentAlbums(response: Albums.List.Response)
    {
        viewController?.displayAlbums(response.albums, hasMore: response.hasMore)
    }
    
    func presentError(error:Error) {
        viewController?.displayError(error: error.localizedDescription)
    }
}
