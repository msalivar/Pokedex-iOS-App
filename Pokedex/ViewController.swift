//
//  ViewController.swift
//  Pokedex
//
//  Created by Programmer on 7/28/16.
//  Copyright © 2016 Programmer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio()
    {
        let path = NSBundle.mainBundle().pathForResource("gym", ofType: "mp3")
        do
        {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
        }
        catch let err as NSError
        {
            print (err.debugDescription)
        }
    }
    
    func parsePokemonCSV()
    {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do
        {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows
            {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCellCollectionViewCell
        {
            let poke: Pokemon!
            
            if (inSearchMode)
            {
                poke = filteredPokemon[indexPath.row]
            }
            else
            {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var poke: Pokemon!
        if inSearchMode
        {
            poke = filteredPokemon[indexPath.row]
        }
        else
        {
            poke = pokemon[indexPath.row]
        }
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (inSearchMode)
        {
            return filteredPokemon.count
        }
        else
        {
            return pokemon.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(sender: UIButton)
    {
        if musicPlayer.playing
        {
            musicPlayer.pause()
            sender.alpha = 1.0
        }
        else
        {
            musicPlayer.play()
            sender.alpha = 0.5
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }
        else
        {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "PokemonDetailVC"
        {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC
            {
                if let poke = sender as? Pokemon
                {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}

