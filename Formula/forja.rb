# Forja 0.7.3: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.7.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.3/forja-macos-arm64.tar.gz"
      sha256 "4f9223ae93de7297268147d673070608fb7ca114617c484e66ef041a18ed3c03"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.3/forja-macos-x64.tar.gz"
      sha256 "2fea6b47a41f32c9aee48e0755afb42ea66e52f8f5e9110bbe838fdee2a3dfa9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.3/forja-linux-x64.tar.gz"
      sha256 "15eb71f22f555a30b7d9f85b08ad5a3e79b23bd803adcef2dd1e90c7f25a4b07"
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
