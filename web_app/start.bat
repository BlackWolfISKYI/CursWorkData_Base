@echo off
echo ================================================
echo   Запуск веб-додатку AirSoft Shop
echo ================================================
echo.

REM Перевірка наявності Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python не встановлено!
    echo Завантажте Python з https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Python встановлено

REM Перевірка віртуального середовища
if not exist "venv" (
    echo.
    echo Створення віртуального середовища...
    python -m venv venv
    if errorlevel 1 (
        echo [ERROR] Не вдалося створити віртуальне середовище
        pause
        exit /b 1
    )
    echo [OK] Віртуальне середовище створено
)

REM Встановлення залежностей
echo.
echo Встановлення залежностей...

REM Спочатку встановлюємо pyodbc з бінарним wheel
echo Встановлення pyodbc...
venv\Scripts\python.exe -m pip install --only-binary :all: pyodbc
if errorlevel 1 (
    echo [ERROR] Помилка встановлення pyodbc
    pause
    exit /b 1
)

REM Тепер встановлюємо решту
echo Встановлення Flask та Flask-Login...
venv\Scripts\python.exe -m pip install Flask Flask-Login
if errorlevel 1 (
    echo [ERROR] Помилка встановлення Flask
    pause
    exit /b 1
)

echo.
echo [OK] Всі залежності встановлено
echo.
echo ================================================
echo   Запуск Flask додатку...
echo ================================================
echo.
echo Відкрийте браузер: http://localhost:5000
echo Для зупинки натисніть Ctrl+C
echo.

REM Запуск додатку через Python з віртуального середовища
venv\Scripts\python.exe app.py

pause
