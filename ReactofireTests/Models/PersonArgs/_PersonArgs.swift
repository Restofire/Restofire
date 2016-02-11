//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2015 RahulKatariya. All rights reserved.
//

import Gloss

struct PersonArgs: Glossy {
    
    var id: String
    var name: String

    init(id: String, name: String) { 
        self.id = id
        self.name = name
    }

    init?(json: JSON) { 
        guard let id: String = "args.id" <~~ json,
            let name: String = "args.name" <~~ json else { return nil } 
        
        self.id = id
        self.name = name
    }

    func toJSON() -> JSON? {
        return jsonify([ 
            "args.id" ~~> self.id,
            "args.name" ~~> self.name
        ])
    }

}

extension PersonArgs: Equatable { }

func == (lhs: PersonArgs, rhs: PersonArgs) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
} 
