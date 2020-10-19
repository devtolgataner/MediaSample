//
//  LocaleManager.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import Foundation

protocol LocaleManagerDelegate:class {
    func localeManager(fetchDidSucceed section:[Section])
    func localeManager(fetchDidFailure error:Error)
}

final class LocaleManager {
    
    weak var delegate:LocaleManagerDelegate?
    
    enum Error: Swift.Error {
        case fileNotFound(name: String)
        case fileDecodingFailed(name: String, Swift.Error)
    }

    func loadBundledContent(fromFileNamed name: String) {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json"
        )
        else {
            delegate?.localeManager(fetchDidFailure: Error.fileNotFound(name: name))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            data.decoded(as: Response.self) { (result) in
                switch result {
                case .success( let response):
                    self.delegate?.localeManager(fetchDidSucceed: response.section)
                    return
                case .failure(let error):
                    self.delegate?.localeManager(fetchDidFailure: error)
                    return
                }
            }
        }
        catch (let error){
            delegate?.localeManager(fetchDidFailure: Error.fileDecodingFailed(name: name, error))
        }
    }
    
    
}

