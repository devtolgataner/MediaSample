//
//  Data+Extension.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import Foundation

extension Data {
    func decoded<T: Decodable>(
        as type: T.Type = T.self,
        handledOn resultQueue: DispatchQueue = .main,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        let queue = DispatchQueue(
            label: "com.myapp.queue.background",
            qos: .background
        )
        let decoder = JSONDecoder()
        queue.async {
            let result = Result {
                try decoder.decode(T.self, from: self)
            }
            
            resultQueue.async { handler(result) }
        }
    }
}


