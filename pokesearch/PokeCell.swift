//
//  PokeCell.swift
//  
//
//  Created by paul on 22/03/2017.
//
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell(name: String!, id: Int){
        pokeImg.image = UIImage(named: "\(id)")
        pokeName.text = name
    }
}
