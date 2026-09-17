import Recursive_Macro_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        Recursive_Macro_Core.Derivation.expansion(of: declaration)
            + operation(of: declaration)
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
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
            """]
    }
}
