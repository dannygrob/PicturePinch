//
//  AlbumsRouter.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//

import UIKit

@objc protocol AlbumsRoutingLogic
{
}

protocol AlbumsDataPassing
{
  var dataStore: AlbumsDataStore? { get }
}

class AlbumsRouter: NSObject, AlbumsRoutingLogic, AlbumsDataPassing
{
  weak var viewController: AlbumsViewController?
  var dataStore: AlbumsDataStore?
}
