//
//  Pokemon.swift
//  Pokedex
//
//  Created by Programmer on 7/28/16.
//  Copyright © 2016 Programmer. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon
{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _attack: String!
    private var _weight: String!
    private var _defense: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    var name: String
    {
        return _name
    }
    
    var pokedexId: Int
    {
        return _pokedexId
    }
    
    var nextEvolutionText: String
    {
        if _nextEvolutionTxt == nil
        {
            _nextEvolutionTxt = "Error"
        }
        return _nextEvolutionTxt
    }
    
    var attack: String
    {
        if _attack == nil
        {
            _attack = "Error"
        }
        return _attack
    }
    
    var weight: String
    {
        if _weight == nil
        {
            _weight = "Error"
        }
        return _weight
    }
    
    var height: String
    {
        if _height == nil
        {
            _height = "Error"
        }
        return _height
    }
    
    var defense: String
    {
        if _defense == nil
        {
            _defense = "Error"
        }
        return _defense
    }
    
    var type: String
    {
        if _type == nil
        {
            _type = "Error"
        }
        return _type
    }
    
    var description: String
    {
        if _description == nil
        {
            _description = "Error"
        }
        return _description
    }
    
    init(name: String, pokedexId: Int)
    {
        self._name = name.capitalizedString
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete)
    {
        Alamofire.request(.GET, _pokemonURL)
                 .responseJSON { response in
                    
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject>
                    {
                        if let weight = dict["weight"] as? String
                        {
                            self._weight = weight
                        }
                        if let height = dict["height"] as? String
                        {
                            self._height = height
                        }
                        if let attack = dict["attack"] as? Int
                        {
                            self._attack = "\(attack)"
                        }
                        if let defense = dict["defense"] as? Int
                        {
                            self._defense = "\(defense)"
                        }
                        
                        print(self._weight)
                        print(self._height)
                        print(self._attack)
                        print(self._defense)
                        
                        completed()
                    }
            
        }
        
    }
    
}