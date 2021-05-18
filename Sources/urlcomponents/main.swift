import Foundation

precondition(ProcessInfo.processInfo.arguments.count == 2)

let components = URLComponents(string: ProcessInfo.processInfo.arguments[1])!

extension Encodable {
    func jsonObject() throws -> Any {
        try JSONSerialization.jsonObject(with: try JSONEncoder().encode(self))
    }
}

var json = try components.jsonObject() as! [String: Any]

json["query"] = components.queryItems.map {
    Dictionary($0.map { ($0.name, $0.value) }) { $1 }
}

var options = JSONSerialization.WritingOptions.prettyPrinted
if #available(OSX 10.13, *) {
    options.formUnion(.sortedKeys)
}

let data = try JSONSerialization.data(withJSONObject: json, options: options)
print(String(data: data, encoding: .utf8)!)
