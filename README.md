# Flutter Clean Architecture + MVVM + Firebase (Template Base)

Projeto base estruturado para aplicações escaláveis em Flutter, aplicando **Clean Architecture**, padrão **MVVM** reativo nativo (`ChangeNotifier` + `ListenableBuilder`), **Firebase** e múltiplos ambientes (**Flavors**).

## Recursos Implementados

* **Arquitetura Desacoplada:** Separação estrita entre `Domain` (Dart puro), `Data`, `UI` (com suporte a `actions/` para diálogos e fluxos de tela) e `DI` (Factories), construída sempre de dentro para fora.
* **Autenticação Completa:**
  * Login com E-mail e Senha (com bloqueio e disparo de verificação de e-mail).
  * Recuperação de senha via e-mail (`RecuperarSenhaUseCase`).
  * Login com Google (`GoogleSignIn`).
  * Cadastro completo de usuário gravando perfil no **Cloud Firestore**.
* **Observabilidade e Segurança:**
  * Monitoramento de falhas com **Firebase Crashlytics** vinculado automaticamente ao usuário logado (`CrashlyticsAuthObserver`).
  * Regras de segurança no Cloud Firestore restritas ao usuário autenticado.
  * Limitação de caracteres (`maxLength`) e sanitização (`.trim()`) nos formulários.
  * Chaves isoladas em arquivos `.env` (`flutter_dotenv`).
* **Tema Dinâmico:** Alternância entre modo **Claro**, **Escuro** e **Sistema** persistida localmente via `SharedPreferences`, com paletas e fontes configuráveis por ambiente (`dev` e `prod`).
* **Multi-Ambiente (Flavors):** Separação nativa no Android (`dev` e `prod`) e suporte preparado para arquitetura Multi-Tenant (`EMPRESA_ID`).

## Estrutura de Pastas

```text
├── .env.example
├── docs/
│   └── guia_mvvm_clean_architecture_flutter-v7.2.md
└── lib/
    ├── data/
    │   ├── models/
    │   ├── repositories/
    │   └── services/
    ├── di/
    │   └── factories/
    ├── domain/
    │   ├── entities/
    │   ├── exceptions/
    │   ├── repositories/
    │   └── usecases/
    │       ├── login/
    │       ├── tema/
    │       └── usuario/
    ├── ui/
    │   ├── core/temas/
    │   ├── home/
    │   ├── pagina_login/
    │   │   ├── actions/
    │   │   └── view_model/
    │   └── registro_usuario/
    ├── firebase_options.dart
    ├── main_common.dart
    ├── main_dev.dart
    └── main_prod.dart
```

## Como Rodar o Projeto

1. **Clone o repositório e instale as dependências:**
   ```bash
   git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
   cd SEU_REPOSITORIO
   flutter pub get
   ```

2. **Configure as variáveis de ambiente:**
   * Duplique o arquivo `.env.example` criando `.env.dev` e `.env.prod` na raiz e preencha com as chaves do seu projeto Firebase.
   * Adicione os arquivos `google-services.json` correspondentes em `android/app/src/dev/` e `android/app/src/prod/`.

3. **Configure as Regras de Segurança no Cloud Firestore:**
   * No Console do Firebase, acesse **Firestore Database > Regras** e publique a regra abaixo para restringir leitura e escrita ao próprio usuário autenticado:
   ```javascript
   rules_version = '2';

   service cloud.firestore {
     match /databases/{database}/documents {
       match /usuarios/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

4. **Execute no ambiente desejado:**
   ```bash
   # Ambiente de Desenvolvimento
   flutter run --flavor dev -t lib/main_dev.dart

   # Ambiente de Produção
   flutter run --flavor prod -t lib/main_prod.dart
   ```

## Documentação Completa

Consulte o guia detalhado da arquitetura, regras de ouro, checklist de clonagem e histórico completo de evolução em [`docs/guia_mvvm_clean_architecture_flutter-v7.2.md`](docs/guia_mvvm_clean_architecture_flutter-v7.2.md).
