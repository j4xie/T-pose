@echo off
:: g.bat - Git快捷命令工具（Windows版）
:: 用法: g <命令> [参数]

setlocal enabledelayedexpansion
chcp 65001 > nul

if "%~1"=="" (
    echo 用法: g ^<命令^> [参数]
    echo.
    echo 可用命令:
    echo   s, status        - 显示工作区状态 (git status)
    echo   a, add           - 添加文件内容到暂存区 (git add)
    echo   c, commit        - 提交更改 (git commit)
    echo   p, push          - 推送到远程仓库 (git push)
    echo   pl, pull         - 从远程仓库拉取 (git pull)
    echo   f, fetch         - 从远程仓库获取 (git fetch)
    echo   b, branch        - 列出、创建或删除分支 (git branch)
    echo   co, checkout     - 切换分支或恢复工作区文件 (git checkout)
    echo   m, merge         - 合并两个或更多开发历史 (git merge)
    echo   st, stash        - 暂存工作区更改 (git stash)
    echo   l, log           - 显示提交日志 (git log)
    echo   d, diff          - 显示更改 (git diff)
    echo   r, reset         - 重置当前HEAD到指定状态 (git reset)
    echo   cl, clone        - 克隆仓库 (git clone)
    echo   i, init          - 创建一个空的Git仓库 (git init)
    echo   ap, push-all     - 一键提交并推送所有更改 (git add -A; git commit -m "消息"; git push)
    exit /b 0
)

set "cmd=%~1"
set "params=%*"
set "params=!params:*%1=!"
if "!params:~0,1!"==" " set "params=!params:~1!"

:: 处理各种命令
if "%cmd%"=="s" goto :status
if "%cmd%"=="status" goto :status
if "%cmd%"=="a" goto :add
if "%cmd%"=="add" goto :add
if "%cmd%"=="c" goto :commit
if "%cmd%"=="commit" goto :commit
if "%cmd%"=="p" goto :push
if "%cmd%"=="push" goto :push
if "%cmd%"=="pl" goto :pull
if "%cmd%"=="pull" goto :pull
if "%cmd%"=="f" goto :fetch
if "%cmd%"=="fetch" goto :fetch
if "%cmd%"=="b" goto :branch
if "%cmd%"=="branch" goto :branch
if "%cmd%"=="co" goto :checkout
if "%cmd%"=="checkout" goto :checkout
if "%cmd%"=="m" goto :merge
if "%cmd%"=="merge" goto :merge
if "%cmd%"=="st" goto :stash
if "%cmd%"=="stash" goto :stash
if "%cmd%"=="l" goto :log
if "%cmd%"=="log" goto :log
if "%cmd%"=="d" goto :diff
if "%cmd%"=="diff" goto :diff
if "%cmd%"=="r" goto :reset
if "%cmd%"=="reset" goto :reset
if "%cmd%"=="cl" goto :clone
if "%cmd%"=="clone" goto :clone
if "%cmd%"=="i" goto :init
if "%cmd%"=="init" goto :init
if "%cmd%"=="ap" goto :pushall
if "%cmd%"=="push-all" goto :pushall

echo 未知命令: %cmd%
exit /b 1

:status
git status %params%
exit /b %ERRORLEVEL%

:add
git add %params%
exit /b %ERRORLEVEL%

:commit
git commit %params%
exit /b %ERRORLEVEL%

:push
git push %params%
exit /b %ERRORLEVEL%

:pull
git pull %params%
exit /b %ERRORLEVEL%

:fetch
git fetch %params%
exit /b %ERRORLEVEL%

:branch
git branch %params%
exit /b %ERRORLEVEL%

:checkout
git checkout %params%
exit /b %ERRORLEVEL%

:merge
git merge %params%
exit /b %ERRORLEVEL%

:stash
git stash %params%
exit /b %ERRORLEVEL%

:log
git log %params%
exit /b %ERRORLEVEL%

:diff
git diff %params%
exit /b %ERRORLEVEL%

:reset
git reset %params%
exit /b %ERRORLEVEL%

:clone
git clone %params%
exit /b %ERRORLEVEL%

:init
git init %params%
exit /b %ERRORLEVEL%

:pushall
if "%params%"=="" (
    echo 错误: 缺少提交信息
    echo 用法: g ap "提交信息"
    exit /b 1
)
git add -A
git commit -m "%params%"
git push
exit /b %ERRORLEVEL% 