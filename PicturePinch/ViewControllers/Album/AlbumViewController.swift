//
//  AlbumViewController.swift
//  PicturePinch
//
//  Created by Danny Grob on 06/04/2021.
//  Copyright (c) 2021 Digitalfactor. All rights reserved.
//

import UIKit

protocol AlbumDisplayLogic: class
{
    func displayAlbumContents(_ album: [Pictures.List.ViewModel], hasMore:Bool)
    func displayError(error:String)
}

class AlbumViewController: UIViewController, AlbumDisplayLogic
{
    var interactor: AlbumBusinessLogic?
    var router: (NSObjectProtocol & AlbumRoutingLogic & AlbumDataPassing)?
    
    
    var pictures:[Pictures.List.ViewModel] = []
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
        let request = Pictures.List.Request(albumId: id, page: currentPage, size: size)
        self.interactor?.fetchAlbumContents(request: request)
        self.interactor?.fetchAlbumContentsCache(request: request)
    }
    
    func displayAlbumContents(_ album: [Pictures.List.ViewModel], hasMore:Bool) {
        self.hasMore = hasMore
        self.update(with: album)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func displayError(error:String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".translate(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        fetchPictures(page:1, size: pictures.count)
    }
    
    func update(with contents:[Pictures.List.ViewModel]) {
        if let first = contents.first?.id, let last = contents.last?.id, pictures.count >= last{
            pictures.replaceSubrange(first - 1...last - 1, with: contents)
        } else {
            self.pictures.append(contentsOf: contents)
        }
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
        //TODO: define values for these magic numbers :)
        let width = (self.view.frame.size.width - 12 * 2) / 2
        return CGSize(width: width, height: width)
    }
}
