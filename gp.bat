@echo off
chcp 65001 > nul
:: gp.bat - gitpush.bat的快捷方式
:: 用法: gp "提交信息"

call gitpush.bat %* 