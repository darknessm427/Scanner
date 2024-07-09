# better-cloudflare-ip

Find the best Cloudflare Anycast IP for your current network environment

The old version will stop serving soon, and subsequent versions will not be updated if there are no obvious bugs!

## Instructions for use

This project focuses on studying the relationship between packet loss rate and network speed in anycast technology. It is for learning purposes only.

Prohibited use range guidelines are as follows:

a) Relevant agencies have warned that web pages are threatening, and websites that have illegal information.

b) Hospital-type websites (hospitals for abortion, dermatology, sexually transmitted diseases, etc.), websites that have not obtained qualifications from the Ministry of Health.

c) The main content of the website contains pornography (video dating, one-night stand dating), illegality (forging certificates, selling imitation guns), feudal superstition, game private servers, game plug-ins, online earning, gender, beauty stickers and animation stickers (too large) , gambling (including the sale of gambling tools.), gambling and other contents.

d) There are malicious rogue advertisements on the website (there are illegal content video links and illegal web content links).

e) Any behavior on the website that damages or attempts to damage network security, including malicious scanning of websites and network-related software and hardware, illegal intrusion into systems, and illegal acquisition of data through viruses, Trojans, malicious codes, phishing, etc.

f) Websites whose content has copyright risks (video, novels, music, etc.).

g) The website contains the sales of medicines and health care products, but does not obtain qualifications, or seriously exaggerates the facts about the efficacy of medicines.

h) The main business of the website is to provide services such as payment, trading platform, guarantee, and agency for foreign financial management (stock speculation, spot speculation, gold speculation) to illegal websites.

i) There are a large number of websites containing content that affects social harmony and stability (websites suspected of attacking the country, attacking leaders, attacking people, and websites with inciting speeches).

j) The content of the website contains other content not allowed by relevant national laws and regulations.

k) The website content contains VPN, network proxy and other contents.

l) Websites that interfere with the normal operation of all Cloudflare products through technical or non-technical means.

m) Website content that publishes false and untrue news or infringes upon the legitimate rights and interests of others.

n) Obtaining website content requires logging in, etc. Websites whose content cannot be reviewed cannot be viewed directly.

o) Websites that provide download services for movies, TV shows, software, and applications.

## User data security statement

This version does not require users to upload any data to the server. The server only provides IP address pool maintenance and issuance!

## User-defined data

Users can customize the IP address segments of ips-v4.txt and ips-v6.txt. If data update is used, the local customized data will be overwritten.

The content format of custom ips-v4.txt is the CIDR writing method of x.x.x.x or x.x.x.x/x. The first three digits are extracted by default.

The content format of custom ips-v6.txt is the CIDR writing method of x:x:x:x:x:x:x:x or x:x:x:x:x:x:x:x/x, which is extracted by default :top three

More customized gameplay is waiting for users to discover by themselves

## Windows batch version

Please download the Release version to use, do not use Git Clone to download (garbled characters will appear)

Windows 7 users are recommended to use the ANSI encoding version

Users of Windows 8 and above are recommended to use the UTF-8 encoding version.

Note: The ANSI encoding version can be used on all Windows platforms. BUGs in some Windows systems will cause the console to output garbled characters.

click to download[Windows version](https://github.com/badafans/better-cloudflare-ip/releases/latest/download/batch.zip)

## Linux version

Completely copy and paste the link below into the console and press Enter. For subsequent runs, just enter ./cf.sh and press Enter.

Currently tested on Termux, OpenWrt, Ubuntu, Debian, CentOS, MacOS, Raspbian, Armbian, iSH

```bash
curl https://raw.githubusercontent.com/badafans/better-cloudflare-ip/master/shell/cf.sh -o cf.sh && chmod +x cf.sh && ./cf.sh
```

## Reference statement

For Cloudflare ASN<https://bgp.he.net/AS13335>, Cloudflare IP Ranges come from<https://www.cloudflare.com/zh-cn/ips/>
