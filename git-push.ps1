# git-push.ps1 - PowerShell版本的一键提交脚本
# 用法: .\git-push.ps1 "提交信息" [分支名]

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$CommitMessage,
    
    [Parameter(Mandatory=$false, Position=1)]
    [string]$BranchName
)

# 保存当前目录路径
$currentDir = Get-Location

# 查找Git根目录
function Find-GitRoot {
    $path = Get-Location
    while (-not (Test-Path (Join-Path $path '.git'))) {
        $parent = Split-Path -Parent $path
        if ($parent -eq $path) {
            # 已经到达根目录，没有找到.git文件夹
            return $null
        }
        $path = $parent
    }
    return $path
}

$gitRoot = Find-GitRoot
if ($null -eq $gitRoot) {
    Write-Error "错误: 当前目录不在Git仓库中"
    Set-Location $currentDir
    exit 1
}

# 返回到用户原始目录
Set-Location $currentDir

Write-Host "正在执行Git操作..." -ForegroundColor Cyan
Write-Host "添加所有更改..." -ForegroundColor Cyan
git add -A

Write-Host "提交更改..." -ForegroundColor Cyan
git commit -m "$CommitMessage"
if ($LASTEXITCODE -ne 0) {
    Write-Error "提交失败！"
    exit 1
}

# 获取当前分支
$currentBranch = git branch --show-current

# 如果提供了分支名，则推送到指定分支，否则使用当前分支
if ([string]::IsNullOrEmpty($BranchName)) {
    $branchToUse = $currentBranch
} else {
    $branchToUse = $BranchName
}

Write-Host "推送更改到远程仓库的 $branchToUse 分支..." -ForegroundColor Cyan
git push origin $branchToUse
if ($LASTEXITCODE -ne 0) {
    Write-Error "推送失败！"
    exit 1
}

Write-Host "操作完成！已成功提交并推送更改到 $branchToUse 分支。" -ForegroundColor Green
exit 0 