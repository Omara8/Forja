# Forja 0.7.4: written by the release workflow (build/formula.py in the private repo). Do not edit by hand.
class Forja < Formula
  desc "AI kits for software delivery, run headless from one terminal command"
  homepage "https://github.com/Omara8/Forja"
  version "0.7.4"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.4/forja-macos-arm64.tar.gz"
      sha256 "65a8090e80c92e3d2b83d98e834d42fa09cf56a1bda1235608ea2293a051efee"
    end
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.4/forja-macos-x64.tar.gz"
      sha256 "61dd7229d6f7b289fca789e033e1db84a188ec1d6ad7bd42a6e1196a24cad6d9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Omara8/Forja/releases/download/v0.7.4/forja-linux-x64.tar.gz"
      sha256 "0dbd0c9031a2d764a5af3d300dd62cf8574c8597a03063826d35518ad10c10ee"
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
