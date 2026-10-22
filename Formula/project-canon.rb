class ProjectCanon < Formula
  desc "The project-canon binary — conformance verbs plus binary-owned distribution of the AI-first CLI canon and companion cli-canon skill."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.9.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.4/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "003f43f17bf409138c9fe6cb563cf1d1235ee94564fb69de10b14ee7bbd0e0f8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.4/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b50d4a53e02ad4b16d2b8f944d80e4dbacbc5a6e275822f1bcb3ac6fcdb2a436"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.4/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b967422a3161b3dd6201900375ed8e4b0ab828f7e14c11a5f731b98e0fae8396"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "project-canon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "project-canon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "project-canon"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
