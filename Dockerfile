FROM alpine:3.17

ARG USER_ID
ARG GROUP_ID

ENV TERM xterm

RUN apk add --no-cache zsh make curl wget git fd ripgrep tmux zip tzdata bat\
  exa neovim chezmoi starship lazygit erlang elixir nodejs python3 go
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Set up user
RUN adduser -g '' -D adrien
USER adrien
ENV HOME /home/adrien
ENV PATH "/usr/local/go/bin:$PATH"
 
WORKDIR "$HOME"

# setup dotfiles
RUN git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
RUN chezmoi init --apply https://github.com/adriffaud/dotfiles.git

# Pre-install Packer plugins
RUN nvim --headless -c "autocmd User PackerComplete quitall"

# Setup Mix tools
RUN mix local.hex --force && mix local.rebar --force

CMD /bin/zsh
