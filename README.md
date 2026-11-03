# swift-zygomorphism

Use this package when a fold over a recursive enum needs, at each layer, the result of a second, simpler fold over each child, for example checking balance with the help of heights, without writing two traversals. Start from the `@Zygomorphism` macro, attached to an enum that also carries `@Recursive` and `@FunctorBase`; it adds a `zygomorphism` method that runs an `auxiliary` fold and the main `algebra` together. When no auxiliary fold is needed, use swift-catamorphism; when the algebra needs the original child, use swift-paramorphism; when it needs the results of every earlier layer, use swift-histomorphism.

## Laws

- Each recursive position of the layer passed to `algebra` holds a `Product` whose `values.0` is that child's auxiliary result and whose `values.1` is that child's own zygomorphism result.
- Both folds run in one bottom-up traversal: at every layer, including the root, `auxiliary` and `algebra` are each called exactly once; the root's auxiliary result is computed and discarded.
- A layer with no recursive positions is passed to `algebra` directly, so a base case folds without consulting `auxiliary` results.
- Children are folded before their parent, by direct recursion: the stack grows with the depth of the value, and nothing is cached between calls.
- The generated method is `public` when the enum is declared `public`, and has default access otherwise.
- Attaching `@Zygomorphism` to anything other than an enum is a compile-time error.
