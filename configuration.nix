# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    # 在这里添加你需要常用的软件，比如：
    ripgrep
    htop
    gcc
    zsh
    oh-my-zsh
    fzf
    containerd
    nerdctl
    runc
    cri-tools
    buildkit
    python312
    uv
    tmux
    bun
    nodejs_22
    go
    docker-compose
  ];
  # 需要显示启用containerd
  virtualisation.containerd.enable = true;
  virtualisation.docker.enable = true;
  # 2. 启用 Oh My Zsh (OMZ) 模块
  programs.zsh = {
    enable = true;

    # --- 修改开始 ---

    # 移除不存在的 extraPackages
    # 移除手动的 initExtra source 脚本 (NixOS 会自动处理)

    # 直接使用 NixOS 内置选项开启这两个插件
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # --- 修改结束 ---

    # Oh My Zsh 配置块 (保持不变)
    ohMyZsh = {
      enable = true;
      theme = "agnoster";

      # 仅保留 Oh My Zsh 官方自带的插件
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
  nix.settings = {
    # 将国内镜像源放在第一位
    substituters = [
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # 或者使用清华源：
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

      "https://cache.nixos.org/"
    ];
  };

  # 2. 为 nixos 用户声明默认 shell
  users.users.nixos = {
    # 关键：告诉 NixOS 使用 Zsh 软件包作为该用户的 shell
    shell = pkgs.zsh;
    # 确保您的用户在此处被定义，或者找到已有的定义
    # isSystemUser = true;
    # ... 其他用户设置，如 home = "/home/nixos"; ...
  };

  # 开启 nix-command 和 flakes 功能
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.direnv.enable = true;

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
