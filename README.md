# 说明

项目包括四个文件夹，分别为 app、kernel、server 和 ardunio。  
- `kernel` 文件夹为我们所使用的内核文件，基于 Toybrick 的内核进行了相关配置（原项目见https://github.com/rockchip-toybrick/kernel），配置文件为文件夹内的 `.config` 文件。此外，最终生成的镜像文件在 `kernel/boot_linux.img`，可以直接烧写到 Toybrick-RK3399ProD 开发板中。（顺便一提，原来的配置有巨多的坑；即使改完之后，这个内核依旧无法正常连接 Wi-Fi，只能通过有线网连接网络）
- `arduino` 为我们烧录在 arduino UNO R3 开发板上的代码。
- `server` 文件夹为我们部署在 Toybrick-RK3399ProD 开发板上的服务器文件，运行 `server.py` 即可。
- `app` 文件夹为使用 Flutter 编写的手机 app 源码。注意：目前的板子 ip 是写死在了 `app/lib/utils.dart` 内，使用时应按需更改为板子所在的 ip。