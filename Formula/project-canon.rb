class ProjectCanon < Formula
  desc "Conformance tool for the AI-first CLI and project family"
  homepage "https://github.com/jarimustonen/project-canon"
  url "https://github.com/jarimustonen/project-canon/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c4a2312674e98e5a1727176bd926c55fc04b351f89541b5a3210cbb0342059a4"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/project-canon-cli"
  end

  test do
    system bin/"project-canon", "--version"
  end
end
