# Forja 0.8.2: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.8.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.2/forja-macos-arm64.tar.gz"
      sha256 "247f89de292c3c472a4d2deba8683086e6b9eeb5240a29e9e08e68fe4305d7af"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.2/forja-macos-x64.tar.gz"
      sha256 "cdd697f2785b1cc7d0f2519edda451f632abc947b8869642e651676c749cd69e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.2/forja-linux-x64.tar.gz"
      sha256 "6d4aaaf82a0a037f99d36ceede5e22c265c2248ad71adb889dec8aaaf2810406"
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
