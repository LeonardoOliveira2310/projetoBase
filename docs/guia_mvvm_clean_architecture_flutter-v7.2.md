# Guia Completo: Flutter + MVVM + Clean Architecture (v7.2)

## Histórico de Versões
* **v1.0 - v3.0:** Estruturação de pastas (`domain`, `data`, `ui`, `di`), Login com E-mail/Senha e Google, `CrashlyticsAuthObserver` e `main.dart` limpa.
* **v4.0 - v4.2:** `HomePage`, `CustomDrawer` com botão Sair fixo no rodapé, definição do uso exclusivo de **Cloud Firestore** (sem banco local separado) e padrão de modelos (`Entity` + `Model`).
* **v5.0:** Tela de Cadastro (`RegistroUsuarioPage` / `RegistroUsuarioViewModel` / `RegistroUsuarioFactory`), `UsuarioEntity` unificada, `UsuarioModel` (`toMap`/`fromMap`) e integração com **Cloud Firestore**.
* **v5.1:** Configuração de variáveis de ambiente com **`flutter_dotenv` (`.env`)** isolando as chaves do `firebase_options.dart`, ajuste visual do separador `--- ou ---` na `PaginaLogin` e regras de segurança do Firestore.
* **v6.0:** **Tema Dinâmico** (Claro / Escuro / Sistema) persistido com `SharedPreferences`, `AppTemaConfig` com cores/fontes por ambiente (`dev` e `prod`), seletor de tema no `CustomDrawer`, reorganização de `domain/usecases` por subpastas e limitação de caracteres (`maxLength` + `.trim()`) nos formulários.
* **v7.0 - v7.1:** **Flavors Android (`dev` e `prod`)** no `build.gradle.kts`, arquivos `.env.dev` e `.env.prod` (com `EMPRESA_ID` para arquitetura Multi-Tenant), `google-services.json` separados por pasta, pontos de entrada `main_dev.dart`/`main_prod.dart`/`main_common.dart`, permissão `INTERNET` no `AndroidManifest.xml` e perfis no `.vscode/launch.json`.
* **v7.2 (Atual):** **Recuperação de Senha** (`RecuperarSenhaUseCase`), prevenção de *overflow* de teclado na `PaginaLogin` (`SafeArea` + `Center` + `SingleChildScrollView`) e criação do padrão **`actions/`** (`LoginActions`) na camada `UI` para isolar diálogos e fluxos de interação.

## Roadmap de Evolução
* **v7.2 (Atual):** Template Base Concluído — Autenticação completa (com recuperação de senha), Tema Dinâmico, Flavors (`dev` / `prod`), Multi-Tenant (`EMPRESA_ID`) e padrão `actions/`.
* **v8.0 (Próxima):** Clonagem do Template Base para os projetos comerciais (Supermercado, Delivery, PDV/Agenda) e criação dos módulos de **Clientes**, **Fornecedores** e **Painel Administrativo** (Mobile + Windows).

---

## 1. Estrutura de Pastas do Projeto

```text
├── .env.dev
├── .env.prod
├── .env.example
├── .vscode/
│   └── launch.json
├── android/app/src/
│   ├── dev/
│   │   └── google-services.json
│   └── prod/
│       └── google-services.json
├── docs/
│   └── guia_mvvm_clean_architecture_flutter-v7.2.md
lib/
├── data/
│   ├── models/
│   │   └── usuario_model.dart
│   ├── repositories/
│   │   ├── auth_repository_impl.dart
│   │   ├── tema_repository_impl.dart
│   │   └── usuario_repository_impl.dart
│   └── services/
│       └── crashlytics_auth_observer.dart
├── di/
│   └── factories/
│       ├── home_factory.dart
│       ├── login_factory.dart
│       └── registro_usuario_factory.dart
├── domain/
│   ├── entities/
│   │   ├── tema_modo_enum.dart
│   │   └── usuario_entity.dart
│   ├── exceptions/
│   │   └── auth_exceptions.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── tema_repository.dart
│   │   └── usuario_repository.dart
│   └── usecases/
│       ├── login/
│       │   ├── login_email_usecase.dart
│       │   ├── login_google_usecase.dart
│       │   ├── logout_usecase.dart
│       │   └── recuperar_senha_usecase.dart
│       ├── tema/
│       │   ├── obter_tema_usecase.dart
│       │   └── salvar_tema_usecase.dart
│       └── usuario/
│           ├── cadastrar_usuario_usecase.dart
│           └── obter_usuario_usecase.dart
├── ui/
│   ├── core/
│   │   └── temas/
│   │       ├── tema_config.dart
│   │       └── tema_view_model.dart
│   ├── home/
│   │   ├── view_model/
│   │   │   └── home_view_model.dart
│   │   ├── widgets/
│   │   │   └── custom_drawer.dart
│   │   └── home.dart
│   ├── pagina_login/
│   │   ├── actions/
│   │   │   └── login_actions.dart
│   │   ├── view_model/
│   │   │   └── login_view_model.dart
│   │   └── pagina_login.dart
│   └── registro_usuario/
│       ├── view_model/
│       │   └── registro_usuario_view_model.dart
│       └── registro_usuario_page.dart
├── firebase_options.dart
├── main_common.dart
├── main_dev.dart
└── main_prod.dart
```

---

## 2. Regras de Ouro da Arquitetura

### Ordem de Criação das Camadas (De Dentro para Fora)
Na Clean Architecture, o **`Domain`** é o centro do sistema. Ele não depende de nenhuma outra camada, mas todas as outras camadas dependem dele. Qualquer nova funcionalidade deve ser construída seguindo esta sequência:

1. **`Domain` (Primeiro):** Define o modelo puro (`Entity`), o contrato do que precisa ser salvo ou buscado (`Repository`) e a regra de negócio (`UseCase`). Por ser Dart puro, permite validar a lógica sem depender de tela ou banco de dados.
2. **`Data` (Segundo):** Com o contrato do `Domain` pronto, implementa a conexão real com o banco (`Model` com `toMap()`/`fromMap()` e `RepositoryImpl` gravando no Cloud Firestore).
3. **`UI` (Terceiro):** Com a regra e o banco prontos, cria o `ViewModel` (chamando os `UseCases`), a classe `Actions` (para diálogos e navegação) e desenha a `Page` (widgets visuais).
4. **`DI` (Por último):** Cria a `Factory` para instanciar e conectar todas as peças construídas e registra a nova rota no `main_common.dart`.

### Princípios Inegociáveis
* **Isolamento:** O `Domain` nunca importa `flutter` ou `firebase`. A `UI` nunca importa `firebase`.
* **Sem `BuildContext` no ViewModel:** Navegação (`Navigator`) e diálogos (`AlertDialog`) ficam exclusivamente na camada `UI` (`Page` e `Actions`).
* **Modelos Enxutos:** Use `Entity` no `Domain` e `Model` (`toMap`/`fromMap`) no `Data`.
* **Banco de Dados Único:** Use apenas o **Cloud Firestore**, aproveitando seu cache e sincronização offline nativos.

---

## 3. Pontos Importantes

### Variáveis de Ambiente com `.env` (v5.1)
* **Por que fizemos:** Evita expor chaves sensíveis do Firebase no repositório Git e permite alternar facilmente entre ambientes (`dev` e `prod`).
* **Como funciona:** Carregado na `iniciarApp()` (`main_common.dart`) **antes** do `Firebase.initializeApp()` e lido via `dotenv.env['CHAVE']!` no `firebase_options.dart`.

### Regras de Segurança e Blindagem (v5.1 - v6.0)
* **Firestore:** Acesso restrito por usuário autenticado (`allow read, write: if request.auth != null && request.auth.uid == userId;` na coleção `usuarios`).
* **Formulários:** Uso de `maxLength` + `counterText: ''` nos campos de texto e `.trim()` nos controllers para evitar dados sujos ou estouro de documento.

### Tema Dinâmico e Identidade por Ambiente (v6.0 - v7.1)
* **Por que fizemos:** Permite alternar entre Claro, Escuro e Sistema (salvo via `shared_preferences`) e diferencia visualmente `dev` (Laranja) e `prod` (Roxo) pintando inclusive a `AppBar` (`appBarTheme` usando `scheme.primary` no claro e `scheme.primaryContainer` no escuro).
* **Instância Única:** O `TemaViewModel` é instanciado em `main_common.dart` (antes do `runApp` junto com `CrashlyticsAuthObserver.iniciar()`) e repassado via `HomeFactory.create(temaViewModel)`.

### Flavors (`dev` e `prod`), Release e Multi-Tenant (v7.0 - v7.1)
* **Android (`android/app/build.gradle.kts`):** `flavorDimensions += "ambiente"` com `productFlavors` `dev` (`applicationIdSuffix = ".dev"`, nome `"Exemplo Firebase DEV"`) e `prod` (nome `"Exemplo Firebase"`).
* **Permissão de Internet:** Declarar `<uses-permission android:name="android.permission.INTERNET" />` em `android/app/src/main/AndroidManifest.xml` para garantir funcionamento do Firebase em builds de Release.
* **Isolamento de Banco e Multi-Tenant (`EMPRESA_ID`):** Cada ambiente possui seu `.env` e `google-services.json` (`android/app/src/dev/` e `prod/`). Em projetos comerciais, recomenda-se apontar `dev` e `prod` para projetos Firebase distintos e usar a chave `EMPRESA_ID` do `.env` para isolar dados de múltiplos clientes em subcoleções `empresas/{empresaId}/...`.
* **Cotas Firebase (Plano Spark):** Permite cerca de 5 a 10 projetos gratuitos por Conta Google e até 30 apps por projeto.

### Padrão `Actions` na Camada UI e Layout Responsivo (v7.2)
* **Padrão `actions/` (`lib/ui/pagina_login/actions/login_actions.dart`):** Centraliza métodos estáticos que recebem `BuildContext` e o `ViewModel` para disparar `showDialog` e `Navigator`, mantendo a `Page` curta e focada apenas na árvore de widgets.
* **Prevenção de Overflow:** Telas com formulários (como `PaginaLogin`) devem envolver a `Column` em `SafeArea` + `Center` + `SingleChildScrollView` para evitar erro de *bottom overflow* quando o teclado virtual abrir.

---

## 4. Checklist Rápido ao Clonar para um Novo Projeto

Sempre que clonar este repositório (**Template Base v7.2**) para iniciar um novo produto (Supermercado, Delivery ou PDV/Agenda), siga estes **5 passos**:

1. **Renomear o Projeto e o Pacote (Bundle ID):**
   * Use `rename` (`dart pub global activate rename`) para alterar o nome (`rename setAppName --value "Nome do App"`) e o pacote oficial (`rename setBundleId --value "br.com.suaempresa.novoapp"`).
   * Atualize os nomes dos flavors `dev` e `prod` em `android/app/build.gradle.kts` (`resValue("string", "app_name", ...)`).

2. **Configurar Firebase, Permissão e `.env`:**
   * Crie o projeto Firebase do novo produto e baixe os `google-services.json` para `android/app/src/dev/` (pacote `.dev`) e `android/app/src/prod/` (pacote oficial), cadastrando o certificado **SHA-1**.
   * Confirme `<uses-permission android:name="android.permission.INTERNET" />` no `AndroidManifest.xml`.
   * Preencha `.env.dev` e `.env.prod` com as novas chaves e o `EMPRESA_ID`.

3. **Ajustar Identidade Visual (`AppTemaConfig`):**
   * Em `lib/ui/core/temas/tema_config.dart`, defina a `corPrimaria` e a `fontFamily` oficiais do novo produto.

4. **Configurar Regras de Segurança no Firestore:**
   * No Console do Firebase do novo projeto, publique as regras de acesso para `usuarios/{userId}` e para as coleções/subcoleções do negócio (`empresas/{empresaId}/...`).

5. **Construir os Módulos Específicos (De Dentro para Fora):**
   * Crie cada nova funcionalidade seguindo rigorosamente a ordem **`Domain` -> `Data` -> `UI` (`ViewModel` -> `Actions` -> `Page`) -> `DI`**.
