-- ============================================================================
-- 设置页界面树 / 云端脚本驱动 UI
-- ============================================================================
-- 说明：本文件是「设置页」界面的唯一结构来源。App 启动（或收到云脚本后）
--       读取本脚本并逐行渲染，因此你改这里的结构、文案、顺序、动作，
--       就等价于改设置了整套设置页界面 —— 推送到云端即可热更新，无需重装 APK。
--
-- 节点 kind 一览：
--   section   分区标题（title）
--   card      玻璃卡片容器（items：内部行的集合）
--   login     卡密登录状态卡
--   permission 权限管理状态卡（含重新检测 / Shizuku 授权）
--   row       跳转行（icon, title, subtitle|subbind, action）
--   density   显示密度拉条（iOS 液态风格滑条）
--   switch    开关行（icon, title, key, subtitle|subbind）
--   about     关于区（表盘 ID 工具 + GitHub 双卡）
--
-- subtitle：静态文本写 subtitle；需要跟随 App 状态则写 subbind（见下）：
--   subbind = "bgmode"    背景样式的实时显示名
--   subbind = "snowsub"   雪花特效开关副标题
--   subbind = "version"   当前版本
--   subbind = "scriptver" 云脚本版本
--   subbind = "announce"  公告状态
--
-- 行 if 条件（可选，用于条件渲染某行）：
--   if = "bgcolor"        仅当背景为「纯色」时显示「背景颜色」一行
-- ============================================================================
return {
  version = "2.0",
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

  -- ==========================================================================
  -- 导航与页面顺序（脚本驱动壳层）
  -- nav.tabs：底部主胶囊 tab；order：页面左右顺序（含设置设置钮入口）
  -- ==========================================================================
  nav = {
    tabs = {
      { key = "home",    icon = "home",    title = "主页" },
      { key = "modify",  icon = "build",   title = "修改" },
      { key = "history", icon = "history", title = "记录" },
    },
    order = { "home", "modify", "history", "settings" },
  },

  -- ==========================================================================
  -- 每屏结构（脚本驱动屏幕宿主）
  -- items 里可用：screenHeader / section / card / slot / spacer。
  -- slot 嵌入原生重交互组件（登录门禁、修改编辑面、历史列表、设置）。
  -- 修改这里的结构 / 顺序 / 标题即可云更新整套界面外壳。
  -- ==========================================================================
  screens = {
    home     = { items = { { kind = "slot", slot = "home" } } },
    modify   = { items = { { kind = "slot", slot = "modify" } } },
    history  = { items = { { kind = "slot", slot = "history" } } },
    settings = { items = { { kind = "slot", slot = "settings" } } },
  },

}