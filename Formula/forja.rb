# Forja 0.9.0: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.9.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.9.0/forja-macos-arm64.tar.gz"
      sha256 "147eea839fd418cc9d4473d918544d70f081cd1c7a761e077849528e9550ce8c"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.9.0/forja-macos-x64.tar.gz"
      sha256 "6246a7e416681f3035aca2f9317e0759b9fd0df220a17cd1767f906d5a241122"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.9.0/forja-linux-x64.tar.gz"
      sha256 "3a04c2ab1e73815fd97cd55b53329ef4f6eb8e94798bbf1a27c86d78f36e5a58"
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
