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
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
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
    
    var nextEvolutionName: String
    {
        if _nextEvolutionName == nil
        {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String
    {
        if _nextEvolutionId == nil
        {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String
    {
        if _nextEvolutionLvl == nil
        {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
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
                        if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0
                        {
                            if let name = types[0]["name"]
                            {
                                self._type = name.capitalizedString
                            }
                            if types.count > 1
                            {
                                for x in 1..<types.count
                                {
                                    if let name = types[x]["name"]
                                    {
                                        self._type! += "/\(name.capitalizedString)"
                                    }
                                }
                            }
                        }
                        else
                        {
                            self._type = "No Types"
                        }
                        if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0
                        {
                            if let url = descArr[0]["resource_uri"]
                            {
                                let descURL = "\(URL_BASE)\(url)"
                                Alamofire.request(.GET, descURL)
                                    .responseJSON { response in
                                        
                                        if let descDict = response.result.value as? Dictionary<String, AnyObject>
                                        {
                                            if let description = descDict["description"] as? String
                                            {
                                                let newDescription = description.stringByReplacingOccurrencesOfString("POKMON", withString: "Pokemon")
                                                self._description = newDescription
                                            }
                                        }
                                        completed()
                                }
                            }
                        }
                        else
                        {
                            self._description = "No Description Available"
                        }
                        if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0
                        {
                            if let nextEvo = evolutions[0]["to"] as? String
                            {
                                if nextEvo.rangeOfString("mega") == nil
                                {
                                    self._nextEvolutionName = nextEvo
                                    if let uri = evolutions[0]["resource_uri"] as? String
                                    {
                                        let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                        let nextEvoId = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                        self._nextEvolutionId = nextEvoId
                                        if let lvlExist = evolutions[0]["level"]
                                        {
                                            if let lvl = lvlExist as? Int
                                            {
                                                self._nextEvolutionLvl = "\(lvl)"
                                            }
                                        }
                                        else
                                        {
                                            self._nextEvolutionLvl = ""
                                        }
                                    }
                                }
                            }
                        }
                        
                        completed()
                    }
            
        }
        
    }
    
}