<div align="center">
    <img width="200" height="200" src="https://github.com/guozhigq/pilipala/blob/main/assets/images/logo/logo_android.png">
</div>

<div align="center">
    <h1>PiliPala</h1>
<div align="center">
    
![GitHub repo size](https://img.shields.io/github/repo-size/guozhigq/pilipala) 
![GitHub Repo stars](https://img.shields.io/github/stars/guozhigq/pilipala) 
![GitHub all releases](https://img.shields.io/github/downloads/guozhigq/pilipala/total) 

</div>
    <p>使用 Flutter 开发的 BiliBili 第三方客户端</p>
    
<img src="https://github.com/guozhigq/pilipala/blob/main/assets/screenshots/510shots_so.png" width="32%" alt="home" />
<img src="https://github.com/guozhigq/pilipala/blob/main/assets/screenshots/174shots_so.png" width="32%" alt="home" />
<img src="https://github.com/guozhigq/pilipala/blob/main/assets/screenshots/850shots_so.png" width="32%" alt="home" />
<br/>
<img src="https://github.com/guozhigq/pilipala/blob/main/assets/screenshots/main_screen.png" width="96%" alt="home" />
<br/>
</div>

## 开发环境

Xcode 13.4 不支持 ```auto_orientation```，请注释相关代码

```bash
[✓] Flutter (Channel stable, 3.16.5, on macOS 14.1.2 23B92 darwin-arm64, locale
    zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 15.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.3)
[✓] VS Code (version 1.87.2)
[✓] Connected device (3 available)
[✓] Network resources
```

## 技术交流

Telegram: [https://t.me/+1DFtqS6usUM5MDNl](https://t.me/+1DFtqS6usUM5MDNl)

Telegram Beta 版本：@PiliPala_Beta

QQ 频道: https://pd.qq.com/s/365esodk3

## 功能

目前着重移动端 (Android、iOS)，暂时没有适配桌面端、Pad 端、手表端等

现有功能及[开发计划](https://github.com/users/guozhigq/projects/5)

- [x] 推荐视频列表 (app 端)
- [x] 最热视频列表
- [x] 热门直播
- [x] 番剧列表
- [x] 屏蔽黑名单内用户视频
- [x] 排行榜

- [x] 用户相关
  - [x] 粉丝、关注用户、拉黑用户查看
  - [x] 用户主页查看
  - [x] 关注/取关用户
  - [ ] 离线缓存
  - [x] 稍后再看
  - [x] 观看记录
  - [x] 我的收藏
  - [x] 黑名单管理 
  
- [x] 动态相关
  - [x] 全部、投稿、番剧分类查看
  - [x] 动态评论查看
  - [x] 动态评论回复功能
  - [x] 动态未读标记 

- [x] 视频播放相关
  - [x] 双击快进/快退
  - [x] 双击播放/暂停
  - [x] 垂直方向调节亮度/音量
  - [x] 垂直方向上滑全屏、下滑退出全屏
  - [x] 水平方向手势快进/快退
  - [x] 全屏方向设置
  - [x] 倍速选择/长按 2 倍速
  - [x] 硬件加速 (视机型而定)
  - [x] 画质选择 (高清画质未解锁)
  - [x] 音质选择 (视视频而定)
  - [x] 解码格式选择 (视视频而定)
  - [x] 弹幕
  - [x] 字幕
  - [x] 记忆播放
  - [x] 视频比例：高度/宽度适应、填充、包含等
     
- [x] 搜索相关
  - [x] 热搜
  - [x] 搜索历史
  - [x] 默认搜索词
  - [x] 投稿、番剧、直播间、用户搜索
  - [x] 视频搜索排序、按时长筛选
    
- [x] 视频详情页相关
  - [x] 视频选集 (分 p) 切换
  - [x] 点赞、投币、收藏/取消收藏
  - [x] 相关视频查看
  - [x] 评论用户身份标识
  - [x] 评论 (排序) 查看、二楼评论查看
  - [x] 主楼、二楼评论/表情回复功能
  - [x] 评论点赞
  - [x] 评论笔记图片查看、保存

- [x] 设置相关
  - [x] 画质、音质、解码方式预设      
  - [x] 图片质量设定
  - [x] 主题模式：亮色/暗色/跟随系统
  - [x] 震动反馈 (可选)
  - [x] 高帧率
  - [x] 自动全屏
- [ ] 等等

## 下载

可以通过右侧 Releases 进行下载或拉取代码到本地进行编译

### 从 F-Droid 安装

<a href="https://f-droid.org/packages/com.guozhigq.pilipala">
    <img src="https://fdroid.gitlab.io/artwork/badge/get-it-on-zh-cn.png"
    alt="Get it on F-Droid"
    height="80">
</a>

## 声明

此项目 (PiliPala) 是个人为了兴趣而开发, 仅用于学习和测试。
所用 API 皆从官方网站收集, 不提供任何破解内容。

感谢使用

## 致谢

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)
- [media-kit](https://github.com/media-kit/media-kit)
- [dio](https://pub.dev/packages/dio)
- 等等
