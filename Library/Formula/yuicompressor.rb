require 'formula'

class Yuicompressor <Formula
  url 'http://yuilibrary.com/downloads/yuicompressor/yuicompressor-2.4.2.zip'
  homepage 'http://yuilibrary.com/project/yuicompressor'
  md5 '2a526a9aedfe2affceed1e1c3f9c0579'

  def install
    prefix.install "build/yuicompressor-2.4.2.jar"
    (bin+'yuicompressor').write <<-EOS
#!/bin/sh
YUIC=#{prefix}/yuicompressor-2.4.2.jar
java -jar $YUIC $@
EOS
  end
end
