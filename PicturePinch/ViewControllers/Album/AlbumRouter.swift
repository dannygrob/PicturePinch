//
//  AlbumRouter.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//

import UIKit

@objc protocol AlbumRoutingLogic
{
  
}

protocol AlbumDataPassing
{
  var dataStore: AlbumDataStore? { get }
}

class AlbumRouter: NSObject, AlbumRoutingLogic, AlbumDataPassing
{
  weak var viewController: AlbumViewController?
  var dataStore: AlbumDataStore?
}
