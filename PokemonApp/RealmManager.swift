//
//  RealmManager.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    
    private(set) var localRealm: Realm?
    @Published private(set) var favourites: [FavouritePokemon] = []
    @Published var newFavPokemon: String = ""
    @Published var pokemonDeletedFromFavs: Bool = false
    
    init(){
        openRealm()
        getFavourites()
    }
    
    func openRealm() {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addPokemonToFavourites(name: String){
        if let localRealm = localRealm {
            do{
                try localRealm.write {
                    let newPokemon = FavouritePokemon(value: ["name": name])
                    localRealm.add(newPokemon)
                    getFavourites()
                    print("Aggiunto \(name) alla lista dei preferiti")
                    var listaPreferiti = [String]()
                    favourites.forEach { poke in
                        listaPreferiti.append(poke.name)
                    }
                    print("Lista preferiti dopo l'aggiunta di \(name) è \(listaPreferiti)")
                }
            } catch {
                print("Error in add pokemon ro realm: \(error)")
            }
        }
    }
    
    func getFavourites(){
        if let localRealm = localRealm {
            let allFavourites = localRealm.objects(FavouritePokemon.self) // prende la lista dei preferiti ma la riordina alfabeticamente 
            favourites = []
            allFavourites.forEach { favs in
                favourites.append(favs)
            }
            favourites = favourites.reversed()
        }
    }
    
    func deletePokemonFromFavourites(id: ObjectId){
        if let localRealm = localRealm {
            do {
                let pokemonToDelete = localRealm.objects(FavouritePokemon.self).where {$0.id == id}
                //let pokemonToDelete = localRealm.objects(FavouritePokemon.self).filter("id == %@", id)
                try localRealm.write {
                    localRealm.delete(pokemonToDelete)
                    getFavourites()
                }
            } catch {
                print("Error deleting task \(id) from Realm: \(error)")
            }
        }
    }
}

