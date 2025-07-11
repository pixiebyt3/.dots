
SUDO = sudo
LN = ln -sfv
MKDIR = mkdir -p

# Directory where your dotfiles are stored
DOTFILES_DIR := $(CURDIR)

# Variables to perform check of system
OS_RELEASE_FILE := $(shell ls /etc/os-release 2>/dev/null)
IS_ARCH := $(shell grep -q "^ID=arch" /etc/os-release && echo "true" || echo "false" 2>/dev/null)

$(info Starting processing Makefile..)

ifneq ($(OS_RELEASE_FILE),/etc/os-release)
	$(error ✖ Could not determine Linux distro)
endif

ifneq ($(IS_ARCH),true)
	$(error ✖ Those dotfiles are for Arch-users only)
endif



$(info ✔ Linux distro detected)
$(info ✔ by the way.. You are using Arch)

## ----------------------------

# Setting up targets
.PHONY: all bash zsh starship hyfetch git plocate pkgfile vscode reflector pacman-conf pacman-mirrorlist makepkg

all: bash zsh starship hyfetch git plocate pkgfile vscode reflector pacman-conf pacman-mirrorlist makepkg

ifeq ($(shell pacman -Q bash 2>/dev/null),)
	$(error bash not installed but needed)
endif

ifeq ($(shell pacman -Q git 2>/dev/null),)
	$(error git not installed but needed)
endif

ifeq ($(shell pacman -Q zsh 2>/dev/null),)
	$(error zsh not installed but needed)
endif

ifeq ($(shell pacman -Q zsh-completions 2>/dev/null),)
	$(warning zsh-completions not installed but recommended)
endif

ifeq ($(shell pacman -Q zsh-autocomplete 2>/dev/null),)
	$(warning zsh-autocomplete not installed but recommended)
endif

ifeq ($(shell pacman -Q zsh-syntax-highlighting 2>/dev/null),)
	$(warning zsh-syntax-highlighting not installed but recommended)
endif

ifeq ($(shell pacman -Q tree 2>/dev/null),)
	$(warning tree not installed but recommended)
endif

ifeq ($(shell which starship 2>/dev/null),)
	$(error starship not installed but needed)
endif

ifeq ($(shell which hyfetch 2>/dev/null),)
	$(warning hyfetch not installed but recommended)
endif

ifeq ($(shell which fastfetch 2>/dev/null),)
	$(warning fastfetch not installed but recommended)
endif

ifeq ($(shell pacman -Q reflector 2>/dev/null),)
	$(warning reflector not installed but recommended)
endif

ifeq ($(shell pacman -Q pkgfile 2>/dev/null),)
	$(warning pkgfile not installed but recommended)
endif

ifeq ($(shell pacman -Q plocate 2>/dev/null),)
	$(warning plocate not installed but recommended)
endif

ifeq ($(shell which code-insiders 2>/dev/null),)
	$(warning code-insiders not installed but recommended)
endif

ifeq ($(shell which tar 2>/dev/null),)
	$(error tar not installed but needed)
endif

ifeq ($(shell which unxz 2>/dev/null),)
	$(error unxz not installed but needed)
endif

ifeq ($(shell which unzstd 2>/dev/null),)
	$(error unzstd not installed but needed)
endif

ifeq ($(shell which unzip 2>/dev/null),)
	$(error unzip not installed but needed)
endif

ifeq ($(shell which unrar 2>/dev/null),)
	$(error unrar not installed but needed)
endif

ifeq ($(shell which bunzip2 2>/dev/null),)
	$(error bunzip2 not installed but needed)
endif

ifeq ($(shell which gunzip 2>/dev/null),)
	$(error gunzip not installed but needed)
endif

ifeq ($(shell which 7z 2>/dev/null),)
	$(error 7z not installed but needed)
endif

ifeq ($(shell which unlzma 2>/dev/null),)
	$(error unlzma not installed but needed)
endif

ifeq ($(shell which uncompress 2>/dev/null),)
	$(error uncompress not installed but needed)
endif

## Install symlinks
bash:
	@echo "Installing bash dotfiles symlinks.."
	$(MKDIR) "$(HOME)/.config/bash/rc.d"
	$(LN) "$(DOTFILES_DIR)/bash/bashrc" "$(HOME)/.bashrc"
	$(LN) "$(DOTFILES_DIR)/bash/exports.bash" "$(HOME)/.config/bash/rc.d/exports.bash"
	$(LN) "$(DOTFILES_DIR)/.sh.functions" "$(HOME)/.config/bash/rc.d/functions.bash"
	$(LN) "$(DOTFILES_DIR)/.sh.aliases" "$(HOME)/.config/bash/rc.d/aliases.bash"

zsh:
	@echo "Installing zsh dotfiles symlinks.."
	$(MKDIR) "$(HOME)/.config/zsh/rc.d/"
	$(LN) "$(DOTFILES_DIR)/zsh/zshrc" "$(HOME)/.zshrc"
	$(LN) "$(DOTFILES_DIR)/zsh/exports.zsh" "$(HOME)/.config/zsh/rc.d/exports.zsh"
	$(LN) "$(DOTFILES_DIR)/.sh.functions" "$(HOME)/.config/zsh/rc.d/functions.zsh"
	$(LN) "$(DOTFILES_DIR)/.sh.aliases" "$(HOME)/.config/zsh/rc.d/aliases.zsh"

starship:
	@echo "Installing starship symlinks.."
	$(MKDIR) "$(HOME)/.starship"
	$(LN) "$(DOTFILES_DIR)/starship/bash.toml" "$(HOME)/.starship/bash.toml"
	$(LN) "$(DOTFILES_DIR)/starship/zsh.toml" "$(HOME)/.starship/zsh.toml"

hyfetch:
	@echo "Installing hyfetch config symlink.."
	$(LN) "$(DOTFILES_DIR)/hyfetch/hyfetch.json" "$(HOME)/.config/hyfetch.json"
	echo "Installing fastfetch config symlink.."
	$(LN) "$(DOTFILES_DIR)/hyfetch/config.jsonc" "$(HOME)/.config/fastfetch/config.jsonc"

git:
	@echo "Installing git configs symlinks.."
	$(LN) "$(DOTFILES_DIR)/git/gitconfig" "$(HOME)/.gitconfig"
	$(LN) "$(DOTFILES_DIR)/git/gitconfig.local" "$(HOME)/.gitconfig.local"

plocate:
	@echo "Installing plocate systemd service symlink..."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/systemd/update-plocate.service" "/etc/systemd/system/update-plocate.service"
	@echo "Running plocate update..."
	$(SUDO) updatedb
	@echo "Enabling plocate update service..."
	sudo systemctl daemon-reexec
	sudo systemctl enable update-plocate.service

pkgfile:
	@echo "Installing pkgfile systemd service symlink.."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/systemd/update-pkgfile.service" "/etc/systemd/system/update-pkgfile.service"
	@echo "Running pkgfile update.."
	sudo pkgfile --update;
	@echo "Enabling pkgfile update service.."
	sudo systemctl daemon-reload;
	sudo systemctl enable /etc/systemd/system/update-pkgfile.service;

vscode:
	@if [ -s "$(DOTFILES_DIR)/vscode-insiders/extensions" ]; then \
		echo "Reading extensions list..."; \
		installed_exts="$$(code-insiders --list-extensions)"; \
		while IFS= read -r extension; do \
			if echo "$$installed_exts" | grep -qi "^$$extension$$"; then \
				echo "✖ $$extension is already installed. Skipping..."; \
			else \
				echo "✔ Installing $$extension..."; \
				code-insiders --install-extension "$$extension"; \
			fi; \
		done < "$(DOTFILES_DIR)/vscode-insiders/extensions"; \
		echo "✔ Visual Studio Code extensions have been installed."; \
		$(MKDIR) "$(HOME)/.config/Code - Insiders"; \
		$(SUDO) $(LN) "$(DOTFILES_DIR)/vscode-insiders/settings.json" "$(HOME)/.config/Code - Insiders/User/settings.json"; \
		else \
		echo "✖ Extension list file is missing or empty."; \
	fi; \

reflector:
	echo "Installing reflector config symlink.."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/pacman/reflector.conf" "/etc/xdg/reflector/reflector.conf"

pacman-conf:
	echo "Installing pacman config symlink.."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/pacman/pacman.conf" "/etc/pacman.conf"

pacman-mirrorlist:
	echo "Installing pacman mirrorlist symlink.."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/pacman/mirrorlist" "/etc/pacman.d/mirrorlist"

makepkg:
	echo "Installing makepkg config symlink.."
	$(SUDO) $(LN) "$(DOTFILES_DIR)/makepkg/makepkg.conf" "/etc/makepkg.conf"

## Remove existing symlinks
clean:
	@echo "Removing existing symlinks..."
	rm -fv "$(HOME)/.bashrc";
	rm -fv "$(HOME)/.config/bash/rc.d/exports.bash";
	rm -fv "$(HOME)/.config/bash/rc.d/aliases.bash";
	rm -fv "$(HOME)/.config/bash/rc.d/functions.bash";
	rm -rfv "$(HOME)/.config/bash";
	rm -fv "$(HOME)/.zshrc";
	rm -fv "$(HOME)/.config/zsh/rc.d/exports.zsh";
	rm -fv "$(HOME)/.config/zsh/rc.d/aliases.zsh";
	rm -fv "$(HOME)/.config/zsh/rc.d/functions.zsh";
	rm -rfv "$(HOME)/.config/zsh";
	rm -fv "$(HOME)/.gitconfig";
	rm -fv "$(HOME)/.starship/bash.toml";
	rm -fv "$(HOME)/.starship/zsh.toml";
	rm -rfv "$(HOME)/.starship";
	rm -fv "$(HOME)/.config/hyfetch.json";
	rm -fv "$(HOME)/.config/fastfetch/config.jsonc";
	rm -rfv "$(HOME)/.fastfetch";
	rm -rv "$(HOME)/.config/Code - Insiders/User/settings.json";
	$(SUDO) rm -fv "/etc/systemd/system/update-pkgfile.service";
	$(SUDO) rm -fv "/etc/systemd/system/update-plocate.service";
