# herdr-app-mods

A set of customizations for the [Herdr](https://herdr.dev) desktop app (the herdr-core backed GUI, not the herdr TUI). This is not an official Herdr project.

[中文说明见下方](#中文)

## What's in it

| Path | What it does |
|---|---|
| `mods/agents-title/` | A modified copy of Herdr's **Agents** sidebar list (see below). |
| `mods/spaces-fold/` | A copy of Herdr's **Spaces** list that also publishes which machines are folded, so the Agents list can fold with it. After each space's name it shows an icon and count per kind of agent in it (e.g. Claude Code ×2, agy ×1), colored by the most urgent one. A branch other than main/master, and ahead/behind, go on a second line under the name. |
| `mods/picker-title/` | A copy of Herdr's search **picker** that labels and matches unnamed tabs by their agent's title, as the tab strip does, instead of by tab number. |
| `mods/workspace-chrome-title/` | A copy of Herdr's sidebar header and footer whose search button opens `picker-title`. |
| `mods/tabs-spin/`, `mods/pane-spin/` | Copies of Herdr's tab strip and pane header with the same status icons and character spinner as the Agents list. |
| `layouts/my-main.json` | A copy of Herdr's `main` layout that uses the mods above and the `ghostty` theme. |
| `keys.example.json` | My full key bindings: Cmd+P opens the command palette; Cmd+Shift+P and Cmd+Shift+W open `picker-title`; Cmd+Up/Down switch spaces, Cmd+Left/Right switch tabs, Cmd+[ / ] move between panes left/right, Cmd+Shift+[ / ] up/down, Cmd+W closes the pane, Cmd+R / Cmd+Shift+R rename the tab / space, Cmd+Ctrl+W closes the space. Merged into `keys.json` key by key; bindings not listed here stay. |
| `themes/ghostty.json` | Ghostty's default color scheme (background `#282c34`, its 16 ANSI colors), plus fixed status colors: working blue `#7aa6da`, done green `#b9ca4a`, needs-you red `#d54e53`. |
| `settings.example.json` | Look settings merged into `settings.json`: theme, Maple Mono CN at 13 px for terminals, PingFang SC for the interface, light weight (300, since Herdr draws text heavier than Ghostty), programming ligatures on. |

### Agents list changes (`agents-title`)

- **Grouped by space** by default, each row showing the agent's session title (e.g. Claude Code's terminal title) instead of the folder name.
- **Within each space**, agents sort by urgency, then by latest activity: needs you, done, working, idle; in each of those, the most recent status change comes first. Spaces keep their order.
- In the Priority view, the **title leads** and the space name follows, dimmed, so the title is no longer cut off.
- **Folding a remote machine in Spaces folds its agents too.** Pinned agents and agents that need you stay visible.
- The working spinner is a character spinner, 8-dot braille `⣾⣽⣻⢿⡿⣟⣯⣷` in Maple Mono CN at 16 px bold, instead of a turning ring icon. It uses Herdr's native `.frames()` (90 ms a frame), so it costs no timer. The search picker, tab strip and pane header use the same spinner.

### Status icons, the same everywhere

Each status has its own shape, so it doesn't rely on color alone, and the same icon in every place:

| Status | Agents list | Tab strip | Pane header | Spaces rail | Picker |
|---|---|---|---|---|---|
| Needs you | `Needs you` badge / `!` | `!` badge | `Needs you` badge | `!` | `!` |
| Done | green check, **bold title** | green check | green `Done` badge | `✓` | green check |
| Working | `⣾` braille spinner | `⣾` braille spinner | `⣾` braille spinner | – | `⣾` braille spinner |
| Idle | dim ring | – | – | `·` | `○` |

Herdr turns done into idle once you look at the agent, so the check and bold title go away by themselves.

## Install

```sh
git clone https://github.com/kingcanfish/herdr-app-mods.git
cd herdr-app-mods
./install.sh               # mods, layout, theme, and the look settings
./install.sh --no-settings # same, but leave your settings.json alone
```

- It installs into `~/.config/herdr-app`, or `$HERDR_APP_HOME` if set. Open Herdr once first so that folder exists.
- It backs up everything it replaces to `backups/herdr-app-mods-<time>/` in that folder.
- It switches the running app to the `my-main` layout. To switch back to Herdr's own layout, choose `main` under Switch layout in the command palette.
- The layout file sets `"theme": "ghostty"`, which overrides a theme picked earlier in Herdr's theme picker. If you pick another theme there later, that pick takes over again.
- If Maple Mono CN isn't installed, Herdr falls back to JetBrains Mono.

## After a Herdr update

The mods here are copies of Herdr's `agents`, `spaces`, `picker`, `workspace-chrome`, `tabs` and `pane` mods as of version **0.1.18**, so they don't pick up later changes to those mods. If the sidebar breaks after an update, re-clone the shipped mods and apply the edits again. Every change is marked in `main.js` with a comment naming its mod (`agents-title:`, `spaces-fold:`, `picker-title:`, `workspace-chrome-title:`), which makes them easy to find with `grep`.

```sh
herdr-app do mod.clone '{"name":"agents","as":"agents-title"}'
herdr-app do mod.clone '{"name":"spaces","as":"spaces-fold"}'
herdr-app do mod.clone '{"name":"picker","as":"picker-title"}'
herdr-app do mod.clone '{"name":"workspace-chrome","as":"workspace-chrome-title"}'
herdr-app do mod.clone '{"name":"tabs","as":"tabs-spin"}'
herdr-app do mod.clone '{"name":"pane","as":"pane-spin"}'
herdr-app check ~/.config/herdr-app/mods/agents-title
```

## License

Apache License 2.0, the same license as Herdr, whose shipped mods these files are derived from. See [NOTICE](NOTICE) for what was changed.

---

## 中文

给 [Herdr](https://herdr.dev) 桌面 app 做的一套定制。适用于后端是 herdr-core 的 GUI 版，不适用于 herdr TUI。这不是 Herdr 官方项目。

### 内容

- **`mods/agents-title/`**：改过的左下角 Agents 列表
  - 默认按空间分组，每行显示会话标题，不再显示文件夹名
  - 空间内先按状态排（Needs you > Done > Working > Idle），同一状态下最近有变化的排在前面
  - Priority 视图里标题在前、空间名在后
  - 在 Spaces 里折叠远程机器时，这台机器上的会话也会一起收起；置顶的会话和需要你处理的会话不会被藏起来
  - 运行中改为字符转圈：8 点盲文 `⣾⣽⣻⢿⡿⣟⣯⣷`，Maple Mono CN 16px 加粗，用 Herdr 原生的 `.frames()`（每帧 90ms），不占定时器
  - 完成显示绿色圆圈勾，标题加粗（像未读邮件），看过后自动恢复
- **`mods/spaces-fold/`**：Spaces 列表的副本，把哪些机器被折叠了共享给 Agents 列表；每个空间名字后面按 Agent 种类显示图标和数量（比如 Claude Code 2 个、agy 1 个），颜色取其中最紧急的状态；不是 main/master 的分支名和领先/落后提交数放在名字下面的第二行
- **`mods/picker-title/`**：搜索框的副本。没命名的标签页和顶部标签栏一样显示 Agent 标题，不再显示编号，也能按标题搜索
- **`mods/tabs-spin/`、`mods/pane-spin/`**：顶部标签栏和 pane 标题栏的副本，状态图标和字符转圈与 Agents 列表一致
- **`mods/workspace-chrome-title/`**：侧栏顶部和底部的副本，只改了一处：放大镜按钮打开 `picker-title`
- **`layouts/my-main.json`**：使用上面这些 mod 和 ghostty 主题的布局
- **`keys.example.json`**：我的完整快捷键。`Cmd+P` 打开命令面板；`Cmd+Shift+P`、`Cmd+Shift+W` 打开 `picker-title`；`Cmd+↑/↓` 切换空间，`Cmd+←/→` 切换标签，`Cmd+[ / ]` 左右切换窗格，`Cmd+Shift+[ / ]` 上下切换窗格，`Cmd+W` 关闭窗格，`Cmd+R` / `Cmd+Shift+R` 重命名标签 / 空间，`Cmd+Ctrl+W` 关闭空间。安装时按键逐条合并进 `keys.json`，这里没列的快捷键保持不变
- **`themes/ghostty.json`**：Ghostty 默认配色，并固定了状态颜色：运行中蓝 `#7aa6da`、完成绿 `#b9ca4a`、需要你红 `#d54e53`
- **状态图标统一**：每种状态有自己的形状，不只靠颜色。需要你是 `Needs you` 标签或 `!`；完成是绿色勾（窗格标题是绿色 `Done` 标签，Spaces 收起时是 `✓`）；运行中是盲文字符转圈；空闲是暗色空心圈。Agents 列表、标签栏、窗格标题、Spaces、搜索框都一样
- **`settings.example.json`**：外观设置，终端字体为 Maple Mono CN，字号 13，界面字体为苹方（PingFang SC），字重 300（Herdr 渲染比 Ghostty 偏粗），开启编程连字

### 安装

```sh
git clone https://github.com/kingcanfish/herdr-app-mods.git
cd herdr-app-mods
./install.sh                # 安装全部，包括字体和主题设置
./install.sh --no-settings  # 不改 settings.json
```

- 安装前请先打开一次 Herdr，确保 `~/.config/herdr-app` 已经存在。
- 被覆盖的文件会先备份到 `~/.config/herdr-app/backups/` 里。
- 安装完会自动切换到 `my-main` 布局。想换回官方布局，在命令面板的 Switch layout 里选 `main`。

### Herdr 更新后

这些 mod 是从 Herdr 0.1.18 的官方 mod 复制来改的，Herdr 更新后它们不会跟着更新。如果侧栏显示出了问题，需要重新复制官方 mod，再把改动加回去。改动的地方在 `main.js` 里都标了以 mod 名开头的注释（如 `agents-title:`、`picker-title:`），可以直接搜索找到。
