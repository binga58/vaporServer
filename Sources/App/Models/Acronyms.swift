import Vapor
import Fluent
// MARK: - Model

struct Acronym: Model {
    var id: Node?
    var long: String?
    var short: String?
    
    // used by fluent internally
    var exists: Bool = false
    
    init(short:String, long:String) {
        self.id = nil
        self.short = short
        self.long = long
    }
}

// MARK: - NodeConvertible

extension Acronym: NodeConvertible {
    
    init(node: Node, in context: Context) throws {
        id = node["id"]
        long = node["long"]?.string
        short = node["short"]?.string
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node.init(node: [
            "id": id,
            "long": long,
            "short": short
            ])
    }
}

// MARK: - Database Preparations

extension Acronym: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("acronyms") { acronym in
            acronym.id()
            acronym.string("long")
            acronym.string("short")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("acronyms")
        
    }
}
