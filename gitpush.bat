@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

:: gitpush.bat - 一键执行git add/commit/push的Windows批处理脚本
:: 用法: gitpush "提交信息"

if "%~1"=="" (
    echo 错误: 缺少提交信息
    echo 用法: gitpush "提交信息"
    exit /b 1
)

:: 保存当前目录路径
set "CURRENT_DIR=%CD%"

:: 查找Git根目录
:FIND_GIT_ROOT
if exist "%CD%\.git" (
    set "GIT_ROOT=%CD%"
) else (
    cd ..
    if "%CD%"=="%CURRENT_DIR%" (
        echo 错误: 当前目录不在Git仓库中
        cd "%CURRENT_DIR%"
        exit /b 1
    )
    goto FIND_GIT_ROOT
)

:: 返回到用户原始目录
cd "%CURRENT_DIR%"

echo 正在执行Git操作...
echo 添加所有更改...
git add -A

echo 提交更改...
git commit -m "%~1"
if %ERRORLEVEL% neq 0 (
    echo 提交失败！
    exit /b 1
)

echo 推送更改到远程仓库...
git push
if %ERRORLEVEL% neq 0 (
    echo 推送失败！
    exit /b 1
)

echo 操作完成！已成功提交并推送更改。
exit /b 0 