import SwiftUI

@MainActor
struct RootView: View {
    @State var productListViewModel = ProductsListViewModel(apiClient: StoreAPIClient())

    var body: some View {
        TabView {
            ProductsListView(viewModel: productListViewModel)
                .tabItem {
                    Label("Produtos", systemImage: "tshirt.fill")
                }

            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                    .foregroundColor(.primary)
                    .bold()
            }
            .padding()
            .tabItem {
                Label("Carrinho", systemImage: "cart.fill")
            }

        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
