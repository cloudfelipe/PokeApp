//
//  PokemonType.swift
//  PokeApp
//
//  Created by Felipe Correa on 12/05/23.
//

import Foundation

enum PokemonType: String, CaseIterable, Comparable, Decodable {
    
    static func < (lhs: PokemonType, rhs: PokemonType) -> Bool {
        lhs.name < rhs.name
    }
    
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

extension PokemonType {
    func effectiveness(to objective: PokemonType) -> Double {
        let defaultValue = 1.0
        switch self {
        case .normal:
            switch objective {
            case .ghost: return 0
            case .fighting: return 2
            default: return defaultValue
            }
        case .fire:
            switch objective {
            case .bug: return 0.5
            case .fairy: return 0.5
            case .fire: return 0.5
            case .grass: return 0.5
            case .ice: return 0.5
            case .steel: return 0.5
            case .ground: return 2
            case .rock: return 2
            case .water: return 2
            default: return defaultValue
            }
        case .water:
            switch objective {
            case .fire: return 0.5
            case .ice: return 0.5
            case .steel: return 0.5
            case .water: return 0.5
            case .electric: return 2
            case .grass: return 2
            default: return defaultValue
            }
        case .electric:
            switch objective {
            case .electric: return 0.5
            case .flying: return 0.5
            case .steel: return 0.5
            case .ground: return 2
            default: return defaultValue
            }
        case .grass:
            switch objective {
            case .electric: return 0.5
            case .grass: return 0.5
            case .ground: return 0.5
            case .water: return 0.5
            case .bug: return 2
            case .ice: return 2
            case .flying: return 2
            case .fire: return 2
            case .poison: return 2
            default: return defaultValue
            }
        case .ice:
            switch objective {
            case .ice: return 0.5
            case .fire: return 2
            case .fighting: return 2
            case .rock: return 2
            case .steel: return 2
            default: return defaultValue
            }
        case .fighting:
            switch objective {
            case .bug: return 0.5
            case .rock: return 0.5
            case .dark: return 0.5
            case .flying: return 2
            case .psychic: return 2
            case .fairy: return 2
            default: return defaultValue
            }
        case .poison:
            switch objective {
            case .fighting: return 0.5
            case .poison: return 0.5
            case .bug: return 0.5
            case .fairy: return 0.5
            case .ground: return 2
            case .psychic: return 2
            default: return defaultValue
            }
        case .ground:
            switch objective {
            case .electric: return 0
            case .poison: return 0.5
            case .rock: return 0.5
            case .water: return 2
            case .grass: return 2
            case .ice: return 2
            default: return defaultValue
            }
        case .flying:
            switch objective {
            case .ground: return 0
            case .grass: return 0.5
            case .fighting: return 0.5
            case .bug: return 0.5
            case .electric: return 2
            case .ice: return 2
            case .rock: return 2
            default: return defaultValue
            }
        case .psychic:
            switch objective {
            case .fighting: return 0.5
            case .psychic: return 0.5
            case .bug: return 2
            case .ghost: return 2
            case .dark: return 2
            default: return defaultValue
            }
        case .bug:
            switch objective {
            case .grass: return 0.5
            case .fighting: return 0.5
            case .ground: return 0.5
            case .fire: return 2
            case .flying: return 2
            case .rock: return 2
            default: return defaultValue
            }
        case .rock:
            switch objective {
            case .normal: return 0.5
            case .fire: return 0.5
            case .poison: return 0.5
            case .flying: return 0.5
            case .water: return 2
            case .grass: return 2
            case .fighting: return 2
            case .ground: return 2
            case .steel: return 2
            default: return defaultValue
            }
        case .ghost:
            switch objective {
            case .normal: return 0
            case .fighting: return 0
            case .poison: return 0.5
            case .bug: return 0.5
            case .ghost: return 2
            case .dark: return 2
            default: return defaultValue
            }
        case .dragon:
            switch objective {
            case .fire: return 0.5
            case .water: return 0.5
            case .electric: return 0.5
            case .grass: return 0.5
            case .ice: return 2
            case .dragon: return 2
            case .fairy: return 2
            default: return defaultValue
            }
        case .dark:
            switch objective {
            case .psychic: return 0
            case .ghost: return 0.5
            case .dark: return 0.5
            case .fighting: return 2
            case .bug: return 2
            case .fairy: return 2
            default: return defaultValue
            }
        case .steel:
            switch objective {
            case .poison: return 0
            case .normal: return 0.5
            case .grass: return 0.5
            case .ice: return 0.5
            case .flying: return 0.5
            case .psychic: return 0.5
            case .bug: return 0.5
            case .rock: return 0.5
            case .dragon: return 0.5
            case .steel: return 0.5
            case .fairy: return 0.5
            case .fire: return 2
            case .fighting: return 2
            case .ground: return 2
            default: return defaultValue
            }
        case .fairy:
            switch objective {
            case .dragon: return 0
            case .fighting: return 0.5
            case .bug: return 0.5
            case .dark: return 0.5
            case .poison: return 2
            case .steel: return 2
            default: return defaultValue
            }
        case .unknown:
            return -1.0
        }
    }
}
