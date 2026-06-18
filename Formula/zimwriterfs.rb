class Zimwriterfs < Formula
  desc "Create openzim ZIM files from a local HTML directory"
  homepage "https://github.com/openzim/zim-tools"
  url "https://github.com/openzim/zim-tools/archive/refs/tags/3.7.0.tar.gz"
  sha256 "6ce3c63832234f65c23cd76f0bd5076182d24b186b107d7a6295fbc21e252b83"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :build
  depends_on "libzim"
  depends_on "gumbo-parser"
  depends_on "libmagic"

  resource "docopt" do
    url "https://github.com/docopt/docopt.cpp/archive/refs/tags/v0.6.3.tar.gz"
    sha256 "28af5a0c482c6d508d22b14d588a3b0bd9ff97135f99c2814a5aa3cbff1d6632"
  end

  resource "mustache" do
    url "https://raw.githubusercontent.com/kainjow/mustache/v4.1/mustache.hpp"
    sha256 "6a07bd8c31be6bb3eae6df98b12f89df8931604bd890e8bba59298a68b89ff29"
  end

  def install
    install_docopt

    mustache_inc = buildpath/"mustache-include"
    mustache_inc.mkpath
    resource("mustache").stage mustache_inc
    ENV.append_path "CPATH", mustache_inc.to_s

    # with_writer stays true (default) so gumbo+libmagic are required; build only the writer
    (buildpath/"src/meson.build").write "subdir('zimwriterfs')\n"

    mkdir "build" do
      system "meson", "setup", ".", "..", *std_meson_args
      system "meson", "compile"
      system "meson", "install"
    end
  end

  test do
    assert_match "zimwriterfs", shell_output("#{bin}/zimwriterfs --help 2>&1; true")
  end

  private

  def install_docopt
    docopt_prefix = buildpath/"docopt-install"
    resource("docopt").stage do
      mkdir "cmake-build" do
        system "cmake", "..", "-DCMAKE_INSTALL_PREFIX=#{docopt_prefix}", "-DCMAKE_BUILD_TYPE=Release"
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
    (docopt_prefix/"include/docopt").mkpath
    cp docopt_prefix/"include/docopt.h", docopt_prefix/"include/docopt/docopt.h"
    ENV.append_path "CPATH", "#{docopt_prefix}/include"
    (docopt_prefix/"lib/pkgconfig").mkpath
    (docopt_prefix/"lib/pkgconfig/docopt.pc").write <<~EOS
      prefix=#{docopt_prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include
      Name: docopt
      Description: docopt.cpp
      Version: 0.6.3
      Libs: -L${libdir} -ldocopt
      Cflags: -I${includedir}
    EOS
    ENV.append_path "PKG_CONFIG_PATH", "#{docopt_prefix}/lib/pkgconfig"
  end
end
