import Functor_Base_Macro
import Recursive_Macro
import Product
import Testing
import Zygomorphism_Macro

@FunctorBase
@Recursive
@Zygomorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `zygomorphism shares an auxiliary fold with the main algebra`() {
    let two = Natural.successor(.successor(.zero))
    let doubled = two.zygomorphism(
        auxiliary: { (layer: Natural.Base<Int>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child + 1
            }
        },
        algebra: {
            (layer: Natural.Base<Product<Int, Int>>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child.values.0 + child.values.1 + 1
            }
        }
    )
    #expect(doubled == 3)
}
