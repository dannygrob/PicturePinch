//
//  AlbumModels.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.


import UIKit

enum Pictures {
    enum List
    {
        struct Request
        {
            let albumId:Int
            let page:Int
            let size:Int
        }
        struct Response
        {
            let pictures:[Pictures.List.ViewModel]
            let hasMore:Bool
        }
        struct ViewModel
        {
            let id:Int
            let title:String
            let thumbnailURL:String
            let cachedImage:UIImage? = nil
            let url:String
        }
    }
}
