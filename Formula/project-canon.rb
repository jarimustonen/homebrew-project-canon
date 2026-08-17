class ProjectCanon < Formula
  desc "The project-canon binary — a thin CLI over project-canon-core exposing the doctor, new, and review verbs plus the canon skill installer."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.5.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.5.0/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "75716a82a4977672bcff209de7cbd59270223c8fd14f0392c3514546d99eedda"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.5.0/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6dd37c36d5e21ae926633b3b9ee79ae1456f0313ac914a2bae8c48a792af8778"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.5.0/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "64887e8df99af476f34caf061c14eac320035afb34eb44509f0560f70796ae21"
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
