//
//  PodcastCell.swift
//  GoodLion
//
//  Created by AJ Caldwell on 4/16/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Foundation
import UIKit

// How to do this in IB: https://nshipster.com/uitableviewheaderfooterview/
class EpisodeListHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
}
