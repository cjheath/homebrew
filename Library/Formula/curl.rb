require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.34.0.tar.gz'
  mirror 'ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.34.0.tar.gz'
  sha256 '0705271de8411a85460706e177cd0f1064ec07c0b9e140a66a916fb644696d6a'

  keg_only :provided_by_osx

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-gssapi', 'Build with GSSAPI/Kerberos authentication support.'

  if MacOS.version >= :mountain_lion
    option 'with-openssl', 'Build with OpenSSL instead of Secure Transport'
    depends_on 'openssl' => :optional
  else
    depends_on 'openssl'
  end

  depends_on 'pkg-config' => :build
  depends_on 'libmetalink' => :optional
  depends_on 'libssh2' if build.with? 'ssh'
  depends_on 'c-ares' if build.with? 'ares'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if insecure = ENV['CURLOPT_SSL_VERIFYPEER']
      insecure = true if %w{no false}.include? insecure
      puts "Performing INSECURE download" if insecure
    end

    args << "--insecure" if insecure
    if MacOS.version < :mountain_lion or build.with? "openssl"
      args << "--with-ssl=#{Formula.factory("openssl").opt_prefix}"
    else
      args << "--with-darwinssl"
    end

    args << "--with-libssh2" if build.with? 'ssh'
    args << "--with-libmetalink" if build.with? 'libmetalink'
    args << "--enable-ares=#{Formula.factory("c-ares").opt_prefix}" if build.with? 'ares'
    args << "--with-gssapi" if build.with? 'gssapi'

    system "./configure", *args
    system "make install"
  end
end
