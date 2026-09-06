class ProjectCanon < Formula
  desc "The project-canon binary — conformance verbs plus binary-owned distribution of the AI-first CLI canon and companion cli-canon skill."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.8.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.8.2/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "94e8ec21872f8d41d67dba93cf45dd886c08b46a053c7333ad8ef8676296d1c8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.8.2/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6f0f51d5a73d720a276c40c400c91997d90cf1c81790cfa4e2061add948c4e5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.8.2/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "056a3d968ee0541ae9976e32ad3a3cf9f4f46842fe3da7d4e09e2c33cd4aa81f"
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
