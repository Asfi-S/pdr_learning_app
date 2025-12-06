@echo off
echo ================================
echo    ASFINIA KEYSTORE GENERATOR
echo ================================
echo.

REM ---- ВСТАНОВИ ШЛЯХ ДО KEYTOOL ----
set "KEYTOOL=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"

REM ---- Перевірка наявності keytool ----
if not exist "%KEYTOOL%" (
    echo [ERROR] keytool.exe не знайдено за шляхом:
    echo %KEYTOOL%
    echo.
    echo Спробуй інший шлях, наприклад:
    echo C:\Program Files\Android\Android Studio\jre\bin\keytool.exe
    pause
    exit /b
)

REM ---- Створення keystore ----
echo Створюємо release-keystore.jks ...
"%KEYTOOL%" -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

echo.
echo ======================================
echo  ✔ Keystore успішно створено!
echo  Файл: release-keystore.jks
echo ======================================
echo.
pause
