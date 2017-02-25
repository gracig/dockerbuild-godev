FROM golang:1.8
MAINTAINER Gerson Graciani

#Copies .vimrc to root
ADD root/ /root/
ADD etc/ /etc/

#Build and install vim
RUN apt-get update -y \
&&  apt-get install -y ncurses-dev libtolua-dev exuberant-ctags \
&&  ln -s /usr/include/lua5.2/ /usr/include/lua \
&&  ln -s /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/lib/liblua.so \
&&  cd /tmp \
&&  git clone https://github.com/vim/vim.git \
&&  cd vim \
&&  ./configure --with-features=huge --enable-luainterp \
        --enable-gui=no --without-x --prefix=/usr \
&&  make VIMRUNTIMEDIR=/usr/share/vim/vim80 \
&&  make install \
&&  rm -rf /tmp/*  /var/tmp/* \
&&  apt-get clean 

#CONFIGURE VIM
RUN  mkdir -p /root/.vim/bundle \
&&  cd /root/.vim/bundle \
&&  git clone --depth 1 https://github.com/gmarik/Vundle.vim.git \
&&  git clone --depth 1 https://github.com/fatih/vim-go.git \
&&  git clone --depth 1 https://github.com/majutsushi/tagbar.git \
&&  git clone --depth 1 https://github.com/Shougo/neocomplete.vim.git \
&&  git clone --depth 1 https://github.com/bling/vim-airline.git \
&&  git clone --depth 1 https://github.com/tpope/vim-fugitive.git \
&&  git clone --depth 1 https://github.com/jistr/vim-nerdtree-tabs.git \
&&  git clone --depth 1 https://github.com/mbbill/undotree.git \
&&  git clone --depth 1 https://github.com/Lokaltog/vim-easymotion.git \
&&  git clone --depth 1 https://github.com/scrooloose/nerdcommenter.git \
&&  git clone --depth 1 https://github.com/scrooloose/nerdtree.git \
&&  rm -rf */.git

#Getting Go Tools
RUN /bin/true \
&&  go get golang.org/x/tools/cmd/guru \
&&  go get golang.org/x/tools/cmd/goimports \
&&  go get golang.org/x/tools/cmd/godoc \
&&  go get golang.org/x/tools/cmd/gorename \
&&  go get github.com/golang/lint/golint \
&&  go get github.com/alecthomas/gometalinter \
&&  go get github.com/klauspost/asmfmt/cmd/asmfmt \
&&  go get github.com/fatih/motion \
&&  go get github.com/zmb3/gogetdoc \
&&  go get github.com/josharian/impl \
&&  go get github.com/nsf/gocode \
&&  go get github.com/rogpeppe/godef \
&&  go get github.com/kisielk/errcheck \
&&  go get github.com/jstemmer/gotags \
&&  go get github.com/govend/govend \
&&  go get google.golang.org/grpc \
&&  go get -u github.com/golang/protobuf/proto \
&&  go get -u github.com/golang/protobuf/protoc-gen-go \
&&  /bin/true

#ENTRYPOINT ["vim",  "+PluginInstall",  "+qall"]

CMD ["bash"]
