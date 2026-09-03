-- ============================================================================
-- 唯一的云端脚本：main.lua
-- ============================================================================
-- 空壳 APK 启动时仅从云端拉取本文件并缓存，所有功能逻辑与界面定义都在此。
--   分段说明：
--     rules     表盘文件解析规则（Magic / ID / 名称偏移与位长）
--     models    设备型号 → 显示名映射
--     strings   云端文案覆盖表
--     ui       界面结构（settings 设置页树 / nav 导航 / screens 各屏 / quickActions 快捷入口）
--     functions 云端功能包（每个功能 key = { name, icon, run(ctx) }，用 cap 原语组合真实流程）
-- 改这里任意一段并推送云端，已装用户即可热更功能 / 界面，无需重新 APK。
-- ============================================================================
return {

  -- --------------------------------------------------------------------------
  -- rules：表盘文件解析规则
  -- 若小米调整表盘格式，更新此段推送云端即可热更，无需发版。
  -- --------------------------------------------------------------------------
  rules = {
    version = "1.0",

    -- Magic 校验值（little-endian）
    magic = 0x1234A55A,
    magicOffset = 0x00,

    -- ID 字段
    idOffset = 0x28,
    idFieldSize = 64,
    -- 合法 ID 位数（可热更：如未来出现 10/13 位 ID）
    validLengths = { 9, 12 },

    -- 名称字段
    nameOffset = 0x68,
    nameFieldSize = 64
  },

  -- --------------------------------------------------------------------------
  -- models：设备型号 → 显示名映射
  -- 新机型只需在 models 数组追加一条，推送云端即可热更新。
  -- --------------------------------------------------------------------------
  models = {
    version = "1.0",
    models = {
      { "miwear.watch.p65", "REDMI Watch 6" },
      { "miwear.watch.m67", "Xiaomi Watch S4" },
      { "miwear.watch.n67", "Xiaomi Watch S4 Sport" },
      { "zhizao.watch.n67", "Xiaomi Watch S4 Sport" },
      { "miwear.watch.l62", "Redmi Watch 4" },
      { "miwear.watch.m62", "Xiaomi Watch S3" },
      { "miwear.watch.n62", "Xiaomi Watch S3" }
    }
  },

  -- --------------------------------------------------------------------------
  -- strings：云端文案覆盖表（key → 文本）
  -- --------------------------------------------------------------------------
  strings = {
    version = "1.0",
    strings = {
      { "nav_home", "主页" },
      { "nav_modify", "修改" },
      { "nav_history", "记录" },
      { "about_title", "表盘 ID 工具" },
      { "about_subtitle", "WATCHFACE ID TOOL" },
      { "update_title", "检查更新" }
    }
  },

  -- --------------------------------------------------------------------------
  -- ui：界面结构（脚本驱动 UI）
  -- --------------------------------------------------------------------------
  ui = {
    version = "2.0",

    -- 设置页界面树
    settings = {
      { kind = "section", title = "卡密登录" },
      { kind = "login" },

      { kind = "section", title = "权限管理" },
      { kind = "permission" },

      { kind = "section", title = "界面与语言" },
      { kind = "card", items = {
          { kind = "row",    icon = "language",    title = "语言",     subtitle = "简体中文",   action = "lang" },
          { kind = "density" },
          { kind = "switch", icon = "music",       title = "点击音效", key = "sound",     subtitle = "按钮与开关点击时的声音反馈" },
          { kind = "switch", icon = "vibration",   title = "震动效果", key = "vibration", subtitle = "不同控件适配不同震动节奏" },
      } },

      { kind = "section", title = "背景与外观" },
      { kind = "card", items = {
          { kind = "row",    icon = "wallpaper",   title = "背景样式", subbind = "bgmode",  action = "bg" },
          { kind = "row",    icon = "palette",     title = "背景颜色", subtitle = "自定义纯色（深色调）", action = "bgcolor", ["if"] = "bgcolor" },
          { kind = "switch", icon = "acunit",      title = "雪花飘落", key = "snow",  subbind = "snowsub" },
      } },

      { kind = "section", title = "应用与更新" },
      { kind = "card", items = {
          { kind = "row",    icon = "cloud",        title = "检查更新",     subbind = "version",   action = "update" },
          { kind = "row",    icon = "code",         title = "云脚本规则",   subbind = "scriptver", action = "scripts" },
          { kind = "row",    icon = "info",         title = "查看公告",     subbind = "announce",  action = "announce" },
          { kind = "switch", icon = "notifications", title = "启动时显示公告", key = "announce", subtitle = "启动 App 时自动弹出新公告" },
      } },

      { kind = "section", title = "关于" },
      { kind = "about" },
    },

    -- 导航与页面顺序（脚本驱动壳层）
    nav = {
      tabs = {
        { key = "home",    icon = "home",    title = "主页" },
        { key = "modify",  icon = "build",   title = "修改" },
        { key = "history", icon = "history", title = "记录" },
        { key = "apps",    icon = "widgets", title = "云端" },
      },
      order = { "home", "modify", "history", "apps", "settings" },
    },

    -- 每屏结构（脚本驱动屏幕宿主）
    -- 节点：screenHeader / quickGrid / section / card / slot / button / textRow / spacer
    -- 云端可在此新增任意页面 key 并挂到 nav.tabs 上即得全新页面——整体改界面无需重装。
    screens = {
      home     = { items = { { kind = "slot", slot = "home" } } },
      modify   = { items = { { kind = "slot", slot = "modify" } } },
      history  = { items = { { kind = "slot", slot = "history" } } },
      settings = { items = { { kind = "slot", slot = "settings" } } },

      -- 纯脚本构造页面：不依赖任何原生 slot
      apps = { items = {
        { kind = "screenHeader", title = "App 中心", subtitle = "CLOUD DRIVEN" },
        { kind = "quickGrid" },
        { kind = "section", title = "功能专区" },
        { kind = "card", items = {
            { kind = "button", text = "一键导入表盘", action = "import" },
            { kind = "button", text = "检查 App 更新", action = "checkUpdate" },
            { kind = "button", text = "同步云脚本",   action = "checkScripts" },
            { kind = "button", text = "Shizuku 授权", action = "permission" },
            { kind = "button", text = "浏览仓库",     action = "openGithub" },
            { kind = "button", text = "提取日志 Key", action = "extract" },
        } },
        { kind = "textRow", text = "☁ 界面与功能完全由云端脚本驱动，推送云端即热更", color = "8A93A8", align = "center", size = 12 },
        { kind = "spacer", h = 16 },
      } },
    },

    -- 主页悬浮快捷功能入口（功能入口脚本化）
    quickActions = {
      items = {
        { text = "一键导入", action = "import" },
        { text = "检查更新", action = "checkUpdate" },
        { text = "云脚本",   action = "checkScripts" },
        { text = "权限授权", action = "permission" },
        { text = "浏览仓库", action = "openGithub" },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- functions：云端功能包（功能唯一真相源）
  -- 可用能力原语 cap.*：
  --   permission / reqShizuku / importPrivileged / importFilePerm / askPermission
  --   checkUpdate / checkScripts / extract / toast / nav / openGithub
  -- 改这里即云端热更整套功能，无需重装 APK。
  -- --------------------------------------------------------------------------
  functions = {

    -- 一键导入：按当前权限自动分路（决策逻辑在云端）
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

    -- 权限授权
    permission = {
      name = "权限授权",
      icon = "lock",
      run = function(ctx) cap.reqShizuku() end,
    },

    -- 检查更新
    checkUpdate = {
      name = "检查更新",
      icon = "cloud",
      run = function(ctx) cap.checkUpdate() end,
    },

    -- 云脚本同步
    checkScripts = {
      name = "云脚本",
      icon = "code",
      run = function(ctx) cap.checkScripts() end,
    },

    -- 提取 Key
    extract = {
      name = "提取 Key",
      icon = "key",
      run = function(ctx) cap.extract() end,
    },

    -- 浏览仓库
    openGithub = {
      name = "浏览仓库",
      icon = "github",
      run = function(ctx) cap.openGithub() end,
    },

    -- 页面导航
    goHome     = { name = "主页", icon = "home",     run = function(ctx) cap.nav("home") end },
    goModify   = { name = "修改", icon = "build",    run = function(ctx) cap.nav("modify") end },
    goHistory  = { name = "记录", icon = "history",  run = function(ctx) cap.nav("history") end },
    goSettings = { name = "设置", icon = "settings", run = function(ctx) cap.nav("settings") end },

  },

}