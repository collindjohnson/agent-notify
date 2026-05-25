class AgentNotify < Formula
  desc "Desktop notifications for AI coding tools"
  homepage "https://github.com/collindjohnson/agent-notify"
  url "https://github.com/collindjohnson/agent-notify/archive/refs/tags/v1.7.4-agent-notify.tar.gz"
  sha256 "fee1872144b04c248cefffea82e9e57f26b3bb98b1478e7f6228eac062a28cae"
  license "MIT"
  version "1.7.4"

  depends_on "jq"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    libexec.install "bin"
    libexec.install "lib"

    inreplace libexec/"bin/agent-notify",
              '$(dirname "$SCRIPT_DIR")/lib/agent-notify',
              "#{libexec}/lib/agent-notify"

    bin.install_symlink libexec/"bin/agent-notify" => "agent-notify"
    bin.install_symlink libexec/"bin/agent-notify" => "an"
    bin.install_symlink libexec/"bin/agent-notify" => "anp"
  end

  test do
    assert_match "agent-notify version", shell_output("#{bin}/agent-notify version")
  end
end
