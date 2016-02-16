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

struct GenericResponse<T where T: Equatable>: Glossy {
    
    var args: T

    init(args: T) { 
        self.args = args
    }

    init?(json: JSON) {
        guard let args: T = "args" <~~ json else { return nil } 
        
        self.args = args
    }

    func toJSON() -> JSON? {
        return jsonify([ 
            "args" ~~> self.args
        ])
    }

}
