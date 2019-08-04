//
//  MovieCell.swift
//  MovieList
//
//  Created by Marcelo on 31/07/19.
//  Copyright © 2019 Marcelo. All rights reserved.
//
import UIKit

class MovieCell: UICollectionViewCell {
    static var reuseIdentifier = "MovieCell"
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
}
