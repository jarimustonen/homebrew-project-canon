class ProjectCanon < Formula
  desc "Conformance tool for the AI-first CLI and project family"
  homepage "https://github.com/jarimustonen/project-canon"
  url "https://github.com/jarimustonen/project-canon/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "7823165006c80debf241e0e3adc4ac6573bc273f85c91c9d9f2e6dabc50ffb25"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/project-canon-cli"
  end

  test do
    system bin/"project-canon", "--version"
  end
end
