class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/davvid/garden"
  url "https://github.com/davvid/garden/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "84d53e770f64ccc7c29d34bbb6b70a63481b3cac999ae35e481ec0629a496018"
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
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: |
              touch ${TREE_NAME}
              test: touch ${name}
        name: $ echo garden
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"garden", :exist?
    assert_predicate testpath/"current", :exist?
  end
end
