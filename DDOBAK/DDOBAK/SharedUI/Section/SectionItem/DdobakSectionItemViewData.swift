//
//  DdobakSectionItemViewData.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import Foundation

struct DdobakSectionItemViewData: Equatable {
    let leadingItemText: String
    let trailingItem: DdobakSectionTrailingItemType
}

enum DdobakSectionTrailingItemType: Equatable {
    case text(String)
    case icon(type: TrailingItemIconType)
   
   enum TrailingItemIconType {
       case arrow
       
       var iconName: String {
           switch self {
           case .arrow:
               return "rightArrow"
           }
       }
   }
}
