//
//  Pokemon.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import Foundation

enum PokemonType: String, Decodable {
    case bug = "Bug"
    case electric = "Electric"
    case steel = "Steel"
    case fairy = "Fairy"
    case ghost = "Ghost"
    case grass = "Grass"
    case fighting = "Fighting"
    case dragon = "Dragon"
    case fire = "Fire"
    case ground = "Ground"
    case water = "Water"
    case poison = "Poison"
    case psychic = "Psychic"
    case flying = "Flying"
    case rock = "Rock"
    case ice = "Ice"
    case normal = "Normal"
    case dark = "Dark"
    case unknown = "Unknown" //<- Missigno
    
    var name: String {
        return self.rawValue
    }
    
    var color: String {
        switch self {
        case .normal: return "#A8A77A"
        case .fire: return "#EE8130"
        case .water: return "#6390F0"
        case .electric: return "#F7D02C"
        case .grass: return "#7AC74C"
        case .ice: return "#96D9D6"
        case .fighting: return "#C22E28"
        case .poison: return "#A33EA1"
        case .ground: return "#E2BF65"
        case .flying: return "#A98FF3"
        case .psychic: return "#F95587"
        case .bug: return "#A6B91A"
        case .rock: return "#B6A136"
        case .ghost: return "#735797"
        case .dragon: return "#6F35FC"
        case .dark: return "#705746"
        case .steel: return "#B7B7CE"
        case .fairy: return "#D685AD"
        case .unknown: return "#2b1f17"
        }
    }
}

final class Pokemon: Decodable, Identifiable {
    
    let name: String
    let id: String
    let imageUrl: String
    let xDescription: String
    let yDescription: String
    let height: String
    let category: String
    let weight: String
    let typeOfPokemon: [PokemonType]
    let weaknesses: [String]
    let evolutions: [String]
    let abilities: [String]
    let hp: Double
    let attack: Double
    let defense: Double
    let speciaAttack: Double
    let specialDefense: Double
    let speed: Double
    let total: Double
    let genderless: Double
    let cycles: String
    let eggGroups: String
    let reason: String
    let evolvedFrom: String
    let baseExp: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case imageUrl = "imageurl"
        case xDescription = "xdescription"
        case yDescription = "ydescription"
        case height
        case category
        case weight
        case typeOfPokemon = "typeofpokemon"
        case weaknesses
        case evolutions
        case abilities
        case hp
        case attack
        case defense
        case speciaAttack = "special_attack"
        case specialDefense = "special_defense"
        case speed
        case total
        case genderless
        case cycles
        case eggGroups = "egg_groups"
        case reason
        case evolvedFrom = "evolvedfrom"
        case baseExp = "base_exp"
    }
    
    var mainType: PokemonType {
        typeOfPokemon.first ?? .unknown
    }
    
    static func sample() -> Pokemon {
        if let pkm = Pokemon.loadData().first {
            return pkm
        }
        fatalError()
    }
}

extension Pokemon: Hashable {
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Pokemon {
    static func loadData() -> [Pokemon] {
        if let path = Bundle(for: Pokemon.self).path(forResource: "PokemonList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let info = try decoder.decode([Pokemon].self, from: data)
                return info
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
        assertionFailure("Invalid Path for Pokemon List File'")
        return []
    }
}
