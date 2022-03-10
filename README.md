# PSAsmrOnlineClient
A Powershell Asmr Online Client

## System Requirement
- Windows 7 or newer (Tested on Windows 10)
- Powershell 6 (Tested on Powershell 7)

## Usage
```asmrOnlineClient.ps1 [-InputFilePath <string>] [-LosslessMode <string>] [-ConfigFilePath <string>] [<CommonParameters>]```
- -InputFilePath 待下载资源 RJ 号列表文件位置（默认为当前文件夹下的 input.json）文件格式：`["RJ1111", "RJ2222"]` 或 `[1111, 2222]`
- -LosslessMode 下载的音频类型（默认为`"All"`，且会覆盖 config.json 中的配置）: `"Lossless"`（无损）、`"Lossy"`（有损）、`"All"`（全部下载）
- -ConfigFilePath 配置文件位置（默认为当前文件夹下的 config.json）JSON Schema 见 Config JSON Schema

```asmrOnlineClient.ps1 -Search -KeyWord <string> [-LosslessMode <string>] [-ConfigFilePath <string>] [<CommonParameters>]```
- -Search 设定为搜索模式
- -KeyWord 搜索关键词
- -LosslessMode 下载的音频类型（默认为`"All"`，且会覆盖 config.json 中的配置）: `"Lossless"`（无损）、`"Lossy"`（有损）、`"All"`（全部下载）
- -ConfigFilePath 配置文件位置（默认为当前文件夹下的 config.json）JSON Schema 见 Config JSON Schema

```asmrOnlineClient.ps1 -Login -Username <string> -Password <securestring> [-ConfigFilePath <string>] [<CommonParameters>]```
- -Login 设定为登录模式
- -Username 用户名
- -Password 密码（类型为安全字符串），如果不知道如何输入安全字符串，该项请留空或不进行输入，系统会自动切换至输入安全字符串的模式
- -ConfigFilePath 配置文件位置，此处会将获取的用户令牌存入相应的 config.json（默认为当前文件夹下的 config.json）JSON Schema 见 Config JSON Schema
## Config JSON Schema
```
{
    "$schema": "http://json-schema.org/draft-07/schema",
    "type": "object",
    "required": [
        "token"
    ],
    "properties": {
        "token": {
            "title": "用户令牌",
            "type": "string",
            "pattern": "(?:\\w|\\+|/|=)+\\.(?:\\w|\\+|/|=)+\\.(?:\\w|\\+|/|=|-|_)+"
        },
        "losslessMode": {
            "title": "音频类型",
            "type": "string",
            "enum": [
                "All",
                "Lossless",
                "Lossy"
            ]
        },
        "outputPattern": {
            "title": "输出路径模式",
            "type": "string"
        }
    },
    "additionalProperties": true
}
```
示例：
```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxxxx.EijI_6kSony1rN68WqEgSE3nocpIOt7CLk03ljoTn9Q",
  "outputPattern": "RJ<id>"
}
```
输出路径规则：
标签 | 输出
----|----
`<id>` | RJ 号（不带 RJ）
`<title>` | 标题
`<circle>` | 社团名
`<vas>` | 声优
`<tags>` | 社团
