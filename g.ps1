# g.ps1 - Git快捷命令工具（PowerShell版）
# 用法: .\g.ps1 <命令> [参数]

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Params
)

# 显示帮助信息
function Show-Help {
    Write-Host "用法: .\g.ps1 <命令> [参数]"
    Write-Host ""
    Write-Host "可用命令:"
    Write-Host "  s, status        - 显示工作区状态 (git status)"
    Write-Host "  a, add           - 添加文件内容到暂存区 (git add)"
    Write-Host "  c, commit        - 提交更改 (git commit)"
    Write-Host "  p, push          - 推送到远程仓库 (git push)"
    Write-Host "  pl, pull         - 从远程仓库拉取 (git pull)"
    Write-Host "  f, fetch         - 从远程仓库获取 (git fetch)"
    Write-Host "  b, branch        - 列出、创建或删除分支 (git branch)"
    Write-Host "  co, checkout     - 切换分支或恢复工作区文件 (git checkout)"
    Write-Host "  m, merge         - 合并两个或更多开发历史 (git merge)"
    Write-Host "  st, stash        - 暂存工作区更改 (git stash)"
    Write-Host "  l, log           - 显示提交日志 (git log)"
    Write-Host "  d, diff          - 显示更改 (git diff)"
    Write-Host "  r, reset         - 重置当前HEAD到指定状态 (git reset)"
    Write-Host "  cl, clone        - 克隆仓库 (git clone)"
    Write-Host "  i, init          - 创建一个空的Git仓库 (git init)"
    Write-Host "  ap, push-all     - 一键提交并推送所有更改 (git add -A; git commit -m '消息'; git push)"
}

# 如果没有提供命令，显示帮助信息
if ([string]::IsNullOrEmpty($Command)) {
    Show-Help
    exit 0
}

# 组合剩余参数为一个字符串
$ParamsString = $Params -join " "

# 执行Git命令
function Invoke-GitCommand {
    param (
        [string]$GitCommand,
        [string]$GitParams
    )
    
    $fullCommand = "git $GitCommand $GitParams"
    Write-Host "> $fullCommand" -ForegroundColor Cyan
    Invoke-Expression $fullCommand
    return $LASTEXITCODE
}

# 处理各种命令
switch ($Command) {
    { $_ -in "s", "status" } {
        return Invoke-GitCommand -GitCommand "status" -GitParams $ParamsString
    }
    { $_ -in "a", "add" } {
        return Invoke-GitCommand -GitCommand "add" -GitParams $ParamsString
    }
    { $_ -in "c", "commit" } {
        return Invoke-GitCommand -GitCommand "commit" -GitParams $ParamsString
    }
    { $_ -in "p", "push" } {
        return Invoke-GitCommand -GitCommand "push" -GitParams $ParamsString
    }
    { $_ -in "pl", "pull" } {
        return Invoke-GitCommand -GitCommand "pull" -GitParams $ParamsString
    }
    { $_ -in "f", "fetch" } {
        return Invoke-GitCommand -GitCommand "fetch" -GitParams $ParamsString
    }
    { $_ -in "b", "branch" } {
        return Invoke-GitCommand -GitCommand "branch" -GitParams $ParamsString
    }
    { $_ -in "co", "checkout" } {
        return Invoke-GitCommand -GitCommand "checkout" -GitParams $ParamsString
    }
    { $_ -in "m", "merge" } {
        return Invoke-GitCommand -GitCommand "merge" -GitParams $ParamsString
    }
    { $_ -in "st", "stash" } {
        return Invoke-GitCommand -GitCommand "stash" -GitParams $ParamsString
    }
    { $_ -in "l", "log" } {
        return Invoke-GitCommand -GitCommand "log" -GitParams $ParamsString
    }
    { $_ -in "d", "diff" } {
        return Invoke-GitCommand -GitCommand "diff" -GitParams $ParamsString
    }
    { $_ -in "r", "reset" } {
        return Invoke-GitCommand -GitCommand "reset" -GitParams $ParamsString
    }
    { $_ -in "cl", "clone" } {
        return Invoke-GitCommand -GitCommand "clone" -GitParams $ParamsString
    }
    { $_ -in "i", "init" } {
        return Invoke-GitCommand -GitCommand "init" -GitParams $ParamsString
    }
    { $_ -in "ap", "push-all" } {
        if ([string]::IsNullOrEmpty($ParamsString)) {
            Write-Host "错误: 缺少提交信息" -ForegroundColor Red
            Write-Host "用法: .\g.ps1 ap '提交信息'" -ForegroundColor Yellow
            return 1
        }
        
        Invoke-GitCommand -GitCommand "add" -GitParams "-A"
        if ($LASTEXITCODE -ne 0) { return $LASTEXITCODE }
        
        Invoke-GitCommand -GitCommand "commit" -GitParams "-m `"$ParamsString`""
        if ($LASTEXITCODE -ne 0) { return $LASTEXITCODE }
        
        return Invoke-GitCommand -GitCommand "push" -GitParams ""
    }
    default {
        Write-Host "未知命令: $Command" -ForegroundColor Red
        Show-Help
        return 1
    }
} 