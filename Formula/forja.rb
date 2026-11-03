# Forja 0.8.0: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.8.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.0/forja-macos-arm64.tar.gz"
      sha256 "4f9cd61da2947fe896fab03b327656d674a7d6be565b88c6d1392e289584970f"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.0/forja-macos-x64.tar.gz"
      sha256 "c665edc97750d4ede7e07fa5db64eb214f9a24e04188709318441dda108fcab9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.8.0/forja-linux-x64.tar.gz"
      sha256 "af3b1dccda0a96762296bf405f9127c2fc6a979c699dbef27a36d9f748dca137"
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
