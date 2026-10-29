# Forja 0.7.0: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.7.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.0/forja-macos-arm64.tar.gz"
      sha256 "ead5a31b0cb22a4ecae9accaed86f4da11ed66e23b35347e0a386d02413b987d"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.0/forja-macos-x64.tar.gz"
      sha256 "6bb4c455c84372473ba7315cc0b694768dd084efb4976988e247e2bf4202c727"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.0/forja-linux-x64.tar.gz"
      sha256 "b465091c522eb0ca23e1eda311cae86889a5d84fb70624be243626e834ce7da9"
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
