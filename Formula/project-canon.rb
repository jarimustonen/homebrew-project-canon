class ProjectCanon < Formula
  desc "The project-canon binary — conformance verbs plus binary-owned distribution of the AI-first CLI canon and companion cli-canon skill."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.9.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.3/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8ce8a51a4ccdec7435c24ccc6acab67c7c9387fe080885e0c77d44473d06a2d0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.3/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ca16fdbfeab473bae7e38ab5d88a9d497e594cdd2d6debd99b000e5937e007c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.9.3/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d6d4aa2da8dd0bc59fd97590ecbbd5329deb03bdf09526d263332e1bc81db5a2"
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
