//
//  AlbumPresenter.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//

import UIKit

protocol AlbumPresentationLogic
{
    func presentAlbumContents(response: Pictures.List.Response)
    func presentError(error:Error)
}

class AlbumPresenter: AlbumPresentationLogic
{
    weak var viewController: AlbumDisplayLogic?
    
    func presentAlbumContents(response: Pictures.List.Response)
    {
        viewController?.displayAlbumContents(response.pictures, hasMore: response.hasMore)
    }
    
    func presentError(error:Error) {
        viewController?.displayError(error: error.localizedDescription)
    }
}
