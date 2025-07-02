# EJC Frontend Dashboard

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Gerado pela [Very Good CLI][very_good_cli_link] 🤖

Um Projeto Muito Bom criado pela Very Good CLI.

---
## Visão Geral

Este documento fornece uma visão geral da arquitetura do projeto EJC Frontend Dashboard, juntamente com diretrizes sobre como implementar novas funcionalidades seguindo os padrões estabelecidos.

---

## Arquitetura do Projeto 🏗️

O projeto adota uma arquitetura em camadas, inspirada em princípios de Design Orientado a Domínio (DDD) e MVVM (Model-View-ViewModel), visando promover:

*   **Separação de Responsabilidades (SoC):** Cada camada tem um papel bem definido.
*   **Alta Coesão:** Componentes dentro de uma mesma camada trabalham juntos para um propósito comum.
*   **Baixo Acoplamento:** As camadas dependem de abstrações, não de implementações concretas de outras camadas, facilitando a testabilidade e manutenção.
*   **Testabilidade:** A separação clara facilita a escrita de testes unitários e de integração.

As principais camadas do projeto são:

### 1. Camada de Dados (`lib/app/data`)

Responsável por toda a lógica de acesso e manipulação de dados, seja de fontes externas (API, Firebase, etc.) ou locais (SQLite, SharedPreferences).

*   **`models`**: Contém os modelos de dados brutos (Plain Old Dart Objects - PODOs) que geralmente espelham a estrutura dos dados retornados pelas fontes externas (ex: JSON de uma API). Estes modelos podem incluir métodos `fromJson`/`toJson` para serialização/desserialização.
*   **`repositories`**: Implementações concretas das abstrações de repositório definidas na camada de domínio. Eles coordenam a obtenção de dados dos `services` e podem implementar estratégias de cache ou fallback. São a ponte entre a camada de domínio e as fontes de dados.
*   **`services`**: Classes que lidam diretamente com a comunicação com fontes de dados externas. Por exemplo, um `ApiService` conteria métodos para realizar chamadas HTTP (GET, POST, PUT, DELETE) a um backend.

### 2. Camada de Domínio (`lib/app/domains`)

É o coração da aplicação, contendo a lógica de negócios e as regras que são independentes da UI ou de qualquer tecnologia de acesso a dados.

*   **`entities`**: Representam os objetos de negócio centrais da aplicação. São PODOs que encapsulam os dados e o comportamento essencial da regra de negócio. Diferentemente dos `models` da camada de dados, as `entities` são focadas no domínio e não na forma como os dados são armazenados ou transmitidos.
*   **`repositories` (Abstrações)**: Interfaces (classes abstratas em Dart) que definem os contratos para a obtenção e persistência das `entities`. A camada de domínio depende dessas abstrações, não das implementações concretas da camada de dados.
*   **`usecases` (ou `interactors`)**: Classes que encapsulam uma unidade específica de lógica de negócios. Eles orquestram o fluxo de dados entre as `entities` e os `repositories` para realizar uma tarefa específica (ex: `LoginUserUseCase`, `GetProductListUseCase`). *Nota: Embora não explicitamente visível na estrutura de pastas fornecida, este é um padrão comum em arquiteturas limpas e pode ser introduzido aqui.*
*   **`dtos` (Data Transfer Objects)**: Objetos simples usados para transferir dados entre camadas, especialmente entre a camada de dados e a de domínio ou entre o domínio e o viewmodel. Eles ajudam a desacoplar as camadas, evitando que uma conheça a estrutura interna da outra.
*   **`validators`**: Classes responsáveis por implementar regras de validação de dados específicos do domínio.

### 3. Camada de Apresentação (ViewModel e Views)

Responsável pela interface com o usuário (UI) e pela lógica de apresentação.

*   **`lib/app/viewmodel`**: Contém os ViewModels. No padrão MVVM, o ViewModel atua como um intermediário entre a View (UI) e o Model (que neste caso é a camada de Domínio/Dados).
    *   Ele busca dados dos repositórios (geralmente através de usecases).
    *   Prepara os dados para serem exibidos pela View (formatação, combinação de dados, etc.).
    *   Mantém o estado da View (ex: `isLoading`, `errorMessage`, listas de itens).
    *   Expõe comandos ou métodos que a View pode invocar em resposta a interações do usuário.
    *   Utiliza mecanismos como `ChangeNotifier`, `Streams` (BLoC/Cubit) ou `StateNotifier` (Riverpod) para notificar a View sobre mudanças de estado.

*   **`lib/app/views`**: Contém os componentes da interface do usuário (Widgets no Flutter).
    *   `pages` ou `screens`: Widgets que representam telas inteiras da aplicação.
    *   `components` ou `widgets`: Widgets reutilizáveis que compõem as telas (botões, cards, list items, etc.).
    *   As Views devem ser o mais "passivas" possível, ou seja, devem apenas exibir o estado fornecido pelo ViewModel e delegar todas as ações do usuário para o ViewModel.

### 4. Camada de Utilidades e Compartilhados

*   **`lib/app/shared`**: Contém código que é compartilhado e reutilizado em várias partes da aplicação, mas não pertence a uma camada específica.
    *   Constantes (ex: `AppConstants`).
    *   Temas e estilos (ex: `AppTheme`).
    *   Componentes de UI genéricos e reutilizáveis que não são específicos de uma feature.
    *   Helpers e extensões genéricas.

*   **`lib/app/utils`**: Utilitários diversos que auxiliam em tarefas comuns.
    *   `exceptions`: Classes de exceção personalizadas.
    *   `extensions`: Funções de extensão para classes existentes.
    *   `overlays`: Lógica para exibir pop-ups, snackbars, dialogs.
    *   `provider`: Configuração ou utilitários relacionados ao provedor de estado (se aplicável).
    *   `routes`: Configuração de navegação e rotas da aplicação.

### Fluxo Geral de uma Funcionalidade:

1.  **Interação do Usuário (View)**: O usuário interage com um widget na tela (ex: clica em um botão).
2.  **Ação para ViewModel (View -> ViewModel)**: A View notifica o ViewModel sobre a interação, chamando um método correspondente.
3.  **Lógica de Negócios (ViewModel -> Domain)**:
    *   O ViewModel invoca um `UseCase` (se existir) na camada de Domínio.
    *   O `UseCase` utiliza uma abstração de `Repository` para solicitar dados ou executar uma ação.
4.  **Acesso a Dados (Domain -> Data)**:
    *   A implementação concreta do `Repository` na camada de Dados é acionada.
    *   O `Repository` utiliza um `Service` para buscar/enviar dados de/para uma fonte externa (ex: API).
    *   O `Service` retorna dados brutos (ex: JSON), que são mapeados para `Models` pela camada de Dados.
    *   O `Repository` mapeia os `Models` para `Entities` do Domínio.
5.  **Retorno dos Dados (Data -> Domain -> ViewModel)**:
    *   As `Entities` (ou um resultado encapsulado, como `Either<Failure, SuccessData>`) retornam ao `UseCase` e, subsequentemente, ao ViewModel.
6.  **Atualização do Estado (ViewModel)**: O ViewModel processa os dados recebidos, atualiza seu estado interno e notifica a View sobre as mudanças.
7.  **Reconstrução da UI (View)**: A View reage à mudança de estado no ViewModel e se reconstrói para refletir os novos dados.

Este fluxo garante que a lógica de negócios permaneça isolada e testável, e que a UI seja apenas um reflexo do estado gerenciado pelo ViewModel.

---

## Implementando Novas Funcionalidades 📝

Ao adicionar uma nova funcionalidade, siga os passos abaixo para manter a consistência com a arquitetura do projeto:

1.  **Defina Entidades e Contratos de Repositório (Camada `domains`):**
    *   **Entidades:** Crie as classes de entidade em `lib/app/domains/entities/` que representarão os objetos de negócio da nova funcionalidade. Estas devem ser PODOs focados nos dados e comportamento do domínio.
    *   **Abstrações de Repositório:** Defina a interface (classe abstrata) para o repositório da sua funcionalidade em `lib/app/domains/repositories/`. Este contrato especificará os métodos que a camada de domínio usará para interagir com os dados da funcionalidade (ex: `Future<Either<Failure, List<MyFeatureEntity>>> getFeatureItems();`).
    *   **(Opcional) UseCases:** Se a lógica de negócios for complexa, crie UseCases em `lib/app/domains/usecases/` (crie o diretório se não existir). Cada UseCase deve ter um único propósito e dependerá das abstrações de repositório.

2.  **Implemente a Camada de Dados (`data`):**
    *   **Modelos de Dados:** Se estiver interagindo com uma API, crie os modelos (PODOs com `fromJson`/`toJson`) em `lib/app/data/models/` que correspondem à estrutura da resposta da API.
    *   **Serviços:** Adicione ou atualize um serviço em `lib/app/data/services/` para lidar com a comunicação com a fonte de dados (ex: chamadas HTTP para a API).
    *   **Implementação do Repositório:** Crie a implementação concreta da interface do repositório (definida no passo 1) em `lib/app/data/repositories/`. Esta classe dependerá do serviço correspondente para buscar dados brutos, mapeá-los para os modelos de dados, e então para as entidades de domínio. Lide com o tratamento de exceções e o mapeamento para tipos de `Failure` (se estiver usando `Either`).
        ```dart
        // Exemplo: lib/app/data/repositories/my_feature_repository_impl.dart
        class MyFeatureRepositoryImpl implements MyFeatureRepository {
          final MyFeatureApiService _apiService;

          MyFeatureRepositoryImpl(this._apiService);

          @override
          Future<Either<Failure, List<MyFeatureEntity>>> getFeatureItems() async {
            try {
              final responseModels = await _apiService.fetchItems();
              final entities = responseModels.map((model) => model.toEntity()).toList(); // Supondo um método toEntity() no model
              return Right(entities);
            } on DioError catch (e) { // Exemplo com Dio
              // Logar o erro e retornar um Failure específico
              return Left(ServerFailure(message: e.message ?? 'Erro desconhecido do servidor'));
            } catch (e) {
              return Left(UnexpectedFailure(message: 'Erro inesperado: ${e.toString()}'));
            }
          }
        }
        ```

3.  **Desenvolva o ViewModel (Camada `viewmodel`):**
    *   Crie uma classe ViewModel em `lib/app/viewmodel/nome_da_feature/` (ex: `my_feature_viewmodel.dart`).
    *   Injete as dependências necessárias (geralmente UseCases ou diretamente Repositórios) através do construtor.
    *   Exponha propriedades para o estado da UI (ex: `ValueNotifier<bool> isLoading`, `List<MyFeatureEntity> items`, `String? errorMessage`).
    *   Implemente métodos que serão chamados pela View para disparar ações (ex: `Future<void> fetchItems()`). Estes métodos usarão os UseCases/Repositórios para obter dados e atualizarão o estado do ViewModel.
    *   Utilize `ChangeNotifier` (com `notifyListeners()`) ou outro sistema de gerenciamento de estado (BLoC, Riverpod) para informar a View sobre as mudanças.
        ```dart
        // Exemplo: lib/app/viewmodel/my_feature/my_feature_viewmodel.dart
        class MyFeatureViewModel extends ChangeNotifier {
          final GetMyFeatureItemsUseCase _getMyFeatureItemsUseCase; // Ou MyFeatureRepository

          MyFeatureViewModel(this._getMyFeatureItemsUseCase);

          bool _isLoading = false;
          bool get isLoading => _isLoading;

          List<MyFeatureEntity> _items = [];
          List<MyFeatureEntity> get items => _items;

          String? _error;
          String? get error => _error;

          Future<void> fetchFeatureItems() async {
            _isLoading = true;
            _error = null;
            notifyListeners();

            final result = await _getMyFeatureItemsUseCase.execute(); // Ou _repository.getFeatureItems()
            result.fold(
              (failure) {
                _error = failure.message; // Assumindo que Failure tem uma propriedade message
              },
              (data) {
                _items = data;
              },
            );
            _isLoading = false;
            notifyListeners();
          }
        }
        ```

4.  **Crie as Views (Camada `views`):**
    *   Desenvolva os Widgets Flutter para a UI da funcionalidade em `lib/app/views/nome_da_feature/` (ex: `my_feature_page.dart`, `my_feature_list_item.dart`).
    *   A View deve obter uma instância do ViewModel (via Provider, GetIt, etc.).
    *   Observe as propriedades de estado do ViewModel para reconstruir a UI quando necessário (usando `Consumer`, `ValueListenableBuilder`, `StreamBuilder`, etc.).
    *   Encaminhe as interações do usuário para os métodos do ViewModel.
        ```dart
        // Exemplo: lib/app/views/my_feature/my_feature_page.dart
        class MyFeaturePage extends StatefulWidget { // Ou StatelessWidget se o estado inicial é carregado no initState do ViewModel
          @override
          _MyFeaturePageState createState() => _MyFeaturePageState();
        }

        class _MyFeaturePageState extends State<MyFeaturePage> {
          late final MyFeatureViewModel _viewModel;

          @override
          void initState() {
            super.initState();
            _viewModel = Provider.of<MyFeatureViewModel>(context, listen: false);
            // Disparar o carregamento inicial de dados
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _viewModel.fetchFeatureItems();
            });
          }

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(title: Text('Minha Funcionalidade')),
              body: Consumer<MyFeatureViewModel>( // Ou Selector para otimizar rebuilds
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (vm.error != null) {
                    return Center(child: Text('Erro: ${vm.error}'));
                  }
                  if (vm.items.isEmpty) {
                    return Center(child: Text('Nenhum item encontrado.'));
                  }
                  return ListView.builder(
                    itemCount: vm.items.length,
                    itemBuilder: (context, index) {
                      final item = vm.items[index];
                      return ListTile(title: Text(item.name)); // Supondo que MyFeatureEntity tem 'name'
                    },
                  );
                },
              ),
            );
          }
        }
        ```

5.  **Registro de Dependências:**
    *   Registre suas novas implementações de Repositório, UseCases (se houver) e ViewModels no seu sistema de injeção de dependência (ex: usando `Provider` no `lib/app/app.dart` ou em um arquivo dedicado de DI).
        ```dart
        // Exemplo com Provider em app.dart ou similar
        MultiProvider(
          providers: [
            // ... outros providers
            Provider<MyFeatureApiService>(create: (_) => MyFeatureApiServiceImpl(Dio())), // Exemplo de ApiService
            Provider<MyFeatureRepository>(
              create: (context) => MyFeatureRepositoryImpl(context.read<MyFeatureApiService>()),
            ),
            // Provider para UseCase, se houver
            // Provider<GetMyFeatureItemsUseCase>(
            //   create: (context) => GetMyFeatureItemsUseCase(context.read<MyFeatureRepository>()),
            // ),
            ChangeNotifierProvider<MyFeatureViewModel>(
              create: (context) => MyFeatureViewModel(context.read<MyFeatureRepository>()), // ou context.read<GetMyFeatureItemsUseCase>()
            ),
          ],
          child: MaterialApp(
            // ...
          ),
        )
        ```

6.  **Adicione Rotas:**
    *   Defina as rotas para as novas telas no sistema de gerenciamento de rotas (ex: `lib/app/utils/routes/app_routes.dart` e `app_pages.dart`).

7.  **Escreva Testes:**
    *   **Camada de Domínio:** Testes unitários para UseCases e Entidades.
    *   **Camada de Dados:** Testes unitários para Repositórios (usando mocks para os Serviços) e para os Modelos (testes de `fromJson`/`toJson`).
    *   **Camada de ViewModel:** Testes unitários para ViewModels (usando mocks para UseCases/Repositórios).
    *   **Camada de View:** Testes de Widget para verificar a UI e a interação com o ViewModel.

Seguindo estes passos, você garantirá que a nova funcionalidade se integre de forma coesa e consistente com a arquitetura existente, promovendo um código mais limpo, testável e fácil de manter.

---

## Primeiros Passos 🚀

Este projeto contém 3 sabores (flavors):

- development
- staging
- production

Para executar o sabor desejado, utilize a configuração de inicialização no VSCode/Android Studio ou use os seguintes comandos:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*EJC Frontend Dashboard funciona em iOS, Android, Web e Windows._

---

## Executando Testes 🧪

Para executar todos os testes unitários e de widget, use o seguinte comando:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

Para visualizar o relatório de cobertura gerado, você pode usar o [lcov](https://github.com/linux-test-project/lcov).

```sh
# Gerar Relatório de Cobertura
$ genhtml coverage/lcov.info -o coverage/

# Abrir Relatório de Cobertura
$ open coverage/index.html
```

---

## Trabalhando com Traduções 🌐

Este projeto utiliza [flutter_localizations][flutter_localizations_link] e segue o [guia oficial de internacionalização do Flutter][internationalization_link].

### Adicionando Strings

1. Para adicionar uma nova string localizável, abra o arquivo `app_en.arb` em `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Em seguida, adicione uma nova chave/valor e descrição:

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use a nova string no seu código Dart:

```dart
import 'package:ejc_frontend_dashboard/l10n/l10n.dart'; // Verifique o caminho do import

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adicionando Localidades Suportadas

Atualize o array `CFBundleLocalizations` no arquivo `Info.plist` (localizado em `ios/Runner/Info.plist`) para incluir as novas localidades.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
		<!-- Adicione novas localidades aqui -->
	</array>

    ...
```

### Adicionando Traduções

1. Para cada localidade suportada, adicione um novo arquivo `.arb` no diretório `lib/l10n/arb`. Por exemplo, `app_pt.arb` para português.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   ├── app_es.arb
│   │   └── app_pt.arb
```

2. Adicione as strings traduzidas a cada arquivo `.arb` correspondente:

**`app_en.arb` (Inglês)**
```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

**`app_es.arb` (Espanhol)**
```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

**`app_pt.arb` (Português)**
```arb
{
    "@@locale": "pt",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto exibido na AppBar da Página do Contador"
    }
}
```

### Gerando Traduções

Para aplicar as últimas alterações nas traduções, você precisa gerar os arquivos de localização:

1. Execute o seguinte comando no terminal:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb" --output-dir="lib/l10n"
```
*Nota: O comando `flutter gen-l10n` pode precisar do caminho completo para `app_localizations.dart` se ele não estiver na pasta padrão. Ajuste `output-dir` e `template-arb-file` conforme necessário.*

Alternativamente, executar `flutter run` geralmente aciona a geração de código automaticamente se houver alterações nos arquivos `.arb`.

---
**Links Úteis:**

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://docs.flutter.dev/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
