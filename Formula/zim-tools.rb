class ZimTools < Formula
  desc "Command-line tools for openzim ZIM files (zimdump, zimdiff, zimsplit, ...)"
  homepage "https://github.com/openzim/zim-tools"
  url "https://github.com/openzim/zim-tools/archive/refs/tags/3.7.0.tar.gz"
  sha256 "6ce3c63832234f65c23cd76f0bd5076182d24b186b107d7a6295fbc21e252b83"
  license "GPL-3.0-or-later"
  head "https://github.com/openzim/zim-tools.git", branch: "main"

  # WIP (2026-06-18). Builds the READER toolset:
  #   zimdump zimdiff zimpatch zimsplit zimrecreate zimbench zimsearch
  # zimcheck (needs mustache.hpp) and zimwriterfs (needs gumbo + libmagic)
  # are skipped for now. Tested only on Intel macOS so far.
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :build
  depends_on "libzim"

  # docopt isn't packaged by Homebrew, and the meson wrap needs network
  # (blocked in the build sandbox), so build it from source as a resource.
  resource "docopt" do
    url "https://github.com/docopt/docopt.cpp/archive/refs/tags/v0.6.3.tar.gz"
    sha256 "28af5a0c482c6d508d22b14d588a3b0bd9ff97135f99c2814a5aa3cbff1d6632"
  end

  def install
    docopt_prefix = buildpath/"docopt-install"
    resource("docopt").stage do
      mkdir "cmake-build" do
        system "cmake", "..", "-DCMAKE_INSTALL_PREFIX=#{docopt_prefix}",
                        "-DCMAKE_BUILD_TYPE=Release"
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
    (docopt_prefix/"lib/pkgconfig").mkpath
    pc = docopt_prefix/"lib/pkgconfig/docopt.pc"
    pc.write <<~EOS unless pc.exist?
      prefix=#{docopt_prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include
      Name: docopt
      Description: docopt.cpp command-line parser
      Version: 0.6.3
      Libs: -L${libdir} -ldocopt
      Cflags: -I${includedir}
    EOS
    ENV.append_path "PKG_CONFIG_PATH", "#{docopt_prefix}/lib/pkgconfig"

    # Skip the writer (gumbo+libmagic) and zimcheck (mustache.hpp).
    inreplace "meson.build" do |s|
      s.gsub!(/with_writer = host_machine\.system\(\) != 'windows'/, "with_writer = false")
    end
    inreplace "src/meson.build" do |s|
      s.gsub!(/subdir\('zimcheck'\)/, "# subdir('zimcheck') skipped (needs mustache.hpp)")
    end
    # docopt installs a flat docopt.h; zim-tools expects <docopt/docopt.h>.
    inreplace Dir["src/**/*.cpp"], "#include <docopt/docopt.h>", "#include <docopt.h>"

    mkdir "build" do
      system "meson", "setup", ".", "..", *std_meson_args
      system "meson", "compile"
      system "meson", "install"
    end
  end

  test do
    assert_match "zim-tools", shell_output("#{bin}/zimdump --version")
  end
end
