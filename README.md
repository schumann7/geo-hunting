# Documentação do Aplicativo Geo Hunting

## Introdução

O **Geo Hunting** é um aplicativo móvel inovador desenvolvido em Flutter, que combina tecnologia de geolocalização (GPS) com a diversão clássica de jogos de caça ao tesouro. O objetivo principal é permitir que usuários busquem "tesouros" cadastrados previamente por amigos ou outros jogadores, podendo ser jogado individualmente ou em grupos. Ideal para atividades sociais e recreativas, o app transforma o mundo real em um campo de jogo interativo.

Este projeto foi criado como parte da disciplina de **DSDM (Desenvolvimento de Sistemas Distribuídos e Móveis)**, focando no uso de GPS para criar experiências imersivas. O repositório está disponível no GitHub: [https://github.com/schumann7/geo-hunting](https://github.com/schumann7/geo-hunting).

## Funcionalidades Principais

- **Criação e Junção de Salas**: Usuários podem criar salas de jogo informando o nome, localização do tesouro e uma senha opcional. Outros jogadores podem se juntar à sala para participar da caça.
- **Mapa Interativo**: Exibição de um mapa com marcadores (pins) para indicar posições relevantes, como a localização do tesouro.
- **Bússola Integrada**: Durante a busca, uma bússola no canto inferior esquerdo da tela guia o jogador na direção correta, calculando ângulos baseados em coordenadas GPS.
- **Pop-ups Informativos**: Notificações para calibração da bússola ao entrar em uma sala e anúncio de vitória ao alcançar o tesouro, incluindo estatísticas como tempo gasto e distância percorrida.
- **Suporte a GPS**: Requer dispositivos móveis com acesso a GPS para rastreamento em tempo real.
- **Modo de Jogo Básico**: Focado em caça ao tesouro solo ou em grupo, com potencial para expansões futuras.

## Requisitos

### Hardware
- Dispositivo móvel (Android ou iOS) com suporte a GPS e bússola.
- Conexão à internet para carregar mapas (via TileLayer).

### Software
- **Flutter**: Versão compatível (recomenda-se a mais recente estável, como 3.29.0 ou superior). Certifique-se de que o ambiente Flutter esteja configurado corretamente.
- **Bibliotecas Necessárias**:
  - `flutter_map`: Para renderização de mapas.
  - Outras bibliotecas: `geolocator` para GPS, `latlong` para obter e manipular coordenadas de latitude e longitude, `flutter_compass` para bússola e `sqflite` para o banco de dados local (responsável pelo histórico).
  - Instale todas as dependências listadas no `pubspec.yaml` rodando o comando `flutter pub get` no terminal.

### Ambiente de Desenvolvimento
- Flutter SDK instalado.
- Android Studio ou Xcode para emuladores/dispositivos reais.
- Acesso a um emulador ou dispositivo físico com GPS ativado.

## Instalação

1. **Clone o Repositório**:
   ```bash
   git clone https://github.com/schumann7/geo-hunting.git
   cd geo-hunting
   ```

2. **Instale Dependências**:
   Execute o comando para baixar as bibliotecas necessárias:
   ```bash
   flutter pub get
   ```

3. **Configure o Ambiente**:
   - Certifique-se de que o Flutter está na PATH do sistema.
   - Para Android: Configure o `android/build.gradle` e `android/app/build.gradle` se necessário.
   - Para iOS: Atualize o `Podfile` e execute `pod install` na pasta `ios/`.

4. **Permissões**:
   - No arquivo `AndroidManifest.xml` (para Android): Adicione permissões para localização (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`).
   - No `Info.plist` (para iOS): Adicione chaves para localização (`NSLocationWhenInUseUsageDescription`).

## Como Executar

1. Abra o projeto em um editor como VS Code ou Android Studio.
2. Navegue até o arquivo `lib/main.dart`.
3. Selecione um dispositivo móvel (emulador ou físico) com GPS ativado.
4. Execute o app com:
   ```bash
   flutter run
   ```
5. Na tela principal:
   - **Criar Sala**: Informe o nome da sala, defina a localização do tesouro (via toque no mapa) e opte por uma senha.
   - **Juntar-se a uma Sala**: Insira o nome da sala e senha (se aplicável) para participar.
6. Convide amigos para entrar na sessão e iniciar a caça ao tesouro.

**Notas**:
- Ao entrar em uma sala, um pop-up solicitará a calibração da bússola.
- Durante o jogo, use a bússola para orientação e o mapa para navegação.
- Ao alcançar o tesouro, um pop-up exibirá o tempo de busca e distância percorrida.

## Widgets Principais

### FlutterMap
- **Biblioteca**: `flutter_map`.
- **Uso**: Renderiza o mapa base do jogo.
- **Parâmetros Principais**:
  - `center`: Centraliza o mapa em coordenadas específicas.
  - `zoom`: Define o nível de zoom inicial.
  - `onTap`: Ação ao clicar no mapa (ex: definir localização do tesouro).
  - `onMapReady`: Ação ao inicializar o mapa.
- **Children**:
  - `TileLayer`: Carrega tiles de mapa (ex: de OpenStreetMap).
  - `MarkerLayer`: Adiciona marcadores (pins) para tesouros ou posições de jogadores.
- **Localização**: `teste.dart`.

### PopupCard
- **Uso**: Gerencia pop-ups no app.
- **Ocasiões**:
  - Lembrete de calibração da bússola ao entrar em uma sala.
  - Anúncio de fim de jogo, com confirmação de sucesso, tempo e distância.
- **Parâmetros**:
  - `color`: Cor de fundo.
  - `shape`: Formato do card.
  - `elevation`: Sombra/elevação.
  - `child`: Conteúdo interno (texto, botões).

### CompassWidget
- **Uso**: Exibe uma bússola durante a caça ao tesouro (canto inferior esquerdo).
- **Funcionamento**: Recebe latitude/longitude do usuário e do tesouro, calcula direção via fórmulas matemáticas (ex: atan2 para ângulos).
- **Exibição**: Graus no centro + ponteiro apontando para o tesouro.

## Uso Avançado

- **Criação de Tesouro**: Toque no mapa para selecionar coordenadas.
- **Multiplayer Básico**: Compartilhe o nome da sala para que outros entrem (não há modo competitivo simultâneo ainda).
- **Debugging**: Use `flutter doctor` para verificar o ambiente. Monitore logs para erros de GPS.

## Possíveis Melhorias e Trabalho Futuro

- **Modo Multiplayer Avançado**: Permitir que múltiplos jogadores busquem o mesmo tesouro simultaneamente, com leaderboard em tempo real.
- **Modo Pega-Pega**: Dividir em times (caçadores vs. fugitivos), usando GPS para rastreamento dinâmico.
- **Sistema de Contas**: Implementar login/cadastro para gerenciar salas (ex: deletar salas próprias) e perfis de usuários.
- **Outras Ideias**:
  - Integração com AR (Realidade Aumentada) para visualização do tesouro.
  - Suporte offline com mapas cached.
  - Notificações push para atualizações de jogo.
  - Expansão para web/desktop via Flutter multi-plataforma.

## Créditos

- [Álvaro Schenatto](https://github.com/aaschenatto)
- [Gabriel Schumann](https://github.com/schumann7)
- [Rômulo Horn](https://github.com/Romulooo)
- [João Peruzzo](https://github.com/SoJoaomesmo)