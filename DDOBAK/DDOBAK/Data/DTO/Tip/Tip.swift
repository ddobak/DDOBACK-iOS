//
//  Tip.swift
//  DDOBAK
//
//  Created by 이건우 on 7/20/25.
//

import Foundation

struct Tip: Decodable, Hashable {
    let id: Int
    let title: String
    let summary: String
    let tags: [String]
    let url: String
}

extension Tip {
    static func mock() -> Tip {
        .init(
            id: -1,
            title: "mockmock",
            summary: "mockmockmockmockmockmock",
            tags: ["mock"],
            url: ""
        )
    }
}
