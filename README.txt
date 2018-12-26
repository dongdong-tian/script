脚本执行依赖条件
1.运行脚本机器必须可以访问外网
2.机器必须有本机yum或者网络yum
3.通过tar  -Pxf  envauto.tar.gz 进行解压,会在/出现一个envauto目录.
4.执行deploy.sh脚本即可。

/envauto
├── function_lib
│   └── function_lib.sh
└── script
    └── deploy.sh
