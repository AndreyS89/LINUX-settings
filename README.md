# 🛠️ My Dotfiles

Мои персональные настройки конфигурации для разработки (Development Environment).
Здесь хранится "фундамент" моей рабочей среды: редактор, терминал и оболочка.

![Screenshot placeholder](https://via.placeholder.com/800x400?text=Place+Your+Screenshot+Here)
*(Сюда можно будет добавить скриншот твоего Neovim/Tmux)*

## 📂 Содержимое

| Компонент | Путь в репо | Описание |
| :--- | :--- | :--- |
| **Neovim** | `nvim/` | Полноценная IDE для React/JS (Lua config, LSP, Prettier) |
| **Tmux** | `tmux.conf` | Мультиплексор терминала |
| **ZSH** | `zshrc` | Настройки оболочки (Oh My Zsh, алиасы) |

---

## 🚀 Развертывание на новой машине

### 1. Подготовка (Prerequisites)
Перед установкой конфигов убедись, что установлены базовые программы:

- **Git & Curl:** `sudo apt install git curl`
- **ZSH:** `sudo apt install zsh`
- **Neovim (v0.9+):** [Инструкция по установке](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- **Tmux:** `sudo apt install tmux`
- **Node.js & npm:** (Обязательно для работы LSP и Prettier в Neovim)
- **Шрифт:** [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)

### 2. Клонирование репозитория
Скачай этот репозиторий в домашнюю папку:

```bash
git clone [https://github.com/AndreyS89/LINUX-settings.git](https://github.com/AndreyS89/LINUX-settings.git) ~/dotfiles
