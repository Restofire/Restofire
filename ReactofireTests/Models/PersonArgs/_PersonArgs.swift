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
    
    var args: Person

    init(args: Person) { 
        self.args = args
    }

    init?(json: JSON) { 
        guard let args: Person = "args" <~~ json else { return nil } 
        
        self.args = args
    }

    func toJSON() -> JSON? {
        return jsonify([ 
            "args" ~~> self.args
        ])
    }

}
