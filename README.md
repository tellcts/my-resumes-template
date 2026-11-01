# my-resumes-template

用私有 Git 仓库管理自己的简历，同步上游仓库
[resumes-CV](https://github.com/tellcts/resumes-CV) 的模板更新。

仓库分成两层：

- `template-tzcan/`：你的简历内容、照片和多个岗位版本。
- `vendor/resumes-CV/`：上游模板，只负责提供 LaTeX 样式。

外层仓库会记录简历内容和模板版本。更新模板不会覆盖个人简历，个人资料也不会进入上游模板。

## 项目结构

```text
my-resumes-template/
├── template-tzcan/
│   ├── main.tex            # 默认简历
│   ├── devops.tex          # 其他岗位简历示例
│   ├── assets/             # 证件照、校徽等
│   ├── scripts/            # Docker 编译脚本
│   └── build/              # PDF 和中间文件，不提交
└── vendor/
    └── resumes-CV/         # 上游模板子模块，不要放个人内容
```

## 第一次使用

### 1. 创建私有仓库

打开
[my-resumes-template](https://github.com/tellcts/my-resumes-template)，
点击 **Use this template → Create a new repository**，把新仓库设为 **Private**。

### 2. 克隆并初始化子模块

将命令中的 `你的用户名` 换成 GitHub 用户名：

```bash
git clone --recurse-submodules https://github.com/你的用户名/my-resumes.git
cd my-resumes
```

如果克隆时忘了初始化子模块，在仓库根目录补执行：

```bash
# 将子模块代码检出到本地
git submodule update --init --recursive

# 查看子模块相关信息
git submodule status
```

### 3. 修改简历

日常只需要编辑 `template-tzcan/`：

- 修改 `main.tex` 中的姓名、联系方式和经历。
- 替换 `assets/images/person.png` 中的证件照。
- 修改或替换 `assets/badges/ecjtu.png` 中的水印。

字段的详细写法见
[tzcan 模板使用说明](https://github.com/tellcts/resumes-CV/blob/main/template-tzcan/USAGE.md)。

### 4. 编译 PDF

进入模板目录：

```bash
cd template-tzcan
```

使用本地 TeX Live：

```bash
# 编译指定简历模板文件
latexmk main.tex

# 保存后自动编译
latexmk -pvc main.tex
```

使用 Docker：
- Windows PowerShell
```powershell
# 默认编译 main.tex
.\scripts\docker-build.ps1

# 编译指定简历模板文件
.\scripts\docker-build.ps1 devops.tex
```
- MacOS / Linux
```bash
# 默认编译 main.tex
./scripts/docker-build.sh

# 编译指定简历模板文件
./scripts/docker-build.sh devops.tex
```

PDF 输出为 `template-tzcan/build/main.pdf`。

> [!IMPORTANT]
> 当前项目目录结构不适合使用 `Overleaf` 在线编译。

## 保存和推送

修改简历后，返回仓库根目录执行：

```bash
git add -A
git commit -m "feat: update resume"
git push
```

## 管理多份简历

以下命令在 `template-tzcan/` 目录执行。建议保留多个 `.tex` 文件，例如 `backend.tex`、`devops.tex`
和 `frontend.tex`，分别对应不同岗位。

复制默认简历：
- Windows
```powershell
Copy-Item .\main.tex .\backend.tex
```
- MacOS / Linux
```bash
cp main.tex backend.tex
```

修改新文件后，用文件名指定要编译的版本：

```bash
latexmk backend.tex
./scripts/docker-build.sh backend.tex
```
输出为 `build/backend.pdf`。多份简历长期放在同一分支即可，不必为每份简历单独建分支。

## 更新上游模板

在仓库根目录执行一条更新命令：

```bash
git submodule update --remote vendor/resumes-CV
```

然后进入 `template-tzcan/` 重新编译：

```bash
latexmk -g main.tex
```

确认正常后，回到仓库根目录提交：

```bash
cd ..
git add -A
git commit -m "chore: update resumes-CV"
git push
```

> [!WARNING]
> 不要在 `vendor/resumes-CV` 内执行 `git push`。该目录指向公共模板仓库，不是你的私人简历仓库。

## 模板更新后编译失败

- 暂未提交更新后的子模块，回退子模块版本：
```bash
git submodule update -- vendor/resumes-CV
```
- 如果已经提交并发现问题，撤销该次提交，再恢复子模块：
```bash
git revert --no-edit <commit-hash>
git push
```

## 隐私注意

- 个人仓库保持 Private。
- 不要修改后向 `vendor/resumes-CV` 推送个人内容。
- `build/` 默认不提交；公开仓库尤其不要提交带个人信息的 PDF、照片和日志。

## 常见问题

| 问题                      | 处理                                                                                      |
| ------------------------- | ----------------------------------------------------------------------------------------- |
| 找不到 `resume-tzcan.cls` | 在仓库根目录执行 `git submodule update --init --recursive`，再进入 `template-tzcan/` 编译 |
| Docker 找不到样式目录     | 检查 `vendor/resumes-CV/template-tzcan/styles/` 是否存在，并确认子模块已初始化            |
| 更新模板后编译失败        | 按“模板更新后编译失败”一节回退                                                            |
| `git push` 被拒绝         | 先执行 `git pull --rebase`，解决冲突后再推送                                              |
| 模板更新看不到效果        | 使用 `latexmk -g main.tex` 强制重新编译                                                   |
