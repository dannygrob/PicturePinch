//
//  AlbumPresenter.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
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
