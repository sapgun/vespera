from dataclasses import dataclass

@dataclass
class RouteResult:
    route_type: str
    primary: str
    secondary: str
    reviewer: str
    permission_level: int
    suggested_prompt: str

ROUTES = [
    {
        "name": "debug",
        "keywords": ["error", "failed", "build", "deploy", "npm", "pnpm", "yarn", "module not found", "hydration", "vercel", "netlify", "에러", "실패", "빌드"],
        "primary": "codex",
        "secondary": "claude_code",
        "reviewer": "chatgpt",
        "level": 1,
        "prompt": "Analyze the error, identify the root cause, and suggest the minimal safe fix.",
    },
    {
        "name": "asset",
        "keywords": ["asset", "image", "video", "thumbnail", "infographic", "file", "에셋", "이미지", "영상", "썸네일", "인포그래픽", "파일"],
        "primary": "local_llm",
        "secondary": "hermes",
        "reviewer": "sapgun",
        "level": 2,
        "prompt": "Classify the asset, suggest filename and destination, but do not move or rename without human approval.",
    },
    {
        "name": "docs",
        "keywords": ["readme", "docs", "documentation", "guide", "whitepaper", "문서", "가이드", "백서"],
        "primary": "chatgpt",
        "secondary": "claude_code",
        "reviewer": "gemini",
        "level": 1,
        "prompt": "Create clear documentation with structure, setup steps, limitations, and examples.",
    },
    {
        "name": "github",
        "keywords": ["issue", "pr", "pull request", "github", "commit", "이슈", "풀리퀘스트", "커밋"],
        "primary": "jules",
        "secondary": "codex",
        "reviewer": "sapgun",
        "level": 2,
        "prompt": "Convert this into a small GitHub task or PR plan. Do not create or merge without approval.",
    },
    {
        "name": "strategy",
        "keywords": ["strategy", "business", "mvp", "roadmap", "product", "기획", "전략", "비즈니스", "로드맵"],
        "primary": "chatgpt",
        "secondary": "gemini",
        "reviewer": "grok",
        "level": 0,
        "prompt": "Clarify the product goal, MVP scope, risks, and next actions.",
    },
]

def route_task(task: str) -> RouteResult:
    lower_task = task.lower()

    for route in ROUTES:
        for keyword in route["keywords"]:
            if keyword.lower() in lower_task:
                return RouteResult(
                    route_type=route["name"],
                    primary=route["primary"],
                    secondary=route["secondary"],
                    reviewer=route["reviewer"],
                    permission_level=route["level"],
                    suggested_prompt=route["prompt"],
                )

    return RouteResult(
        route_type="default",
        primary="chatgpt",
        secondary="gemini",
        reviewer="sapgun",
        permission_level=0,
        suggested_prompt="Clarify the task, classify it, and recommend the safest next action.",
    )
