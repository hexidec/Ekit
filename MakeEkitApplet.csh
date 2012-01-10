#! /bin/csh
set inputmode=mode$1
if $inputmode == modespell goto spellmaker
goto basicmaker
basicmaker:
  echo =========================
  echo Basic version compilation
  echo =========================
  set compilemode=basic
  set additionalfiles=com/swabunga/spell/event/SpellCheckListener.class
  goto compilecore
spellmaker:
  echo ==============================
  echo Spellcheck version compilation
  echo ==============================
  set compilemode=spell
  set additionalfiles="com/swabunga/spell/engine/*.class com/swabunga/spell/engine/*.properties com/swabunga/spell/engine/dictionary/* com/swabunga/spell/event/*.class com/swabunga/spell/swing/*.class com/swabunga/spell/swing/*.properties"
  goto compilecore
compilecore:
  echo [] compiling core...
  javac -deprecation com/hexidec/ekit/EkitCore.java
  if $status == 0 goto compilecheck
  goto failure
compilecheck:
  if $inputmode == modespell goto compilespellcore
  goto compileapp
compilespellcore:
  echo [] compiling spellchecker core...
  javac -deprecation com/hexidec/ekit/EkitCoreSpell.java
  if $status == 0 goto compileapp
  goto failure
compileapp:
  echo [] compiling applet...
  javac -deprecation com/hexidec/ekit/EkitApplet.java
  if $status == 0 goto makejar
  goto failure
makejar:
  echo [] jarring...
  jar cf ekitapplet.jar com/hexidec/ekit/*.class com/hexidec/ekit/action/*.class com/hexidec/ekit/component/*.class com/hexidec/util/Base64Codec.class com/hexidec/util/Translatrix.class com/hexidec/ekit/icons/*.png com/hexidec/ekit/*.properties com/hexidec/ekit/thirdparty/print/*.class $additionalfiles
  if $status == 0 goto modjar
  goto failure
modjar:
  echo [] modifying jar permissions...
  chmod 755 ekitapplet.jar
  if $status == 0 goto cleanup
  goto failure
cleanup:
  echo [] cleaning up Ekit classes...
  rm com/hexidec/ekit/*.class
  rm com/hexidec/ekit/action/*.class
  rm com/hexidec/ekit/component/*.class
  rm com/hexidec/util/Base64Codec.class
  rm com/hexidec/util/Translatrix.class
  rm com/hexidec/ekit/thirdparty/print/*.class
  rm com/swabunga/spell/event/*.class
  if $compilemode == spell goto spellpurge
  goto finish
spellpurge:
  echo [] cleaning up spellcheck classes...
  rm com/swabunga/spell/engine/*.class
  rm com/swabunga/spell/swing/*.class
  goto finish
failure:
  echo [*] make failed with an error level of $status
  goto finish
finish:
  echo [] finished
