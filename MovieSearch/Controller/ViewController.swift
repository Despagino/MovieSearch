    //
//  ViewController.swift
//  MovieSearch
//
//  Created by Gino Tasis on 3/11/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    // MARK: - Properties
 
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var field: UITextField!

    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")

        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=1a326e6f4f3b3cee865c27b54d44b22f&query=\(query)")!) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }

            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
                
                
            } catch {
                print(error)
            }
            
            guard let finalResult = result else {
                return
            }
            
            
            let newMovies = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }.resume()
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchMovies()
        field.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        field.text = ""
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifer, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

struct MovieResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    
    let original_title: String
    let overview: String
    let vote_average: Float
    let poster_path: String?
    
}
