<div align="center">
  <h1>The Makita Verse</h1>

  <p align="center">
    <a href="https://www.python.org/"><img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"></a>
    <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
    <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
    <a href="https://github.com/features/actions"><img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white" alt="GitHub Actions"></a>
    <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="License">
  </p>
  <p align="center">Centralizando e mapeando o universo de conteúdos do Fabio Akita.</p>
</div>

---

## 🎯 Objetivo

Este projeto tem como principal objetivo realizar o **DUMP** de diversas fontes de informações referentes à pessoa Fabio Akita. A coleta de conteúdo (artigos do blog, podcasts e vídeos) é realizada utilizando um crawler construído em **Python**, que roda de forma contínua por meio de um agendamento (cron) do **Github Actions**.

Os dados atualizados ficam disponíveis e são salvos como arquivos JSON dentro do diretório estático `/data`, que por sua vez é consumido de forma assíncrona pela nossa **aplicação móvel e web desenvolvida com Flutter**.

---

## 🏗️ Estrutura do Projeto

A arquitetura se organiza em ecossistemas isolados atuando em conjunto:

- `clients/`: Workspace Dart/Flutter englobando a aplicação principal.
- `data/`: Diretório de armazenamento central (fonte de verdade) onde residem os dados estruturados pelo crawler em formato JSON (ex: `articles/`, `podcasts/`, `channel/`).
- `scripts/`: O coração da extração, abrigando todo o código fonte do Crawler.
- `.github/workflows/`: Repositório destinado a salvar as rotinas de jobs e esteiras de CI/CD.

---

## ⚙️ Como Funciona

O repositório automatiza a extração e a compilação por meio de **dois workflows** essenciais:

1. **Dump Newsletter (`dump_newsletter.yml`)**  
   Atua executando um _cronjob_ diariamente (`0 0 * * *`) que aciona a raspar os dados de novos conteúdos. Caso existam, o script é finalizado comitendo as atualizações de forma autônoma na base `/data`. Em vez das aplicações requisitarem diretamente das fontes (gerando lentidão e rate-limit), elas agem lendo apenas esses estáticos previamente extraídos.
2. **Build and Deploy Mobile (`build_mobile_release.yml`)**  
   Sempre que modificações robustas chegam à branch `release`, a integração aciona o build para o ambiente Android. Após a finalização, ela automaticamente vincula o `APK` assinado do aplicativo a uma nova Release aqui no próprio Github.

---

## 🛠️ Quais Tecnologias

A stack de ferramentas foi escolhida para atuar diretamente nas demandas de extração intensiva e flexibilidade cross-platform no projeto final. Separamos abaixo suas responsabilidades:

### 🐍 Scripts (Crawler e Extração)

- **[![Python Badge](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)**: Motor por de trás de toda a raspagem.
- **`requests` & `beautifulsoup4`**: Requisições de rede e extração semântica para buscar postagens e metadados no blog ou em catálogos de podcasts.
- **`yt-dlp`**: Integração minuciosa para raspar informações brutas das playlists e dos canais associados no YouTube sem precisar autenticação na Data API oficial limitante.

### 📱 Frontend (App Mobile e Web)

- **[![Dart Badge](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev/)[![Flutter Badge](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)**: Construção moderna de UI que roda sem engasgos nos dispostivos alvo.
- **Workspaces Architecture**: Para lidar com a escala do projeto, o projeto em Dart atua em moldes de Mono-Repo.
  - `apps/mobile`: Compilação direcionada as aplicações instaladas no Android/iOS.
  - `apps/web`: Deploy otimizado destinado para a visualização na web pura.
  - `packages/core`: Base sólida abstraindo utilitários e os parsers do repositório `/data` de forma agnóstica para qualquer client.

---

## 🧪 Como Testar

Para checar os serviços localmente no seu escopo, execute os direcionais abaixo.

### Testar a Extração de Dados (Scripts Python)

É preferível o isolamento do motor utilizando um virtual environment (venv) para evitar sujeiras de dependências.

```bash
cd scripts
python3 -m venv venv
source venv/bin/activate  # Ambiente Windows: venv\Scripts\activate
pip install -r requirements.txt
```

Finalizada a instalação, invoque o `main.py` repassando diretamente o escopo que deseja re-extrair e testar:

```bash
# Para coletar os Artigos do blog principal
python main.py --target articles

# Para coletar as informações dos Podcasts
python main.py --target podcasts

# Para coletar metadados do Canal de Vídeos (Youtube)
python main.py --target videos
```

### Testar o Aplicativo (Frontend Flutter)

Assegure-se de que dispões do SDK do [Flutter configurado no Path](https://docs.flutter.dev/get-started/install) e com o emulador ligado.

```bash
cd clients/apps/mobile
flutter pub get
flutter run
```

---

## 📱 Telas do Aplicativo

<table align="center">
  <tr>
    <td align="center"><img src="screens/screen1.jpeg" width="250"></td>
    <td align="center"><img src="screens/screen6.jpeg" width="250"></td>
    <td align="center"><img src="screens/screen3.jpeg" width="250"></td>
    <td align="center"><img src="screens/screen2.jpeg" width="250"></td>
    <td align="center"><img src="screens/screen5.jpeg" width="250"></td>
  </tr>
</table>

---

## 🤝 Como Contribuir

Qualquer feedback ou PR para somar nos crawlers ou nas animações do aplicativo são hiper bem-vindos!

1. Realize um **Fork** do escopo no seu github original;
2. Crie a sua **Branch** isolada (`git checkout -b feature/sua_maravilhosa_contribuicao`);
3. Faça os **Commits** pertinentes, visando uma mensagem clara (`git commit -m 'feat: alterado lógica main do yt-dlp'`);
4. Empurre a alteração com um **Push** pra a branch recifrada (`git push origin feature/sua_maravilhosa_contribuicao`);
5. Submeta na nossa aba um **Pull Request**.
