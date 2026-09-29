import Functor_Base_Macro
import Recursive_Macro
import Product
import Testing
import Zygomorphism_Macro

@FunctorBase
@Recursive
@Zygomorphism
private indirect enum Tree {
    case leaf(Int)
    case node(Tree, Tree)
}

private func height(_ layer: Tree.Base<Int>) -> Int {
    switch layer {
    case .leaf: 0
    case let .node(left, right): max(left, right) + 1
    }
}

@Suite
struct `Zygomorphism boundaries` {
    @Test
    func `a leaf folds without using the auxiliary result`() {
        let result = Tree.leaf(5).zygomorphism(auxiliary: height) { (layer: Tree.Base<Product<Int, Int>>) -> Int in
            switch layer {
            case let .leaf(value): value
            case .node: -1
            }
        }
        #expect(result == 5)
    }

    @Test
    func `each node sees the auxiliary fold of both children`() {
        let tree = Tree.node(.node(.leaf(1), .leaf(2)), .leaf(3))
        let balanced = tree.zygomorphism(auxiliary: height) { (layer: Tree.Base<Product<Int, Bool>>) -> Bool in
            switch layer {
            case .leaf: true
            case let .node(left, right): left.values.1 && right.values.1 && abs(left.values.0 - right.values.0) <= 1
            }
        }
        #expect(balanced)
        let skewed = Tree.node(.node(.node(.leaf(1), .leaf(2)), .leaf(3)), .leaf(4))
        #expect(!skewed.zygomorphism(auxiliary: height) { (layer: Tree.Base<Product<Int, Bool>>) -> Bool in
            switch layer {
            case .leaf: true
            case let .node(left, right): left.values.1 && right.values.1 && abs(left.values.0 - right.values.0) <= 1
            }
        })
    }
}
