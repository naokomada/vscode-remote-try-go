FROM golang:1.20.1

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get install -y python3 python3-pip
RUN pip3 install online-judge-tools

ENV GO111MODULE on
WORKDIR /go/src/work

# install go tools（自動補完等に必要なツールをコンテナにインストール）
# RUN go install github.com/uudashr/gopkgs/v2/cmd/gopkgs
# RUN go install github.com/ramya-rao-a/go-outline
# RUN go install github.com/nsf/gocode
# RUN go install github.com/acroca/go-symbols
# RUN go install github.com/fatih/gomodifytags
# RUN go install github.com/josharian/impl
# RUN go install github.com/haya14busa/goplay/cmd/goplay
# RUN go install github.com/go-delve/delve/cmd/dlv
RUN go install golang.org/x/lint/golint@latest
RUN go install golang.org/x/tools/gopls@latest

# RUN go install github.com/uudashr/gopkgs/v2/cmd/gopkgs \
#   github.com/ramya-rao-a/go-outline \
#   github.com/nsf/gocode \
#   github.com/acroca/go-symbols \
#   github.com/fatih/gomodifytags \
#   github.com/josharian/impl \
#   github.com/haya14busa/goplay/cmd/goplay \
#   github.com/go-delve/delve/cmd/dlv \
#   golang.org/x/lint/golint \
#   golang.org/x/tools/gopls

USER $USERNAME
