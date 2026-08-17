class ProjectCanon < Formula
  desc "The project-canon binary — a thin CLI over project-canon-core exposing the doctor, new, and review verbs plus the canon skill installer."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.4.0/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "644f4f6f4e9e8d0d55e368e515fa6e9a1aceaa7edc7ad755fcbfd9d4de832a5f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.4.0/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a9d10da08112c1ada3d8a39de2fe3d5115b3fd0e2f5637ae7c4f454b024f5806"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.4.0/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1075770f343354e67fab2a6ea7212d12a5e29eb2ef543910518bd03e23e1d2e7"
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
