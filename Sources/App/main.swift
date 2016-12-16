import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)
drop.preparations.append(Acronyms.self)



drop.get("hello"){request in
    
    let result = try drop.database?.driver.raw("SELECT sqlite_version()")
    return try JSON(node:[
        "message" : result
        ])
}


drop.get("model"){request in
    let acronym = Acronyms.init(short: "GB", long: "Gareth Bale")
    return try acronym.makeJSON()
}

drop.get("test"){request in
    var acronym = Acronyms.init(short: "SA", long: "Sergio Aguero")
    try acronym.save()
    return try JSON(node: Acronyms.all().makeNode())
}
drop.post("create"){request in
    var acronym = try Acronyms(node:request.json)
    try acronym.save()
    return acronym
}


drop.get("all"){request in
    return try JSON(node:Acronyms.all())
}

drop.get("search"){request in
    return try JSON(node:Acronyms.query().first()?.makeNode())
    
}

drop.get("pablo"){request in
    return try JSON(node:Acronyms.query().filter("short",.notEquals,"SA").all())
    
}

drop.get("update"){request in
    guard var first = try Acronyms.query().first(),
        var long = request.data["long"]?.string else{
        throw Abort.badRequest
    }
    first.long = long
    try first.save()
    return try JSON(node:Acronyms.all())
}

drop.resource("posts", PostController())

drop.run()
