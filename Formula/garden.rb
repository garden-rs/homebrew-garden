class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://gitlab.com/garden-rs/garden"
  url "https://gitlab.com/garden-rs/garden/-/archive/v0.9.1/garden-v0.9.1.tar.gz"
  sha256 "72dfe663f64b6accb6e89f96b8f1bc670db651183198c1f24c43b2d4211ffb26"
  license "MIT"
  head "https://gitlab.com/garden-rs/garden.git", branch: "main"

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
