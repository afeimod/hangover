# Hangover Proton 构建系统

## 概述

此项目为 Valve 的 Proton（基于 Wine 的游戏兼容层）提供 ARM64 构建支持，专门为 Hangover 项目优化。

## 构建要求

- GitHub Actions 运行器（推荐 8GB+ 内存）
- Docker 支持
- ARM64 或交叉编译环境

## 构建流程

### 1. 手动触发构建

通过 GitHub Actions 页面手动触发：
1. 进入 Actions → "Proton Build" 工作流
2. 点击 "Run workflow"
3. 选择参数：
   - Proton 版本（如 8.0）
   - 目标发行版（如 ubuntu2204,ubuntu2404）

### 2. 自动构建

- 推送标签 `proton-*` 时自动构建
- 发布 Release 时自动构建并上传资产
- 推送到 `proton/**` 分支时自动构建

## 目录结构
