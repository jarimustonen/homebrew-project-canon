class ProjectCanon < Formula
  desc "Conformance tool for the AI-first CLI and project family"
  homepage "https://github.com/jarimustonen/project-canon"
  url "https://github.com/jarimustonen/project-canon/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c245442d234dd143058d0310e53b1b599ea28734e089b6bcd40bcfe06ba0dc49"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/project-canon-cli"
  end

  test do
    system bin/"project-canon", "--version"
  end
end
