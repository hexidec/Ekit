#! /bin/csh
set inputmode=mode$1
if $inputmode == modespell goto spellmaker
goto basicmaker
basicmaker:
  echo =========================
  echo Basic version compilation
  echo =========================
  set mode=basic
  set additionalfiles=com/swabunga/spell/event/SpellCheckListener.class
  if $status == 0 goto compilecore
  goto failure
spellmaker:
  echo ==============================
  echo Spellcheck version compilation
  echo ==============================
  set mode=spell
  set additionalfiles="com/swabunga/spell/engine/*.class com/swabunga/spell/engine/*.properties com/swabunga/spell/engine/dictionary/* com/swabunga/spell/event/*.class com/swabunga/spell/swing/*.class com/swabunga/spell/swing/*.properties"
  if $status == 0 goto compilecore
  goto failure
compilecore:
  echo [] compiling core...
  javac com/hexidec/ekit/EkitCore.java
  if $status == 0 goto compilebranch
  goto failure
compilebranch:
  if $inputmode == modespell goto compilespellcore
  goto compileapp
compilespellcore:
  echo [] compiling spellcheck extended core...
  javac com/hexidec/ekit/EkitCoreSpell.java
  if $status == 0 goto compileapp
  goto compileapp
compileapp:
  echo [] compiling application...
  javac com/hexidec/ekit/Ekit.java
  if $status == 0 goto makejar
  goto failure
makejar:
  echo [] jarring...
  jar cmf com/hexidec/ekit/ekit.manifest ekit.jar com/hexidec/ekit/*.class com/hexidec/ekit/action/*.class com/hexidec/ekit/component/*.class com/hexidec/util/Base64Codec.class com/hexidec/util/Translatrix.class com/hexidec/ekit/icons/*.png com/hexidec/ekit/*.properties com/hexidec/ekit/thirdparty/print/*.class $additionalfiles
  if $status == 0 goto modjar
  goto failure
modjar:
  echo [] modifying jar permissions...
  chmod 755 ekit.jar
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
  if $mode == spell goto spellpurge
  goto finish
spellpurge:
  echo [] cleaning up spellcheck classes...
  rm com/swabunga/spell/engine/*.class
  rm com/swabunga/spell/event/*.class
  rm com/swabunga/spell/swing/*.class
  goto finish
failure:
  echo [*] make failed with an error level of $status
  goto finish
finish:
  echo [] finished
