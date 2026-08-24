class V < Formula
  desc "A minimal, preconfigured Neovim distribution"
  homepage "https://github.com/snesjhon/v"
  url "https://github.com/snesjhon/v/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c6efcd6aadaadeb1b24aa636fe9276d21b676a69e2fd6709658d8a9e44ea73a8"

  # nvim-treesitter shells out to the `tree-sitter` CLI to build parsers on
  # first launch -- without it, install() fails with "no such file or
  # directory: 'tree-sitter'". Note: `tree-sitter` (no suffix) is just the
  # C parsing library and ships no binary; the CLI is `tree-sitter-cli`.
  depends_on "tree-sitter-cli"

  # vtsls provides the TypeScript/JavaScript language server configured in
  # lua/lsp.lua -- without it, LSP silently fails with "vtsls is not
  # executable" the moment a JS/TS file is opened.
  depends_on "vtsls"

  # Vendored Neovim binary (arm64 only) -- private copy, not a visible dependency.
  resource "nvim-macos-arm64" do
    url "https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-macos-arm64.tar.gz"
    sha256 "51ab83afa66d663627c2ab1be43209b0f4e81360d4598b53efaa4d8195f24c89"
  end

  def install
    resource("nvim-macos-arm64").stage(libexec/"nvim-bin")

    pkgshare.install "init.lua"
    pkgshare.install "lua"

    (bin/"v").write <<~EOS
      #!/usr/bin/env bash
      export NVIM_APPNAME="v"
      exec -a "v" "#{libexec}/nvim-bin/bin/nvim" -u "#{pkgshare}/init.lua" "$@"
    EOS
    chmod 0755, bin/"v"
  end

  test do
    system bin/"v", "--version"
  end
end
