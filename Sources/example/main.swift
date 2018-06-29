import DoctorPretty

enum Node {
    case string(String)
    case int(Int)
    case object([(String, Node)])
    case array([Node])
}

class NodeFormatter {
    func format(node: Node) -> Doc {
        switch node {
        case .string(let s): return .text("\"\(s)\"")
        case .int(let n): return .text("\(n)")
        case .object(let props): return format(properties: props)
        case .array(let nodes): return format(array: nodes)
        }
    }

    func format(properties: [(String, Node)]) -> Doc {
        return properties.map({ return format(property: $0) })
            .enclose(left: .lbrace, right: .rbrace, separator: .comma, indent: 4)
    }

    func format(property: (String, Node)) -> Doc {
        return .text("\"\(property.0)\":")
            <%> format(node: property.1)
    }

    func format(array: [Node]) -> Doc {
        return array.map({ return format(node: $0) }).list(indent: 4)
    }
}

let obj = Node.object([("hello", Node.string("world")), ("key", Node.int(3))])

let prettyRepr = NodeFormatter().format(node: obj).renderPretty(ribbonFrac: 0.4, pageWidth: 40)
print(prettyRepr.displayString())
