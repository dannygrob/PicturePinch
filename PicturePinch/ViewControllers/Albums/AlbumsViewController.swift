//
//  AlbumsViewController.swift
//  PicturePinch
//
//  Created by Danny Grob on 01/04/2021.
//  Copyright (c) 2021 DigitalFactor. All rights reserved.

import UIKit

protocol AlbumsDisplayLogic: class
{
    func displayAlbums(_ albums: [Albums.List.ViewModel], hasMore:Bool)
    func displayError(error:String)
}

class AlbumsViewController: UIViewController, AlbumsDisplayLogic
{
    var interactor: AlbumsBusinessLogic?
    var router: (NSObjectProtocol & AlbumsRoutingLogic & AlbumsDataPassing)?
    var currentPage:Int = 1
    var albums:[Albums.List.ViewModel] = []
    var selectedAlbumId:Int?
    var hasMore:Bool = true
    var refreshControl:UIRefreshControl?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup()
    {
        let viewController = self
        let interactor = AlbumsInteractor()
        let presenter = AlbumsPresenter()
        let router = AlbumsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
        
        if let dest = segue.destination as? AlbumViewController {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let album = albums[selectedIndexPath.row]
                dest.albumId = album.id
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
        fetchAlbums(page: currentPage)
        
        self.title = "albums".translate()
    }
    
    @objc func refresh() {
        fetchAlbums(page: currentPage, size: albums.count)
    }
    
    func fetchAlbums(page:Int, size:Int = 10)
    {
        currentPage = page
        let request = Albums.List.Request(page: page, size: size)
        interactor?.fetchAlbumsCache(request: request)
        interactor?.fetchAlbums(request: request)
    }
    
    func displayAlbums(_ albums: [Albums.List.ViewModel], hasMore:Bool) {
        self.hasMore = hasMore
        self.update(with: albums)
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func displayError(error:String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".translate(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func update(with contents:[Albums.List.ViewModel]) {
        if let first = contents.first?.id, let last = contents.last?.id, albums.count >= last{
            albums.replaceSubrange(first - 1...last - 1, with: contents)
        } else {
            self.albums.append(contentsOf: contents)
        }
    }
    
}

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        
        if indexPath.row == albums.count - 1, hasMore == true {
            currentPage += 1
            fetchAlbums(page: currentPage)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumTableViewCell {
            cell.titleLabel?.text = album.title
            cell.idLabel?.text = "\(album.id)"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
