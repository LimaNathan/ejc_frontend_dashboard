#!/bin/bash

# Baixa o Flutter
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Configura o Flutter para web
flutter channel stable
flutter upgrade
flutter config --enable-web

# Instala as dependências e faz o build
flutter pub get
flutter build web --release

# Copia os arquivos para o diretório que a Vercel espera
mkdir -p build/web/assets
cp -r assets/* build/web/assets/