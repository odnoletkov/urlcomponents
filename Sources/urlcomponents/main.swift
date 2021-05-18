import Foundation

precondition(ProcessInfo.processInfo.arguments.count == 2)

let components = URLComponents(string: ProcessInfo.processInfo.arguments[1])!

extension Encodable {
    func jsonObject() throws -> Any {
        try JSONSerialization.jsonObject(with: try JSONEncoder().encode(self))
    }
}

var json = try components.jsonObject() as! [String: Any]

extension URLQueryItem: Encodable {
    public func encode(to encoder: Encoder) throws {
        enum Keys: CodingKey {
            case name
            case value
        }
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(value, forKey: .value)
        try container.encode(name, forKey: .name)
    }
}

json["query"] = try components.queryItems?.jsonObject()

var options = JSONSerialization.WritingOptions.prettyPrinted
if #available(OSX 10.13, *) {
    options.formUnion(.sortedKeys)
}

let data = try JSONSerialization.data(withJSONObject: json, options: options)
print(String(data: data, encoding: .utf8)!)
