FROM rockylinux:8
WORKDIR /miyaken-gallery
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

# 必要なツールをインストール
RUN dnf update -y && \
    dnf install -y curl zip unzip git grep sudo systemd systemd-libs net-tools which \
    gcc-c++ patch readline readline-devel zlib zlib-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison && \
    dnf clean all

RUN dnf install -y initscripts

# ruby
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable

# RVMを有効にするための設定
RUN /bin/bash -l -c "source /etc/profile.d/rvm.sh && rvm reload"

# Ruby 2.6のインストール
RUN /bin/bash -l -c "rvm install 2.6 && rvm use 2.6 --default"

# Bundlerのインストール
RUN /bin/bash -l -c "gem install bundler -v 2.4.22"

# Apacheをインストールして起動コマンドを指定（必要に応じて）
RUN dnf install -y httpd mod_ssl

# Nodeインストール
RUN curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash - && \
    sudo dnf install -y nodejs

#yarn インストール
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && \
    sudo dnf install -y yarn

COPY ./apache_config/ssl.conf /etc/httpd/conf.d/
COPY ./ssl/certs/localhost.crt /etc/pki/tls/certs/
COPY ./ssl/private/localhost.key /etc/pki/tls/private/

# RUN rm -f /etc/httpd/conf.d/welcome.conf

# コンテナが起動したときにApacheをフォアグラウンドで実行
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]