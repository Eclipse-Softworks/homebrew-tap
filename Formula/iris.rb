# typed: false
# frozen_string_literal: true

class Iris < Formula
  desc "Compiled systems, AI/ML, and UI programming language (compiler, LSP, DAP, REPL)"
  homepage "https://github.com/Eclipse-Softworks/IRIS"
  version "1.0.0-rc3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Eclipse-Softworks/IRIS/releases/download/v1.0.0-rc3/iris-v1.0.0-rc3-aarch64-apple-darwin.tar.gz"
      sha256 "1623fb2360a4f6fc8fd0e5b408f816e0374173c8895088a481492f87f65bbd14"
    end
    on_intel do
      url "https://github.com/Eclipse-Softworks/IRIS/releases/download/v1.0.0-rc3/iris-v1.0.0-rc3-x86_64-apple-darwin.tar.gz"
      sha256 "1f5409e713ce8d0c89018d0cb4dcf77b01fd2a05a8041a908f21f785b2acf6f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Eclipse-Softworks/IRIS/releases/download/v1.0.0-rc3/iris-v1.0.0-rc3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a3c8d2b147ea3e32ef9005f59e2261d79a785d218f52d8364d55a53ad1aa755"
    end
    on_intel do
      url "https://github.com/Eclipse-Softworks/IRIS/releases/download/v1.0.0-rc3/iris-v1.0.0-rc3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "79519c024dcdbbc234efc97c9f651c6ccaa18c703587f7dcafbee06b8241c598"
    end
  end

  def install
    bin.install "bin/iris"
    ui_libs = Dir["bin/libiris_ui_host.*"]
    lib.install ui_libs unless ui_libs.empty?
    if Dir.exist?("toolchain")
      (prefix/"toolchain").install Dir["toolchain/*"]
    end
    (pkgshare).install "LLVM_VERSION" if File.exist?("LLVM_VERSION")
    (pkgshare).install "share/iris/iris.png" if File.exist?("share/iris/iris.png")
    (pkgshare/"examples").install Dir["examples/*"] if Dir.exist?("examples")
    generate_completions_from_executable(bin/"iris", "completions")
  end

  test do
    assert_match "iris ", shell_output("#{bin}/iris --version")
    (testpath/"hello.iris").write <<~EOS
      def main() -> i64 {
        return 0
      }
    EOS
    system bin/"iris", "check", testpath/"hello.iris"
  end
end
