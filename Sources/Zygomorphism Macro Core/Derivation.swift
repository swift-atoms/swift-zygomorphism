public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {}

extension Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = access(of: declaration)
        return [
            """
            \(raw: access)func zygomorphism<Auxiliary, Result>(
                auxiliary: (Base<Auxiliary>) -> Auxiliary,
                algebra: (Base<Product<Auxiliary, Result>>) -> Result
            ) -> Result {
                func fold(_ recursive: Self) -> Product<Auxiliary, Result> {
                    let children = recursive.project().map(fold)
                    return Product(
                        auxiliary(children.map { $0.values.0 }),
                        algebra(children)
                    )
                }
                return fold(self).values.1
            }
            """
        ]
    }

    /// The access modifier the generated member carries: the enum's own level,
    /// with `private` widened to `fileprivate` so the member stays reachable
    /// wherever the enum is.
    static func access(of declaration: EnumDeclSyntax) -> String {
        for modifier in declaration.modifiers {
            switch modifier.name.tokenKind {
            case .keyword(.public), .keyword(.open):
                return "public "
            case .keyword(.package), .keyword(.fileprivate):
                return "\(modifier.name.text) "
            case .keyword(.private):
                return "fileprivate "
            default:
                continue
            }
        }
        return ""
    }
}
