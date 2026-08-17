class ProjectCanonCli < Formula
  desc "The project-canon binary — a thin CLI over project-canon-core exposing the doctor, new, and review verbs plus the canon skill installer."
  homepage "https://github.com/jarimustonen/project-canon"
  version "0.3.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/project-canon/releases/download/v0.3.2/project-canon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "ea12db5ab0aae70e39504a56d93e50b52c56a0193dfb14457fa44a389cf75c8a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.3.2/project-canon-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ac19ebdcde21b2cac933ef3048f995840e18eb3eea7c277e2c7477286f8f785a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/project-canon/releases/download/v0.3.2/project-canon-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8d195c93fa93119876a9c85b6d0aeb148da38b442b2e999a1582a160f35ab322"
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
