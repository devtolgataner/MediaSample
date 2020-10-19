//
//  Section.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import Foundation


protocol ItemVariant:Decodable {
    var title:String { get }
}

enum ItemType: String, Decodable {
    case video = "video"
    case product = "product"
}

enum Section:Decodable {
    
    case product(ProductSection)
    case video(VideoSection)
    
    func getNumberOfItemsInSection()->Int {
        switch self {
        case .product(let section):return section.products.count
        case .video(let section):return section.videos.count
        }
    }
    
    struct InvalidTypeError: Error {
        var type: String
    }
    
    private enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "product":
            self = .product(try ProductSection(from: decoder))
        case "video":
            self = .video(try VideoSection(from: decoder))
        default:
            throw InvalidTypeError(type: type)
        }
    }
    
}


struct ProductSection:ItemVariant {
    
    func encode(to encoder: Encoder) throws {}
    
    
    var title: String
    var type:ItemType { return .product }
    var products:[Product]
    
    private enum CodingKeys: String, CodingKey {
            case products,
                 title
    }
    
    struct Product:Decodable {
        var price:Double
        var imageUrl:String
        var id: Int
        var title:String
        var width:Int
        var height:Int
        
        private enum CodingKeys: String, CodingKey {
            case price,
                 imageUrl,
                 id,
                 width,height,
                 title
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            price = try container.decode(Double.self, forKey: .price)
            imageUrl = try container.decode(String.self, forKey: .imageUrl)
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            width = try container.decode(Int.self, forKey: .width)
            height = try container.decode(Int.self, forKey: .height)
        }
    }
    
}

struct VideoSection:ItemVariant {
    
    
    var title: String
    var type:ItemType { return .video }
    var videos:[Video]
    
    enum CodingKeys: String, CodingKey {
            case title,videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        videos = try container.decode([Video].self, forKey: .videos)
    }
    
    struct Video:Decodable {
        var url:String
        var id: Int
        var title:String
        private enum CodingKeys: String, CodingKey {
                case url, id, title
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            url = try container.decode(String.self, forKey: .url)
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
        }
        
    }
    
}
