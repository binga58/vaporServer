import Vapor

final class Acronyms: Model{
    
    var id: Node?
    var exists: Bool = false
    var short : String
    var long : String
    
    init(short:String, long:String) {
        self.id = nil
        self.short = short
        self.long = long
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        short = try node.extract("short")
        long = try node.extract("long")
        
    }
    
    public func makeNode(context: Context) throws -> Node {
        return try Node.init(node:[
            "short":self.short,
            "long":self.long
            
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("acronymss") { (user) in
            user.id()
            user.string("short")
            user.string("long")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("acronymss")
    }
    
}
