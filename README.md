# Desafio de Desenvolvimento

O aplicativo AllShop (Challenge) foi criado com o objetivo de demonstrar decisões arquiteturais.

Neste caso, a aplicação foi elaborada utilizando UIKit, Combine e Async/Await para mostrar como o "mundo moderno" do Swift pode funcionar bem com o velho UIKit. Existe um branch usando o SwiftUI, porém está incompleta devido ao deadline.

A arquitetura escolhida foi MVVM. Adotamos o factory pattern para construção simplificada das cenas MVVM.

A estruturada de pastas do projeto foi definida com a seguinte abstração arquitetural:

## Application
Pasta onde ficam localizados arquivos referentes ao entry point da aplicação (`@main`). Na camada da aplicação, além dos assets, launch screen, e recursos como o Info.plist, fica situado o `AppDelegate`.

## Data
A camada de dados tem uma pasta exclusiva. É ela quem retém todas as entidades (entities ou models) que definem a estrutura e compõem as regras de negócio do aplicativo. Aqui, os models podem encapsular as suas próprias lógicas para evitar duplicação de código. Veja por exemplo a `struct Cart`.

## Extensions
Extensões de classes, structs nativas ou não, devem ser situadas nesta camada de extensões. Cada arquivo indicará o nome da entidade que foi extendida. O objetivo é centralizar recursos comuns e evitar duplicação de código.

## View
É a cada onde todas as cenas, neste caso, MVVM, estão situadas. As factories, os view models e as UIViewControllers estão todas aqui e possuem sua relação bem estabelecida dentro da factory. Neste projeto contamos apenas com duas cenas MVVM. `ProductListing` e `ShoppingCart`

Usamos o combine para compartilhar o estado do carrinho de compras entre a cena ShoppingCart e a cena ProductListing.

# Extras
1. O ícone da aplicação foi criado usando o Midjourney, com o seguinte prompt.

```beautiful iOS application icon for a modern clothes store, color theme: #377D63 (green), #C2D568 (yellowish green) and #FFFFFF (white), modern, futuristic, flat, design, ux, ux/ui, ui, --v 4 --quality 2 --aspect 1:1```

2. As cores foram escolhidas com base na logomarca da empresa (nome não será exposto aqui).