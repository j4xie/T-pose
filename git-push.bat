@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

:: git-push.bat - 另一个一键提交的批处理脚本
:: 用法: git-push "提交信息" [分支名]

if "%~1"=="" (
    echo 错误: 缺少提交信息
    echo 用法: git-push "提交信息" [分支名]
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

:: 获取当前分支
for /f "tokens=* usebackq" %%a in (`git branch --show-current`) do (
    set "CURRENT_BRANCH=%%a"
)

:: 如果提供了分支名，则推送到指定分支，否则使用当前分支
if not "%~2"=="" (
    set "BRANCH=%~2"
) else (
    set "BRANCH=!CURRENT_BRANCH!"
)

echo 推送更改到远程仓库的 !BRANCH! 分支...
git push origin !BRANCH!
if %ERRORLEVEL% neq 0 (
    echo 推送失败！
    exit /b 1
)

echo 操作完成！已成功提交并推送更改到 !BRANCH! 分支。
exit /b 0 