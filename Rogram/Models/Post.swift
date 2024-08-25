//
//  Post.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
