# Validation Template

生成完成后必须逐项执行以下检查。**不可跳过任何一项。**

---

## Validation Checklist

### Check 1: CLAUDE.md 存在性

确认项目根目录有 `CLAUDE.md` 且包含 skill-tree 路由协议。

操作: 检查 CLAUDE.md 是否已包含 `# Skill-Tree Routing Protocol [MANDATORY]` 或类似内容。
如果不存在: 在 CLAUDE.md 中添加以下内容:

# Skill-Tree Routing Protocol [MANDATORY]
在处理任何用户任务之前，执行以下路由流程：

## Step 1: 扫描Skill-Tree
扫描 `.claude/skills/` 目录下所有以 `-tree` 结尾的skill-tree目录，读取每个skill-tree的 `ROOT.md` 文件。

```bash
# 查找所有skill-tree的ROOT.md
glob: .claude/skills/*-tree/ROOT.md
```

**通过标准**: CLAUDE.md 已存在且包含路由协议，或已成功添加。

---

### Check 2: Coverage (能力覆盖率)

- 统计源 skill 中的每个能力
- 确认每个能力恰好出现在一个叶节点中
- 确认 SKILL-TREE.md 映射表中的总数与实际一致

**操作步骤**:
1. 列出源 skill 的所有功能点
2. 逐个检查是否在每个叶节点中出现
3. 核对 SKILL-TREE.md 中的统计数字

**通过标准**: 每个源能力恰好对应一个叶节点，映射表计数准确。

---

### Check 3: Reachability (可达性)

- 从 ROOT.md 出发追踪每条路由到叶节点
- 确认所有叶文件均可达
- 标记任何孤儿文件

**操作步骤**:
1. 列出 ROOT.md 中所有路由目标
2. 对每个 ROUTER.md，列出所有下一跳
3. 列出所有实际存在的 .md 文件
4. 确认每个文件都被某条路由覆盖

**通过标准**: 所有文件均可从 ROOT.md 通过路由到达，无孤儿文件。

---

### Check 4: Disambiguation (消歧完整性)

- 识别出现在多个兄弟节点中的关键词
- 对于 Multi-Skill 树：确认 ROOT.md 对每个共享关键词有消歧规则

**操作步骤**:
1. 收集所有叶节点的触发关键词
2. 找出在 2+ 个节点中出现的词
3. 检查 ROOT.md 的消歧规则是否覆盖每个共享词

**通过标准**: 每个共享关键词在消歧规则中有明确处理。

---

### Check 5: Depth (深度)

- 从 ROOT.md 到任何叶节点的路径不得超过 4 级

**操作步骤**:
1. 对每个叶节点，计算 ROOT → ... → LEAF 的层级数
2. 确认最大深度 ≤ 4

**通过标准**: 所有叶节点深度 ≤ 4。

---

### Check 6: Keyword Quality (关键词质量)

- 每个叶节点必须有清晰、互斥的触发条件
- 适用时包含双语关键词

**操作步骤**:
1. 检查每个叶节点是否有中英文关键词
2. 检查同层节点的触发条件是否互斥
3. 确认有"其他/默认"兜底路由

**通过标准**: 每个叶节点有明确触发条件，同层条件互斥，有兜底路由。

---

### Check 7: Cross-reference Integrity (交叉引用完整性)

- 每个 "Related Skills" 路径必须解析到实际存在的文件
- 兄弟引用使用 `../{sibling}/SKILL.md`，而非 `./{sibling}/SKILL.md`

**操作步骤**:
1. 收集所有叶节点的 `Related Skills` 部分
2. 逐个验证路径是否指向真实存在的文件
3. 检查相对路径格式

**通过标准**: 所有 Related Skills 引用均有效且路径格式正确。

---

### Check 8: Functional Routing Tests (功能路由测试)

构造 ≥ 5 个测试用例（3 简单 + 2 复杂），模拟用户 prompt：

| # | 类型 | 要求 |
|---|------|------|
| 1 | 简单 | 使用唯一关键词，直接路由到单个叶节点 |
| 2 | 简单 | 使用另一个领域的关键词 |
| 3 | 简单 | 使用第三个领域的关键词 |
| 4 | 复杂 | 使用领域专用术语，验证路由精度 |
| 5 | 复杂 | 包含冲突信号，验证信号优先级 |

**操作步骤**:
对每个测试用例，手动追踪 ROOT → ROUTER → LEAF 的路径。

**通过标准**: 所有测试用例都能正确路由到预期叶节点。

---

### Check 9: Content Preservation (内容保留)

- 确认源 skill 中的所有内容在叶节点中都有保留
- 源 skill 中的指令在拆分过程中没有丢失

**操作步骤**:
1. 读取每个源 skill 的完整内容
2. 确认每段指令/公式/代码都出现在对应的叶节点中
3. 特别注意数值、阈值、具体实现细节

**通过标准**: 源 skill 的所有执行级指令完整迁移到叶节点。

---

### Check 10: Reference Leaf Self-Containment (参考叶自包含)

- 识别所有作为参考数据的叶节点（特征字典、换算表、API 规格等）
- 确认每个参考叶内联了**完整数据**——不是指向外部源的 stub
- agent 仅加载 tree 就必须具备执行所需的一切

**操作步骤**:
1. 识别哪些叶节点包含参考数据
2. 检查是否所有数据都直接内联在文件中
3. 确认没有只包含标题+摘要+外部链接的 stub 文件

**通过标准**: 所有参考叶自包含完整数据。

---

## Multi-Skill 额外检查 (仅 Multi-Skill 树)

### Check M1: Shared Keyword Coverage
- 列出 2+ 个 skill 共有的所有能力
- 确认 ROOT.md 的消歧规则覆盖每个共享词

### Check M2: Cross-Skill Path Non-interference
- 追踪 3+ 条来自不同 skill 的路由
- 确认没有错误路由到其他 skill 子树

### Check M3: Shared Leaf Accuracy
- 对于 Shared-identical 叶节点：确认指令完全相同
- 如果指令有任何差异，拆分为独立叶节点

### Check M4: Cross-Cutting Workflow Coverage
- 对每个 skill，确认 cross-cutting/SKILL.md 至少有一个涉及它的工作流
- 确认 cross-cutting 列出了所有 skill 的依赖关系

---

## Validation Failure Protocol

如果任何检查失败：
1. 直接在生成的文件中修复问题
2. 重新运行失败的检查以确认修复
3. 记录问题类型用于未来改进
