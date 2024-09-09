//
//  ISM_Data+Extension.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 20/06/24.
//

import Foundation

extension Data {
    public func decode<T:Codable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
