class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/davvid/garden"
  url "https://github.com/davvid/garden/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "dc1913f1ffd6fcb8205feb7e4b1111f03e1dca266b6ace05cdc49a1e31599425"
  license "MIT"
  head "https://github.com/davvid/garden.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: .
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${name}
      variables:
        name: $ echo garden
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"garden", :exist?
    assert_predicate testpath/"current", :exist?
  end
end
