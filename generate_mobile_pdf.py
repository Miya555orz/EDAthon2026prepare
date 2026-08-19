from __future__ import annotations

from pathlib import Path
import re

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A5
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
    PageBreak,
    KeepTogether,
)


OUT = Path(r"D:\EDAthon2026\EDAthon2026prepare\EDAthon2026_明日比赛流程_手机速查.pdf")


def register_font() -> tuple[str, str]:
    candidates = [
        Path(r"C:\Windows\Fonts\msyh.ttc"),
        Path(r"C:\Windows\Fonts\simsun.ttc"),
        Path(r"C:\Windows\Fonts\simhei.ttf"),
    ]
    for p in candidates:
        if p.exists():
            try:
                pdfmetrics.registerFont(TTFont("CJK", str(p)))
                pdfmetrics.registerFont(TTFont("CJKBold", str(p)))
                return "CJK", "CJKBold"
            except Exception:
                pass
    pdfmetrics.registerFont(UnicodeCIDFont("STSong-Light"))
    return "STSong-Light", "STSong-Light"


FONT, FONT_BOLD = register_font()


def esc(text: str) -> str:
    return (
        text.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\n", "<br/>")
    )


styles = getSampleStyleSheet()
TITLE = ParagraphStyle(
    "TitleCJK",
    parent=styles["Title"],
    fontName=FONT_BOLD,
    fontSize=18,
    leading=22,
    alignment=TA_CENTER,
    spaceAfter=8,
    textColor=colors.HexColor("#102030"),
)
SUBTITLE = ParagraphStyle(
    "SubTitleCJK",
    parent=styles["Normal"],
    fontName=FONT,
    fontSize=9,
    leading=12,
    alignment=TA_CENTER,
    textColor=colors.HexColor("#445064"),
    spaceAfter=8,
)
H1 = ParagraphStyle(
    "H1CJK",
    parent=styles["Heading1"],
    fontName=FONT_BOLD,
    fontSize=13,
    leading=16,
    spaceBefore=6,
    spaceAfter=4,
    textColor=colors.HexColor("#17365d"),
)
H2 = ParagraphStyle(
    "H2CJK",
    parent=styles["Heading2"],
    fontName=FONT_BOLD,
    fontSize=10.5,
    leading=13,
    spaceBefore=5,
    spaceAfter=3,
    textColor=colors.HexColor("#8a4b08"),
)
BODY = ParagraphStyle(
    "BodyCJK",
    parent=styles["BodyText"],
    fontName=FONT,
    fontSize=8.8,
    leading=11.5,
    alignment=TA_LEFT,
    spaceAfter=3,
)
SMALL = ParagraphStyle(
    "SmallCJK",
    parent=BODY,
    fontSize=7.6,
    leading=9.4,
    textColor=colors.HexColor("#333333"),
)
CODE = ParagraphStyle(
    "CodeCJK",
    parent=BODY,
    fontName=FONT,
    fontSize=7.2,
    leading=9.2,
    leftIndent=4,
    rightIndent=4,
    backColor=colors.HexColor("#f4f6f8"),
    borderColor=colors.HexColor("#d5dbe3"),
    borderWidth=0.4,
    borderPadding=3,
    spaceBefore=2,
    spaceAfter=5,
)
BOX = ParagraphStyle(
    "BoxCJK",
    parent=BODY,
    fontName=FONT_BOLD,
    fontSize=9,
    leading=12,
    backColor=colors.HexColor("#fff4db"),
    borderColor=colors.HexColor("#f0b84d"),
    borderWidth=0.6,
    borderPadding=5,
    spaceBefore=4,
    spaceAfter=5,
)


def p(text: str, style=BODY):
    return Paragraph(esc(text), style)


def code(text: str):
    return Paragraph(esc(text), CODE)


def table(rows, widths=None):
    data = [[p(str(cell), SMALL) for cell in row] for row in rows]
    t = Table(data, colWidths=widths, hAlign="LEFT")
    t.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, -1), FONT),
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#eaf2ff")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#102030")),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b8c2cc")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 3),
                ("RIGHTPADDING", (0, 0), (-1, -1), 3),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
            ]
        )
    )
    return t


def bullet(items):
    out = []
    for item in items:
        out.append(p("• " + item))
    return out


story = []
story.append(p("EDAthon2026 明日比赛流程 + 出行速查", TITLE))
story.append(p("手机版 | 2026-08-20 香港城市大学 | 睡前版", SUBTITLE))
story.append(
    p(
        "最重要：正式评分只看远程 Docker 容器里的 /workspace/submission/。"
        "机房电脑和远程容器磁盘互不相通，本地做完必须上传，或直接在远程容器里做。",
        BOX,
    )
)

story.append(p("0. OpenRouter API 是干啥的", H1))
story.append(
    p(
        "OpenRouter API key 是 OpenCode 调用大模型的钥匙：OpenCode -> OpenRouter -> DeepSeek V4 Flash。"
        "它不是 SSH 密码、不是 Docker 密码、不是提交入口、不是评分器。比赛环境已经配置好，"
        "不要运行 /connect，不要自己粘 key，不要改模型配置。"
    )
)
story.append(code(
    "# 只需要检查 key 是否可用：\n"
    "cd /workspace\n"
    "python3 /workspace/toolkit/tools/check_api_key.py\n\n"
    "# 然后打开 OpenCode：\n"
    "opencode"
))

story.append(p("1. 明天你会拿到什么环境", H1))
story.append(
    table(
        [
            ["环境", "用途", "是否计分"],
            ["机房电脑 A/B", "读题、改 case、跑公开自测", "否，除非上传到远程容器"],
            ["远程 Docker 容器", "正式答案所在地，也可以直接开发", "是，只收集 /workspace/submission/"],
        ],
        [25 * mm, 62 * mm, 52 * mm],
    )
)
story.append(Spacer(1, 3))
story += bullet(
    [
        "每队可用两台机房电脑，并通过 SSH 登录同一个远程 Docker 容器。",
        "评分时仅以远程 Docker 容器中的答案为准。",
        "每个座位有一个英规电源插口；英规转接头自备。",
    ]
)

story.append(p("2. /workspace 到底在哪里", H1))
story.append(
    p(
        "正式比赛里，/workspace 是远程 Docker 容器内部的工作目录。"
        "VS Code Remote SSH 连接后，应打开远程文件夹 /workspace。"
    )
)
story.append(
    p(
        "你本地练习时的 Windows 题目包目录 D:\\edathon-problems-toolkit-20260819，"
        "通过 docker --mount 映射到容器内 /workspace。也就是说，本地 Docker 里看到的 /workspace "
        "对应 Windows 上这个题目包总文件夹。正式远程容器里的 /workspace 则在远程机器上，不等于你的 Windows D 盘。"
    )
)
story.append(code(
    '$Ws = "D:\\edathon-problems-toolkit-20260819"\n'
    'docker run --mount "type=bind,source=$Ws,target=/workspace" ...\n\n'
    "# 容器内：\n"
    "cd /workspace"
))

story.append(p("2.5 PowerShell 本地练习命令", H1))
story.append(code(
    '# 启动 Docker Desktop\n'
    'Start-Process "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"\n\n'
    '# 检查 Docker\n'
    'docker version\n'
    'docker images\n\n'
    '# 启动本地容器，把 D 盘题目包映射成 /workspace\n'
    '$Ws = "D:\\edathon-problems-toolkit-20260819"\n'
    '$Img = "edathon-openroad-tools:local"\n'
    'docker run --rm -it `\n'
    '  --name edathon-work `\n'
    '  --mount "type=bind,source=$Ws,target=/workspace" `\n'
    '  --workdir /workspace `\n'
    '  $Img `\n'
    '  bash\n\n'
    '# 如果容器已经开着，新开 PowerShell 进入：\n'
    'docker ps\n'
    'docker exec -it edathon-work bash'
))

story.append(p("3. 远程连接和开赛检查", H1))
story += bullet(
    [
        "SSH 端口 = 2200 + 队伍编号，例如 team07 -> 2207。",
        "主机：edathon.cs.cityu.edu.hk；用户：root。",
        "密码在桌面 EDAthon/ssh_password.txt；OpenRouter key 在桌面 EDAthon/openrouter_api_key.txt。",
        "VS Code 安装 Remote - SSH 后连接远程容器，打开 /workspace。",
    ]
)
story.append(code(
    "# PowerShell/终端直连：\n"
    "ssh -p 22XX root@edathon.cs.cityu.edu.hk\n\n"
    "# VS Code 安装 Remote SSH：\n"
    "code --install-extension ms-vscode-remote.remote-ssh\n"
    "notepad $env:USERPROFILE\\.ssh\\config\n\n"
    "# SSH config 内容：\n"
    "Host edathon-remote\n"
    "    HostName edathon.cs.cityu.edu.hk\n"
    "    User root\n"
    "    Port 22XX\n\n"
    "cd /workspace\n"
    "ls problems submission toolkit\n\n"
    "cd /workspace/toolkit\n"
    "python3 tools/info.py\n"
    "python3 tools/check_api_key.py\n"
    "opencode --version"
))
story.append(p("不要运行 /connect，不要自己粘 API key，不要改模型配置。OpenCode 应显示 OpenRouter / DeepSeek V4 Flash。", BOX))

story.append(p("4. OpenCode 使用方式", H1))
story.append(code(
    "cd /workspace\n"
    "python3 /workspace/toolkit/tools/check_api_key.py\n"
    "opencode"
))
story.append(
    table(
        [
            ["操作", "命令"],
            ["新会话", "/new"],
            ["换模型", "/models"],
            ["引用文件", "@path"],
            ["自己跑命令", "!command"],
            ["退出", "/exit 或 /q"],
        ],
        [38 * mm, 98 * mm],
    )
)
story.append(p("给 Agent 任务时写清：题目/case、允许修改文件、最终提交路径、完成后检查命令。Agent 的文字结论不能替代 check.py/status.py。"))

story.append(PageBreak())

story.append(p("5. 正式提交路径", H1))
story.append(code(
    "P1  /workspace/submission/P1/<case_id>/<target_path>\n\n"
    "P2  /workspace/submission/P2/<case_id>/candidate.v\n\n"
    "P3  /workspace/submission/P3/global_place.tcl\n"
    "    /workspace/submission/P3/cases/<case_id>.tcl\n\n"
    "P4  /workspace/submission/P4/cases/<case_id>_repaired.py"
))
story += bullet(
    [
        "多余 README、日志、GDS、截图、压缩包不加分。",
        "缺一个 case 或该 case 不合法，只是该 case 记 0，不会整题作废。",
        "建议不要把整个 task 目录拷进 submission。",
    ]
)

story.append(p("6. 四题快速工作流", H1))
story.append(p("赛场上建议先运行一键安装辅助脚本。如果正式环境不允许使用自带辅助脚本，就退回官方 toolkit 命令和题目 README。", SMALL))
story.append(code(
    "# PowerShell，在本地练习包安装：\n"
    'powershell -NoProfile -ExecutionPolicy Bypass -File "D:\\EDAthon2026\\EDAthon2026prepare\\install_all_to_workspace.ps1" -WorkspacePath "D:\\edathon-problems-toolkit-20260819"\n\n'
    "# 容器内检查：\n"
    "bash /workspace/p1_env_check.sh\n"
    "bash /workspace/p2_env_check.sh\n"
    "bash /workspace/p3_env_check.sh\n"
    "bash /workspace/p4_env_check.sh"
))
story.append(p("P1 - RTL 补全", H2))
story.append(code("bash /workspace/p1_env_check.sh\n# 每个 case 以官方 testbench 仿真通过为目标。"))

story.append(p("P2 - RTL PPA 优化", H2))
story.append(code(
    "bash /workspace/p2_env_check.sh\n"
    "bash /workspace/p2_prepare_case.sh int_sqrt2\n"
    "cd /workspace/work/opencode_cases/P2/int_sqrt2\n"
    "bash /workspace/p2_prompt_for_case.sh int_sqrt2\n"
    "bash /workspace/p2_eval_case.sh int_sqrt2 fast\n"
    "bash /workspace/p2_eval_case.sh int_sqrt2 status"
))
story.append(p("P2 correctness 是硬门槛；公开 mapped area 只是 proxy，不是官方完整 PPA hidden score。", SMALL))

story.append(p("P3 - Global placement Tcl", H2))
story.append(code(
    "bash /workspace/p3_env_check.sh\n"
    "bash /workspace/p3_prepare_case.sh CAN-Bus\n"
    "cd /workspace/work/opencode_cases/P3/CAN-Bus\n"
    "bash /workspace/p3_prompt_for_case.sh CAN-Bus\n"
    "bash /workspace/p3_eval_case.sh CAN-Bus struct\n"
    "bash /workspace/p3_eval_case.sh CAN-Bus status"
))
story.append(p("P3 struct/status 不是性能分；有官方 ORFS bundle 才跑 place/full。", SMALL))

story.append(p("P4 - ASAP7 Polygon DRC 修复", H2))
story.append(code(
    "bash /workspace/p4_env_check.sh\n"
    "bash /workspace/p4_prepare_case.sh Polygon117\n"
    "cd /workspace/work/opencode_cases/P4/Polygon117\n"
    "bash /workspace/p4_summary_case.sh Polygon117\n"
    "bash /workspace/p4_prompt_for_case.sh Polygon117\n"
    "bash /workspace/p4_eval_case.sh Polygon117 quick\n"
    "TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full\n"
    "bash /workspace/p4_eval_case.sh Polygon117 status"
))
story.append(p("P4 建议 quick 过后跑 full DRC；full DRC 仍是本地 proxy，最终以官方 hidden evaluator 为准。", SMALL))

story.append(p("7. 最后 30 分钟收尾", H1))
story.append(code(
    "python3 /workspace/toolkit/tools/check.py --problem P1\n"
    "python3 /workspace/toolkit/tools/check.py --problem P2\n"
    "python3 /workspace/toolkit/tools/check.py --problem P3\n"
    "python3 /workspace/toolkit/tools/check.py --problem P4\n\n"
    "python3 /workspace/toolkit/tools/status.py --problem P1\n"
    "python3 /workspace/toolkit/tools/status.py --problem P2\n"
    "python3 /workspace/toolkit/tools/status.py --problem P3\n"
    "python3 /workspace/toolkit/tools/status.py --problem P4\n\n"
    "find /workspace/submission -maxdepth 4 -type f | sort"
))

story.append(PageBreak())

story.append(p("8. 群公告：明日赛程", H1))
story.append(
    table(
        [
            ["时间", "安排"],
            ["8:30am 前", "选手到达集结点"],
            ["9:00am - 3:00pm", "EDAthon 比赛"],
            ["12:00pm - 1:00pm", "午餐供应，自助餐，AC2 Canteen"],
            ["3:00pm - 3:30pm", "休息"],
            ["3:30pm - 5:00pm", "Mini-seminar"],
            ["5:00pm", "颁奖仪式"],
            ["6:00pm", "晚宴"],
        ],
        [40 * mm, 96 * mm],
    )
)
story.append(p("备注：群公告文字写作 12:00am-1:00pm，但结合“午餐”语境应为中午 12:00pm-1:00pm；现场以工作人员通知为准。", SMALL))

story.append(p("9. 交通与集结", H1))
story += bullet(
    [
        "自行到达香港城市大学。",
        "交通参考：https://www.cityu.edu.hk/zh-cn/about/campus/getting-to-cityu",
        "到达香港城市大学后，按公告图片指引到邵逸夫图书馆门前集结点。",
        "集结点会有志愿者持导游旗，引导选手前往赛场 LI-4307。",
    ]
)

story.append(p("10. 餐饮、网络、报销", H1))
story.append(p("餐饮", H2))
story += bullet(
    [
        "午餐为自助餐，地点在赛场楼下 AC2 Canteen。",
        "届时会有工作人员带领大家去就餐。",
        "瓶装水全天供应。",
        "有特殊饮食需求的选手，公告要求在 2026-08-19 4:00pm 前联系 CityU 工作人员胡韬。",
    ]
)
story.append(p("网络", H2))
story += bullet(["校内扫描连接免费 WiFi：Wi-Fi.HK via CityU。"])
story.append(p("报销", H2))
story += bullet(
    [
        "每队交通住宿报销上限：HKD3000；广东省内参赛队为 HKD2500。",
        "赛场签到时提交纸质报销凭证，例如发票、收据。",
        "电子版报销凭证上传：https://send2me.cn/VZ1DiqWA/ShiY_p8Z2tnL5A",
    ]
)

story.append(p("11. 睡前记忆版", H1))
story.append(
    p(
        "8:30 前到邵逸夫图书馆门前集合；带英规转接头和报销纸质凭证；"
        "比赛时打开远程 /workspace；每题答案写 /workspace/submission；"
        "最后跑 check.py/status.py；不要只信 Agent 报告。",
        BOX,
    )
)


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont(FONT, 7)
    canvas.setFillColor(colors.HexColor("#667085"))
    canvas.drawCentredString(A5[0] / 2, 6 * mm, f"EDAthon2026 mobile checklist - page {doc.page}")
    canvas.restoreState()


doc = SimpleDocTemplate(
    str(OUT),
    pagesize=A5,
    rightMargin=9 * mm,
    leftMargin=9 * mm,
    topMargin=9 * mm,
    bottomMargin=12 * mm,
    title="EDAthon2026 明日比赛流程 手机速查",
    author="Codex",
)
doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(OUT)
