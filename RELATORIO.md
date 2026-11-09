# RELATORIO — App "Meus Livros" (Flutter)

Opção escolhida: **D) Gerenciar livros lidos/desejados/top5. Compartilhar imagem de ranking.**

## Aula 1 — Estrutura inicial e funcionalidades base

### Tarefas realizadas
- [x] Escolha da ideia (opção D)
- [x] Estrutura do projeto Flutter (models / services / screens / widgets)
- [x] Cadastro, edição e remoção de livros
- [x] Separação em abas: Lidos e Desejados
- [x] Nota de 1 a 5 estrelas para livros lidos
- [x] Tela Top 5 (livros lidos ordenados pela nota)
- [x] Compartilhamento do ranking como imagem (WhatsApp e outros apps)
- [x] Persistência local com shared_preferences

### Prompts utilizados
1. "Consegue fazer isso?" (enviando o enunciado da tarefa) -> análise do que era possível.
2. "Acho que livros" -> geração do projeto completo da opção D.

### Configurações
- Dependências (`pubspec.yaml`):
  - `shared_preferences` — salvar a lista de livros localmente
  - `screenshot` — transformar o widget do ranking em imagem (PNG)
  - `share_plus` — compartilhar a imagem (abre o WhatsApp, etc.)
  - `path_provider` — pasta temporária para salvar o PNG antes de compartilhar
- Para rodar: `flutter pub get` e depois `flutter run`

### Programação
| Arquivo | Função |
|---|---|
| `lib/main.dart` | Ponto de entrada, tema Material 3 |
| `lib/models/book.dart` | Classe `Book` com conversão para/de JSON |
| `lib/services/book_storage.dart` | Ler/gravar livros no shared_preferences |
| `lib/screens/home_screen.dart` | Abas Lidos/Desejados, lista, exclusão por deslize |
| `lib/screens/book_form_screen.dart` | Formulário de criar/editar com validação |
| `lib/screens/top5_screen.dart` | Ranking Top 5 e botão compartilhar |
| `lib/widgets/ranking_card.dart` | Visual do card que vira imagem |

### Problemas encontrados / observações
- Erro "Building with plugins requires symlink support" no Windows: o Modo de Desenvolvedor estava desligado. Solução: rodar no Chrome com `flutter run -d chrome`.

## Próximos passos
- [ ] Testar no celular e anotar erros
- [ ] Capa do livro (foto da galeria)
- [ ] Busca e filtro
- [ ] Melhorar o visual da imagem compartilhada
