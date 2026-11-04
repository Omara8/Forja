# Forja 0.8.1: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.8.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.1/forja-macos-arm64.tar.gz"
      sha256 "34eeadb3ed5c7d3d7274b9ae0d2f82730f180cddab07270fe760b6847d532656"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.1/forja-macos-x64.tar.gz"
      sha256 "d6f4e6cb5f724fdd1810d76aec6a60da476e2f084ddb65608d8636aa79446ab0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.1/forja-linux-x64.tar.gz"
      sha256 "221212b1c1ffeaf7809a9f5f07640cdabcfa1f2907c06bfdd3e5747b0641624d"
    end
  end

  def install
    libexec.install "app", "python", "bin"
    (bin/"forja").write_env_script libexec/"bin/forja", FORJA_ROOT: opt_libexec, FORJA_CHANNEL: "brew"
  end

  def caveats
    <<~EOS
      Set up this computer once (your archive, your AI tools):
        forja setup
      Update:  brew upgrade forja     Settings:  ~/forja/config
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forja version")
  end
end
