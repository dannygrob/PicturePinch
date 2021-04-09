//
//  AlbumsViewController.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class AlbumsViewController: UIViewController
{
    private let items = PublishSubject<[Albums.List.ViewModel]>()
    private var currentPage:Int = 1
    private let bag = DisposeBag()
    private let viewModel = AlbumsViewModel()
    private var selectedAlbumId:Int?
    
    private var hasMore:Bool = true
    private var refreshControl:UIRefreshControl?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let dest = segue.destination as? AlbumViewController {
            if let albumId = self.selectedAlbumId {
                dest.albumId = albumId
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "albums".translate()

        tableView.rx.setDelegate(self).disposed(by: bag)
        self.bindTableView()
    }
    
    private func bindTableView() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "AlbumCell", cellType: AlbumTableViewCell.self)) { (row,item,cell) in
            cell.item = item
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Albums.List.ViewModel.self).subscribe(onNext: { item in
            self.selectedAlbumId = item.id
            self.performSegue(withIdentifier: "ShowAlbum", sender: self)
            
        }).disposed(by: bag)
        
        viewModel.fetchAlbumList(page: currentPage, size: 30)
    }
    
    func displayError(error:String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".translate(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
