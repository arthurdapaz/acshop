import SwiftUI

@MainActor
struct ProductsListView: View {
    @ObservedObject var viewModel: ProductsListViewModel

    var body: some View {
        List(viewModel.products) { product in
            NavigationLink(destination: ProductDetailView(product: product)) {
                ProductCell(product: product)
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

struct ProductCell: View {
    let product: Product

    var body: some View {
        VStack {
            if !product.image.isEmpty {
                AsyncImage(url: URL(string: product.image)!)
                    .scaledToFit()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)

                Text(product.actualPrice)
                    .font(.subheadline)

                HStack {
                    Text(product.onSale ? "Em promoção" : "Sem promoção")
                        .foregroundColor(product.onSale ? .green : .black)

                    if product.onSale {
                        Text(product.regularPrice)
                            .font(.footnote)
                            .strikethrough()
                            .foregroundColor(.red)

                        Text(product.discountPercentage)
                            .font(.footnote)
                            .foregroundColor(.green)
                    }
                }

                Text("Tamanhos disponíveis: \(product.sizes.filter { $0.available }.map { $0.size }.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Button(action: {
                print(product)
            }) {
                Label("Adicionar", image: "cart.badge.plus")
                    .background(in: Rectangle(), fillStyle: FillStyle())

            }.padding(30)

            Spacer().padding(30)
        }
    }
}




struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProductsListViewModel(apiClient: StoreAPIClient())
        return ProductsListView(viewModel: viewModel)
    }
}
