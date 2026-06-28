#!/bin/bash
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.email "allanrbalsarin@gmail.com"
git config user.name "Allan"
git remote add origin https://github.com/allanrbalsarin-cell/poplar.git
git fetch origin
git checkout main 2>/dev/null || git checkout -b main
git add -A
git commit -m "feat: melhorias de UX - menu mobile, historico, copiar tudo, regenerar, contador de chars, animacao e erros"
git push -u origin main
