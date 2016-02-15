//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2016 RahulKatariya. All rights reserved.
//

import Gloss

struct PersonJson: Glossy {
    
    var id: String
    var name: String

    init(id: String, name: String) { 
        self.id = id
        self.name = name
    }

    init?(json: JSON) { 
        guard let id: String = "json.id" <~~ json,
            let name: String = "json.name" <~~ json else { return nil } 
        
        self.id = id
        self.name = name
    }

    func toJSON() -> JSON? {
        return jsonify([ 
            "json.id" ~~> self.id,
            "json.name" ~~> self.name
        ])
    }

}

extension PersonJson: Equatable { }

func == (lhs: PersonJson, rhs: PersonJson) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
} 
