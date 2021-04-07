//
//  AlbumViewController.swift
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

protocol AlbumDisplayLogic: class
{
    func displayAlbumContents(_ album: [Albums.Contents.ViewModel], hasMore:Bool)
}

class AlbumViewController: UIViewController, AlbumDisplayLogic
{
    var interactor: AlbumBusinessLogic?
    var router: (NSObjectProtocol & AlbumRoutingLogic & AlbumDataPassing)?
    
    
    var pictures:[Albums.Contents.ViewModel] = []
    var albumId:Int?
    var currentPage:Int = 1
    var hasMore:Bool = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var refreshControl:UIRefreshControl?
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
        let interactor = AlbumInteractor()
        let presenter = AlbumPresenter()
        let router = AlbumRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PhotoViewController, let selected = collectionView.indexPathsForSelectedItems?.first {
            let picture = pictures[selected.row]
            dest.photo = picture
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.addSubview(refreshControl!)
        
        fetchPictures(page: 1, size: 10)
    }
    
    func fetchPictures(page:Int, size:Int = 10) {
        guard let id = albumId else {
            return
        }
        let request = Albums.Contents.Request(albumId: id, page: currentPage, size: size)
        self.interactor?.fetchAlbumContents(request: request)
    }
    
    func displayAlbumContents(_ album: [Albums.Contents.ViewModel], hasMore:Bool) {
        self.hasMore = hasMore
        self.pictures.append(contentsOf: album)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refresh() {
        fetchPictures(page:1, size: pictures.count)
    }
    
}

extension AlbumViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let picture = pictures[indexPath.row]
        
        if indexPath.row == pictures.count - 1, hasMore == true {
            currentPage += 1
            fetchPictures(page: currentPage)
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PictureCollectionViewCell {
            cell.imageURL = picture.thumbnailURL
            cell.titleLabel?.text = picture.title
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 12 * 2) / 2
        return CGSize(width: width, height: width)
    }
}