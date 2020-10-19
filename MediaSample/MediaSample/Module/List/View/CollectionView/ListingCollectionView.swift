//
//  ListingCollectionView.swift
//  MediaSample
//
//  Created by Tolga Taner on 18.10.2020.
//

import UIKit

final class ListingCollectionView: UICollectionView {
    
    var sectionList:[Section] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return }
                self.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        
    }
    

}

extension ListingCollectionView: UICollectionViewDelegate {
    
}

extension ListingCollectionView: UIScrollViewDelegate {}

extension ListingCollectionView: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sectionList[indexPath.section]
        switch section {
        case .product(let section):
            let (height,width):(CGFloat,CGFloat) = (CGFloat(section.products[indexPath.row].height), CGFloat(section.products[indexPath.row].width))
            return CGSize(width: bounds.width - 20 , height: height/width * bounds.width )
        case .video:
            return CGSize(width: (bounds.width - 50) / 3 , height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = sectionList[section]
        switch section {
        case .product:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .video:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: bounds.width , height: 10)
    }
    
}

extension ListingCollectionView: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .product = sectionList[indexPath.section] { return }
        if let cell = cell as? VideoCollectionViewCell {
            cell.player.playFromCurrentTime()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .product = sectionList[indexPath.section] { return }
        if let cell = cell as? VideoCollectionViewCell {
            cell.player.stop()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sectionList[section]
        return section.getNumberOfItemsInSection()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sectionList[indexPath.section]
        switch section {
        case .product(let section):
            if let cell = dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as? ProductCollectionViewCell {
                let product = section.products[indexPath.row]
                cell.populate(product)
                return cell
            }
        case .video(let section):
            if let cell = dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.id, for: indexPath) as? VideoCollectionViewCell {
                let video = section.videos[indexPath.row]
                cell.populate(video)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
}




