安装方法：

将skill-tree-generator放工程目录的.claude/skills下

打开claude code

./scripts/aggregate-skills.sh .claude/skills

skill-tree将生成在指定目录下，同时根目录生成一个CLAUDE.md（若存在则增加内容）

CLAUDE.md主要是注入skill-tree的路由扫描，可参考skill-tree-generator\references\validation_template.md中Validation Checklist的Check 1


