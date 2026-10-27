class Flute2 < Formula
  desc "Cross-platform CLI for the Flute payments platform (v2 API)"
  homepage "https://github.com/getflute/flute-cli-v2"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-v2/releases/download/v1.2.0/flute2-aarch64-apple-darwin.tar.xz"
    sha256 "143da17d9bdbc7f46e413a575498f960ae018d5b9e3a8e9199757eb4dfe54012"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli-v2/releases/download/v1.2.0/flute2-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d50e86bd609941caaa0dd684acfa71d6f01ed76c90260e6d6cfcda811991e77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli-v2/releases/download/v1.2.0/flute2-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e4278c7c7b6c62aeac9fdda87c054929ae2c6360e5544be9c74d38dbd19cea1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "flute2"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "flute2"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flute2"
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
