#!/bin/bash

# g.sh - Git快捷命令工具（Bash版）
# 用法: ./g.sh <命令> [参数]

# 显示帮助信息
show_help() {
    echo "用法: ./g.sh <命令> [参数]"
    echo ""
    echo "可用命令:"
    echo "  s, status        - 显示工作区状态 (git status)"
    echo "  a, add           - 添加文件内容到暂存区 (git add)"
    echo "  c, commit        - 提交更改 (git commit)"
    echo "  p, push          - 推送到远程仓库 (git push)"
    echo "  pl, pull         - 从远程仓库拉取 (git pull)"
    echo "  f, fetch         - 从远程仓库获取 (git fetch)"
    echo "  b, branch        - 列出、创建或删除分支 (git branch)"
    echo "  co, checkout     - 切换分支或恢复工作区文件 (git checkout)"
    echo "  m, merge         - 合并两个或更多开发历史 (git merge)"
    echo "  st, stash        - 暂存工作区更改 (git stash)"
    echo "  l, log           - 显示提交日志 (git log)"
    echo "  d, diff          - 显示更改 (git diff)"
    echo "  r, reset         - 重置当前HEAD到指定状态 (git reset)"
    echo "  cl, clone        - 克隆仓库 (git clone)"
    echo "  i, init          - 创建一个空的Git仓库 (git init)"
    echo "  ap, push-all     - 一键提交并推送所有更改 (git add -A; git commit -m '消息'; git push)"
}

# 如果没有提供命令，显示帮助信息
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

# 获取命令和参数
cmd="$1"
shift
params="$*"

# 执行Git命令
exec_git() {
    local git_cmd="$1"
    local git_params="$2"
    echo "> git $git_cmd $git_params"
    git $git_cmd $git_params
    return $?
}

# 处理各种命令
case "$cmd" in
    s|status)
        exec_git "status" "$params"
        ;;
    a|add)
        exec_git "add" "$params"
        ;;
    c|commit)
        exec_git "commit" "$params"
        ;;
    p|push)
        exec_git "push" "$params"
        ;;
    pl|pull)
        exec_git "pull" "$params"
        ;;
    f|fetch)
        exec_git "fetch" "$params"
        ;;
    b|branch)
        exec_git "branch" "$params"
        ;;
    co|checkout)
        exec_git "checkout" "$params"
        ;;
    m|merge)
        exec_git "merge" "$params"
        ;;
    st|stash)
        exec_git "stash" "$params"
        ;;
    l|log)
        exec_git "log" "$params"
        ;;
    d|diff)
        exec_git "diff" "$params"
        ;;
    r|reset)
        exec_git "reset" "$params"
        ;;
    cl|clone)
        exec_git "clone" "$params"
        ;;
    i|init)
        exec_git "init" "$params"
        ;;
    ap|push-all)
        if [ -z "$params" ]; then
            echo "错误: 缺少提交信息"
            echo "用法: ./g.sh ap '提交信息'"
            exit 1
        fi
        
        exec_git "add" "-A"
        if [ $? -ne 0 ]; then exit $?; fi
        
        exec_git "commit" "-m \"$params\""
        if [ $? -ne 0 ]; then exit $?; fi
        
        exec_git "push" ""
        ;;
    *)
        echo "未知命令: $cmd"
        show_help
        exit 1
        ;;
esac

exit $? 