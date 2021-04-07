//
//  AlbumsModels.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.

import UIKit

enum Albums
{
    enum List
    {
        struct Request
        {
            let page:Int
            let size:Int
        }
        struct Response
        {
            let albums:[Albums.List.ViewModel]
            let hasMore:Bool
        }
        struct ViewModel
        {
            let id:Int
            let title:String
        }
    }
    
    
    enum Contents
    {
        struct Request
        {
            let albumId:Int
            let page:Int
            let size:Int
        }
        struct Response
        {
            let pictures:[Albums.Contents.ViewModel]
            let hasMore:Bool
        }
        struct ViewModel
        {
            let title:String
            let thumbnailURL:String
            let cachedImage:UIImage? = nil
            let url:String
        }
    }
}
