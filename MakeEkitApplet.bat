@set inputmode=mode%1
@if %inputmode% == modespell goto spellmaker
@goto basicmaker
:basicmaker
  @echo =========================
  @echo Basic version compilation
  @echo =========================
  @set compilemode=basic
  @set additionalfiles=com\swabunga\spell\event\SpellCheckListener.class
  @goto compilecore
:spellmaker
  @echo ==============================
  @echo Spellcheck version compilation
  @echo ==============================
  @set compilemode=spell
  @set additionalfiles=com\swabunga\spell\engine\*.class com\swabunga\spell\engine\*.properties com\swabunga\spell\engine\dictionary\* com\swabunga\spell\event\*.class com\swabunga\spell\swing\*.class com\swabunga\spell\swing\*.properties
  @goto compilecore
:compilecore
  @echo [] compiling core...
  @javac -deprecation com\hexidec\ekit\EkitCore.java
  @if errorlevel 1 goto failure
  @if %inputmode% == modespell goto compilespellcore
  @goto compileapp
:compilespellcore
  @echo [] compiling spellcheck extended core...
  @javac com\hexidec\ekit\EkitCoreSpell.java
  @if errorlevel 1 goto failure
  @goto compileapp
:compileapp
  @echo [] compiling application...
  @javac com\hexidec\ekit\EkitApplet.java
  @if errorlevel 1 goto failure
  @goto makejar
:makejar
  @echo [] jarring...
  @jar cf ekitapplet.jar com\hexidec\ekit\*.class com\hexidec\ekit\action\*.class com\hexidec\ekit\component\*.class com\hexidec\ekit\icons\*.png com\hexidec\ekit\*.properties com\hexidec\util\Base64Codec.class com\hexidec\util\Translatrix.class com\hexidec\ekit\thirdparty\print\*.class %additionalfiles%
  @if errorlevel 1 goto failure
  @goto cleanup
:failure
  @echo [*] make failed with an error level of %errorlevel%
  @goto cleanup
:cleanup
  @echo [] cleaning up Ekit classes...
  @del com\hexidec\ekit\*.class
  @del com\hexidec\ekit\action\*.class
  @del com\hexidec\ekit\component\*.class
  @del com\hexidec\util\Base64Codec.class
  @del com\hexidec\util\Translatrix.class
  @if %compilemode% == spell goto spellpurge
  @goto finish
:spellpurge
  @echo [] cleaning up spellcheck classes...
  @del com\swabunga\spell\engine\*.class
  @del com\swabunga\spell\event\*.class
  @del com\swabunga\spell\swing\*.class
  @goto finish
:finish
  @set inputmode=
  @set compilemode=
  @set additionalfiles=
  @echo [] finished
