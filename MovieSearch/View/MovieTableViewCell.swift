//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Gino Tasis on 3/14/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifer = "MovieTableViewCell"
    
    static func nib() -> UINib {
        
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
        
    }
    
    func configure(with model: Movie) {
    
        
        self.movieTitle.text = model.original_title
        self.movieRating?.text = String(model.vote_average)
        self.movieDescription.text = model.overview
        let url = "https://image.tmdb.org/t/p/w500/\(String(describing: model.poster_path))"
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.moviePoster.image = UIImage(data: data)
        }
    }
}
