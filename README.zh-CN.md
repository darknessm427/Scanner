# cloudflare-ip

找到最适合您当前网络环境的 Cloudflare Anycast IP

## 使用说明

本项目重点研究任播技术中丢包率与网络速度的关系，仅供学习之用。

说明如下：

a) 有关机构对威胁网页和含有非法信息的网站发出警告。

b) 医院网站（堕胎、皮肤科、性病等医院）、未获得卫生部教育证书的网站。

c) 网站主要内容包括色情（视频交友、一夜情）、非法（伪造许可证、出售仿真枪）、封建迷信、私人游戏服务器、游戏外挂、网络收入、色情、美女标签。以及动画标签（非常大）、赌博（包括出售赌博工具。）、赌博等内容。

d) 网站上存在挑衅性的恶意广告（存在非法内容的视频链接、非法网页内容的链接）。

e) 在本网站上进行的任何危害或企图危害网络安全的行为，包括恶意扫描网站及网络相关软硬件、非法侵入系统以及通过病毒、木马、恶意代码、网络钓鱼等方式获取非法数据。 。

f) 内容存在版权风险的网站（视频、小说、音乐等）。

g) 网站含有药品、保健品销售内容，但未取得必要资质，或严重夸大药品功效事实的。

h) 该网站的主要活动是向非法网站提供支付、交易平台、担保、代理境外理财（投机、投机、炒金）等服务。

i) 存在大量含有影响社会和谐稳定内容的网站（涉嫌攻击国家、攻击领导人、攻击人民、发表挑衅性言论的网站）。

j) 本网站内容含有国家相关法律法规不允许的其他内容。

k) 网站内容包含VPN、网络代理等内容。

l) 通过技术或非技术手段干扰所有 Cloudflare 产品正常运行的网站。

m) 发布虚假、不实新闻或侵犯他人权利及合法利益的网站内容。

n) 获取网站内容需要登录等。内容不可审查的网站不可直接查看。

o) 提供电影、电视节目、软件和程序下载服务的网站。

## 用户数据安全声明

该版本不需要用户上传任何数据。服务器仅提供IP地址的维护和发放。

## 用户定义数据

用户可以自定义ips-v4.txt和ips-v6.txt的IP地址部分，如果使用数据更新，本地自定义数据将被覆盖。

自定义内容格式 ips-v4.txt CIDR 写入方式为 x.x.x.x 或 x.x.x.x/x。默认情况下提取前三位数字。

ips-v6.txt自定义内容格式为CIDR写法x:x:x:x:x:x:x:x或x:x:x:x:x:x:x:x/x，即提取假设：前三名

更多定制玩法等待用户自行发现

## Windows 的批处理版本

请下载Release版本使用，请勿使用Git Clone下载（出现乱码）

建议Windows 7用户使用ANSI编码版本

Windows 8及以上版本的用户建议使用UTF-8编码版本。

注:ANSI编码版本可以Windows全平台通用，部分Windows系统的BUG会导致控制台输出乱码

点击下载[Windows版本](https://github.com/badafans/better-cloudflare-ip/releases/latest/download/batch.zip)

## Linux版本

将下面的链接完全复制并粘贴到控制台中，对于后续运行，只需键入 ./cf.sh 并按 Enter 键。

目前已在 Termux、OpenWrt、Ubuntu、Debian、CentOS、MacOS、Raspbian、Armbian、iSH 上进行测试。

```bash
curl https://raw.githubusercontent.com/darknessm427/Scanner/master/shell/cis.sh -o cis.sh && chmod +x cis.sh && ./cis.sh
```

## 参考声明

对于 Cloudflare ASN<https://bgp.he.net/AS13335>，Cloudflare IP 范围来自[HTTPS://呜呜呜.cloud flare.com/这-才能/IPS/](https://www.cloudflare.com/zh-cn/ips/)
