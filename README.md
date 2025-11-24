## Содержимое
- Neovim: `nvim/`
- tmux: `tmux.conf`
- ZSH: `zshrc`

1. Как скачать репозиторий
text
## Скачивание dotfiles

1. Клонируй репозиторий:
git clone https://github.com/имя/dotfiles.git ~/dotfiles

text
undefined
2. Как применить настройки
Вариант 1: Копировать вручную

text
## Как применить настройки

- Neovim:
cp -r ~/dotfiles/nvim ~/.config/nvim

text

- tmux:
cp ~/dotfiles/tmux.conf ~/.tmux.conf

text

- ZSH:
cp ~/dotfiles/zshrc ~/.zshrc

text
undefined
Вариант 2: Символические ссылки (symlink) — удобно, если хочешь хранить оригиналы только в dotfiles и пользоваться одними файлами

text
## Альтернативный вариант — создать symlink

- Neovim:
ln -sf ~/dotfiles/nvim ~/.config/nvim

text

- tmux:
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

text

- ZSH:
ln -sf ~/dotfiles/zshrc ~/.zshrc

text
undefined
3. Зависимости
text
## Необходимые программы

- Neovim
- tmux
- zsh
(если используешь дополнительные утилиты, плагины — перечисли их)

4. Как добавить новые настройки
text
## Как добавить новый конфиг

- Скопируй нужный файл в папку dotfiles.
- Сделай commit и push:
git add .
git commit -m "Добавил настройки для ..."
git push

text
undefined
5. Полезные советы
При первых запусках новых конфигов проверь, что все пути и плагины установлены.

На новом ПК плагины надо снова установить (через менеджер плагинов: Lazy, Packer, и т.д.).


