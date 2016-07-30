//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Programmer on 7/29/16.
//  Copyright © 2016 Programmer. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
    }

}
