//
//  ListViewController.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import UIKit.UIViewController

final class ListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var listingCollectionView: ListingCollectionView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel:ListViewModel = ListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "Listing"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
        viewModel.getSections()
    }
    
}

extension ListViewController:ListViewModelDelegate {
    
    func listViewModel(fetchedDidSucceed section: [Section]) {
        activityIndicatorView.stopAnimating()
        listingCollectionView.sectionList = section 
    }
    
    func listViewModel(fetchedDidFailure error: Error) {
        activityIndicatorView.stopAnimating()
        showAlert(title: "",
             message: error.localizedDescription,
                              alertStyle: .alert,
                              actionTitles: ["Okay"],
                              actionStyles: [.default],
                              actions: [
                                  {_ in
                                  },
                                  {_ in
                                  }
                             ])

    }
}
