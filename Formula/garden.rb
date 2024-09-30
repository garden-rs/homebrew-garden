class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://gitlab.com/garden-rs/garden"
  url "https://gitlab.com/garden-rs/garden/-/archive/v1.8.0/garden-v1.8.0.tar.gz"
  sha256 "15f39dfa378505ba463599a0330ad6c63020c37ad449ffba4bf31e4b3f30b9fc"
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
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"current", :exist?
    assert_predicate testpath/"output", :exist?
  end
end
