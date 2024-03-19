//
//  CeldaNoticiaTableViewTableViewCell.swift
//  AppNews
//
//  Created by Victor ulises Vazquez arriaga on 04/03/24.
//

import UIKit

class CeldaNoticiaTableViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tituloNoticiaLabel: UILabel!
    @IBOutlet weak var descriptionNoticiaLabel: UILabel!
    @IBOutlet weak var imageNoticiaIV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageNoticiaIV.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

struct NoticiasModelo: Codable {
    
    let articles: [Noticia]
    
}

struct Noticia: Codable {
    
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    
}
