-- ============================================================================
-- 云端功能包（功能唯一真相源）
-- ============================================================================
-- 说明：本文件决定「这个 App 有哪些功能、每个功能的按钮文案、以及执行流程」。
--       APK 只是空壳执行器——它不知道任何业务功能，只有一批底层能力原语
--       (cap.xxx)。每个功能 key 定义了一段 run(ctx)，用 cap 原语组合出真实流程。
--
--       App 里任何地方（快捷功能条 quickActions / 脚本按钮 action / 导航）通过
--       action = <功能key> 触发。改这里即云端热更整套功能，无需重装 APK。
--
-- 可用能力原语（cap.*，见 CapabilitiesBridge）：
--   cap.permission()       -> "ROOT" / "SHELL" / "FILE" / "NONE" / "CHECKING"
--   cap.reqShizuku()       请求 Shizuku 授权
--   cap.importPrivileged() 高权限扫描导入（Root / Shizuku）
--   cap.importFilePerm()   文件管理权限扫描导入（零宽空格路径）
--   cap.askPermission()    引导去授权（弹无权限对话框）
--   cap.checkUpdate()      检查 App 更新
--   cap.checkScripts()     同步云端脚本
--   cap.extract()          从日志 ZIP 提取 Key
--   cap.toast(msg)         弹 Toast
--   cap.nav(page)          切换页面 home/modify/history/settings
--   cap.openGithub()       打开 GitHub 仓库
-- ============================================================================
return {

  -- 一键导入：按当前权限状态自动分路（决策逻辑在云端）
  import = {
    name = "一键导入",
    icon = "download",
    run = function(ctx)
      local p = cap.permission()
      if p == "ROOT" or p == "SHELL" then
        cap.importPrivileged()
      elseif p == "FILE" then
        cap.importFilePerm()
      else
        cap.askPermission()
      end
    end,
  },

  -- 权限授权：触发 Shizuku 授权流程
  permission = {
    name = "权限授权",
    icon = "lock",
    run = function(ctx)
      cap.reqShizuku()
    end,
  },

  -- 检查更新：检查 App 是否有新版本
  checkUpdate = {
    name = "检查更新",
    icon = "cloud",
    run = function(ctx)
      cap.checkUpdate()
    end,
  },

  -- 云脚本：立即从云端同步最新脚本
  checkScripts = {
    name = "云脚本",
    icon = "code",
    run = function(ctx)
      cap.checkScripts()
    end,
  },

  -- 提取 Key：从日志 ZIP 提取 Token（需先选择 ZIP）
  extract = {
    name = "提取 Key",
    icon = "key",
    run = function(ctx)
      cap.extract()
    end,
  },

  -- 浏览仓库：打开 GitHub 项目页
  openGithub = {
    name = "浏览仓库",
    icon = "github",
    run = function(ctx)
      cap.openGithub()
    end,
  },

  -- 页面导航（快捷功能条等场景可复用）
  goHome = {
    name = "主页",
    icon = "home",
    run = function(ctx) cap.nav("home") end,
  },
  goModify = {
    name = "修改",
    icon = "build",
    run = function(ctx) cap.nav("modify") end,
  },
  goHistory = {
    name = "记录",
    icon = "history",
    run = function(ctx) cap.nav("history") end,
  },
  goSettings = {
    name = "设置",
    icon = "settings",
    run = function(ctx) cap.nav("settings") end,
  },

}