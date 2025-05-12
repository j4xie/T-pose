#!/bin/bash

# git-push.sh - Linux/Mac系统的Bash一键提交脚本
# 用法: ./git-push.sh "提交信息" [分支名]

# 检查是否提供了提交信息
if [ -z "$1" ]; then
    echo "错误: 缺少提交信息"
    echo "用法: ./git-push.sh \"提交信息\" [分支名]"
    exit 1
fi

# 保存当前目录路径
CURRENT_DIR=$(pwd)

# 查找Git根目录
find_git_root() {
    local current_path="$PWD"
    while [[ "$current_path" != "" && ! -d "$current_path/.git" ]]; do
        current_path=${current_path%/*}
    done
    echo "$current_path"
}

GIT_ROOT=$(find_git_root)
if [ -z "$GIT_ROOT" ]; then
    echo "错误: 当前目录不在Git仓库中"
    exit 1
fi

# 返回到用户原始目录
cd "$CURRENT_DIR" || exit 1

echo "正在执行Git操作..."
echo "添加所有更改..."
git add -A

echo "提交更改..."
git commit -m "$1"
if [ $? -ne 0 ]; then
    echo "提交失败！"
    exit 1
fi

# 获取当前分支
CURRENT_BRANCH=$(git branch --show-current)

# 如果提供了分支名，则推送到指定分支，否则使用当前分支
if [ -z "$2" ]; then
    BRANCH="$CURRENT_BRANCH"
else
    BRANCH="$2"
fi

echo "推送更改到远程仓库的 $BRANCH 分支..."
git push origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "推送失败！"
    exit 1
fi

echo "操作完成！已成功提交并推送更改到 $BRANCH 分支。"
exit 0 