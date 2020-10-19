//
//  ListViewModel.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import Foundation

protocol ListViewModelDelegate:class {
    func listViewModel(fetchedDidSucceed section:[Section])
    func listViewModel(fetchedDidFailure error:Error)
}

final class ListViewModel {
    
    weak var delegate:ListViewModelDelegate?
    private lazy var localeManager:LocaleManager = LocaleManager()
    init() {}
    
    func getSections(){
        localeManager.loadBundledContent(fromFileNamed: "part2")
        localeManager.delegate = self
    }
    
}

extension ListViewModel:LocaleManagerDelegate {
    func localeManager(fetchDidSucceed section: [Section]) {
        delegate?.listViewModel(fetchedDidSucceed: section)
    }
    
    func localeManager(fetchDidFailure error: Error) {
        delegate?.listViewModel(fetchedDidFailure: error)
    }
    
}
