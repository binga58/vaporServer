import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)
drop.preparations.append(Acronym.self)



drop.get("hello"){request in
    
    let result = try drop.database?.driver.raw("SELECT sqlite_version()")
    return try JSON(node:[
        "message" : result
        ])
}


drop.get("model"){request in
    let acronym = Acronym.init(short: "GB", long: "Gareth Bale")
    return try acronym.makeJSON()
}

drop.get("test"){request in
    var acronym = Acronym.init(short: "SA", long: "Sergio Aguero")
    try acronym.save()
    return try JSON(node: Acronym.all().makeNode())
}
drop.post("create"){request in
    var acronym = try Acronym(node:request.json)
    try acronym.save()
    return acronym
}


drop.get("all"){request in
    return try JSON(node:Acronym.all())
}

drop.get("search"){request in
    return try JSON(node:Acronym.query().first()?.makeNode())
    
}

drop.get("pablo"){request in
    return try JSON(node:Acronym.query().filter("short",.notEquals,"SA").all())
    
}

drop.get("update"){request in
    guard var first = try Acronym.query().first(),
        var long = request.data["long"]?.string else{
        throw Abort.badRequest
    }
    first.long = long
    try first.save()
    return try JSON(node:Acronym.all())
}

drop.resource("posts", PostController())

drop.run()
