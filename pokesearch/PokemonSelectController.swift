//
//  PokemonSelectController.swift
//  pokesearch
//
//  Created by paul on 22/03/2017.
//  Copyright © 2017 paul. All rights reserved.
//

import UIKit
protocol MyProtocol
{
    func setPokemon(pokemon: Int)
}
class PokemonSelectController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

      var myProtocol: MyProtocol?
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
          collection.dataSource = self
          collection.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell
        {
            cell.configureCell(name: pokemon[indexPath.row+1],id: indexPath.row+1)
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         myProtocol?.setPokemon(pokemon: indexPath.row+1)
         dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}

