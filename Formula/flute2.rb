class Flute2 < Formula
  desc "Cross-platform CLI for the Flute payments platform (v2 API)"
  homepage "https://github.com/getflute/flute-cli-v2"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-v2/releases/download/v1.1.0/flute2-aarch64-apple-darwin.tar.xz"
    sha256 "8fcbfad4c18e468b559d84a0358f76c7a2fa182c5e69f444572e3152047c5184"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli-v2/releases/download/v1.1.0/flute2-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88a387d8f726e81d02831a875cb88de9993b4c7176963b050bcd93780b70af0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli-v2/releases/download/v1.1.0/flute2-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f2cec44737e9aa70c32cc32366eac2fa08d92b45dda025debfd190f6120d5f4"
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
