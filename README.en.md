# cloudflare-ip

Find the best Cloudflare Anycast IP for your current network environment

## Instructions for use

This project focuses on studying the relationship between packet loss rate and network speed in anycast technology and is for learning purposes only.

The instructions are as follows:

a) Relevant agencies have warned that web pages are threatening and websites that contain illegal information.

b) Hospital websites (hospitals for abortion, dermatology, sexually transmitted diseases, etc.), websites that have not received an educational certificate from the Ministry of Health.

c) The main content of the website includes pornography (video dating, one night stand), illegal (license forgery, sale of imitation guns), feudal superstition, private game servers, game add-ons, online income, sex, beauty tags. and animation tags (very large), gambling (including the sale of gambling tools.), gambling and other content.

d) There are rogue malicious advertisements on the website (there are video links to illegal content and links to illegal web content).

e) Any conduct on the Website that harms or attempts to harm network security, including malicious scanning of websites and network-related software and hardware, illegal intrusion into systems, and acquisition Illegality of data through viruses, trojans, malicious codes, phishing etc. .

f) Websites whose content has copyright risks (videos, novels, music, etc.).

g) The website contains the sale of drugs and health care products, but does not obtain the necessary qualifications, or seriously exaggerates the facts about the effectiveness of the drugs.

h) The main activity of the website is to provide services such as payment, transaction platform, guarantee and representation of foreign financial management (speculation, speculation, gold speculation) to illegal websites.

i) There are a large number of websites containing content that affects social harmony and stability (websites suspected of attacking the country, attacking leaders, attacking people, and websites with provocative speeches).

j) The content of the website contains other content that is not allowed by the relevant national laws and regulations.

k) The content of the website contains VPN, network proxy and other content.

l) Websites that interfere with the normal functioning of all Cloudflare products by technical or non-technical means.

m) Website content that publishes false and untrue news or violates the rights and legitimate interests of others.

n) Obtaining website content requires logging in, etc. Websites whose content is not reviewable are not directly viewable.

o) Websites that provide download services for movies, TV shows, software and programs.

## User data security statement

این نسخه نیازی به آپلود هیچ داده ای از سوی کاربران ندارد. سرور فقط نگهداری و صدور آدرس IP را ارائه می دهد.

## User-defined data

Users can customize IP address sections of ips-v4.txt and ips-v6.txt, local customized data will be overwritten if data update is used.

Custom content format ips-v4.txt CIDR writing method is x.x.x.x or x.x.x.x/x. The first three digits are extracted by default.

The ips-v6.txt custom content format is the CIDR writing method x:x:x:x:x:x:x:x or x:x:x:x:x:x:x:x/x, which is The assumption is extracted: top three

More customized gameplay is waiting for users to discover it themselves

## Batch version of Windows

Please download the Release version to use, do not use Git Clone to download (garbled characters appear)

Windows 7 users are advised to use the ANSI encoding version

Users of Windows 8 and above are recommended to use the UTF-8 encoding version.

Note: The ANSI encoding version can be used on all Windows platforms. BUGs in some Windows systems will cause the console to output garbled characters.

Click to download[Windows version](https://github.com/badafans/better-cloudflare-ip/releases/latest/download/batch.zip)

## Linux version

Copy and paste the link below completely into the console and for subsequent runs, just type ./cf.sh and press Enter.

Currently tested on Termux, OpenWrt, Ubuntu, Debian, CentOS, MacOS, Raspbian, Armbian, iSH.

```bash
curl https://raw.githubusercontent.com/darknessm427/Scanner/master/shell/cf.sh -o cf.sh && chmod +x cf.sh && ./cf.sh
```

## Reference statement

For Cloudflare ASN<https://bgp.he.net/AS13335>, the Cloudflare IP range comes from<https://www.cloudflare.com/zh-cn/ips/>
