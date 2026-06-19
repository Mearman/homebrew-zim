class Zim < Formula
  desc "Meta-formula: installs zim-tools (zimdump and the openzim reader tools)"
  homepage "https://github.com/Mearman/homebrew-zim"
  url "https://github.com/Mearman/homebrew-zim/archive/refs/tags/zim-meta-1.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  depends_on "Mearman/zim/zim-tools"

  def install
    pkgshare.mkpath
    (pkgshare/"README.md").write "Meta-formula for the Mearman/zim tap. Installs zim-tools (zimdump and friends)."
  end

  test do
    assert_predicate Formula["zim-tools"], :any_version_installed?
  end
end
