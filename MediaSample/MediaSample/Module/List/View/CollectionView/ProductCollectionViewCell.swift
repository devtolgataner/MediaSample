//
//  ListingCollectionViewCell.swift
//  MediaSample
//
//  Created by Tolga Taner on 18.10.2020.
//

import UIKit.UICollectionViewCell
import Kingfisher

final class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var product:ProductSection.Product! {
        didSet{
            if let product = product {
                priceLabel.text = product.price.asCurreny
                titleLabel.text = product.title
                guard let resource = URL(string: product.imageUrl) else { return }
                imageView.kf.setImage(with: resource)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.text?.removeAll()
        titleLabel.text?.removeAll()
    }
    
    
    func populate(_ product:ProductSection.Product) {
        self.product = product
    }
    
}
